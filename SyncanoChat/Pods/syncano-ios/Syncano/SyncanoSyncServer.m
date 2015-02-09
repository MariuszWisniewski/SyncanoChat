//
//  SyncanoSyncServer.m
//  Syncano
//
//  Created by Syncano Inc. on 13/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoSyncServer.h"
#import "SyncanoObjects_Private.h"
#import "SyncanoReachability.h"

#import "Syncano+Private.h"

#import <CocoaAsyncSocket/GCDAsyncSocket.h>

#import "SyncanoDateFormatter.h"

//NSString *const kSyncanoSyncServerHost = @"api.syncano.com";
//NSString *const kSyncanoSyncServerPeerName = @"*.syncano.com";

NSString *const kSyncanoSyncServerTerminalCharacter = @"}\n";

NSString *const kSyncanoSubscriptionChannelKey = @"channel";
NSString *const kSyncanoSubscriptionTargetKey = @"target";
NSString *const kSyncanoSubscriptionIdKey = @"id";
NSString *const kSyncanoObjectTypeKey = @"object";
NSString *const kSyncanoObjectTypeDataRelation = @"datarelation";

NSString *const kSyncanoSyncServerHost = @"api.syncano.com";
NSString *const kSyncanoSyncServerPeerName = @"*.syncano.com";

NSInteger const kSyncanoSyncServerPort = 8200;
NSTimeInterval const kSyncanoSyncServerDefaultTimeout = 10;
NSInteger const kSyncanoSyncServerMaxNumberOfRequests = 10;

@interface SYNQueuedRequest : NSObject
@property (strong)    SyncanoParameters *parameters;
@property (strong)    SyncanoSyncServerCallback callback;
@property (strong)    SyncanoSyncServerBatchCallback batchCallback;
- (SYNQueuedRequest *)initWithParams:(SyncanoParameters *)params
                            callback:(SyncanoSyncServerCallback)callback
                       batchCallback:(SyncanoSyncServerBatchCallback)batchCallback;
@end

@interface SYNCallback : NSObject
@property (strong)    dispatch_queue_t callbackQueue;
@property (strong)    SyncanoSyncServerCallback callback;
@property (strong)    SyncanoSyncServerBatchCallback batchCallback;
@property (strong)    Class responseClass;
@property (strong)    SyncanoParameters *parameters;
- (void)runCallbackWithObject:(id)object;
@end

#pragma mark - Private Interface
/*----------------------------------------------------------------------------*/

@interface SyncanoSyncServer () <GCDAsyncSocketDelegate>
@property (strong, readwrite)  NSString *domain;
@property (strong, readwrite)  NSString *apiKey;
@property (strong, readwrite)  NSString *uuid;

@property (strong, readwrite)  NSDate *lastPingTimestamp;

@property (strong, nonatomic)  GCDAsyncSocket *socket;
@property (strong, nonatomic)  dispatch_queue_t delegateQueue;

@property (strong, nonatomic)  NSMutableDictionary *callbacksForId;
@property (strong, nonatomic)  NSMutableArray *requestsQueue;

@property (strong, nonatomic)  NSMutableData *unprocessedData;

@property (strong, nonatomic) SyncanoReachability *reachability;

@property (strong)    SyncanoSyncServerConnectionOpenCallback connectionOpenCallback;
@property (strong)    SyncanoSyncServerConnectionClosedCallback connectionClosedCallback;
@property (strong)    SyncanoSyncServerMessageReceivedCallback messageReceivedCallback;
@property (strong)    SyncanoSyncServerHistoryReceivedCallback historyReceivedCallback;
@property (strong)    SyncanoSyncServerErrorCallback syncServerErrorCallback;
@property (strong)    SyncanoSyncServerDeletedCallback deletedCallback;
@property (strong)    SyncanoSyncServerChangedCallback changedCallback;
@property (strong)    SyncanoSyncServerAddedCallback addedCallback;
@property (strong)    SyncanoSyncServerRelationDeletedCallback relationDeletedCallback;
@property (strong)    SyncanoSyncServerRelationAddedCallback relationAddedCallback;

@property (assign)    NSInteger messageId;

@property (assign, getter = isClientLoggedIn)    BOOL clientLoggedIn;

- (BOOL)loginClient;
- (void)startSecureConnection;
- (NSData *)dataFromJSON:(NSDictionary *)dictionary;
- (id)jsonFromData:(NSData *)data;
- (void)readDataFromSocket;
- (void)receivedData:(NSData *)data tag:(long)tag;
- (SyncanoResponse *)responseForClass:(Class)class fromJSON:(NSDictionary *)json;
- (void)processAuthMessage:(NSDictionary *)json;
- (void)processPingMessage:(NSDictionary *)json;
- (void)processErrorMessage:(NSDictionary *)json;
- (void)processCallresponseMessage:(NSDictionary *)json;
- (void)processGenerealMessage:(NSDictionary *)json;
- (void)processChangedMessage:(NSDictionary *)json;
- (void)processAddedMessage:(NSDictionary *)json;
- (void)processDeletedMessage:(NSDictionary *)json;
- (void)queueRequest:(SyncanoParameters *)parameters callback:(SyncanoSyncServerCallback)callback;
- (void)dequeRequest;
@end

#pragma mark - Implementation
/*----------------------------------------------------------------------------*/

@implementation SyncanoSyncServer

#pragma mark - Private
/*----------------------------------------------------------------------------*/

- (void)log:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    if (self.logMessages) {
        NSString *log = [[NSString alloc] initWithFormat:format arguments:args];
        SyncanoDebugClassLog(@"%@",log);
    }
    va_end(args);
}

- (BOOL)loginClient {
	BOOL areAllRequiredParametersGiven = (self.apiKey && self.domain);
	if (self.isClientLoggedIn || areAllRequiredParametersGiven == NO) {
		return NO;
	}
	NSMutableDictionary *loginDict = [@{
                                      @"api_key":self.apiKey,
                                      @"instance":self.domain,
                                      @"user-agent":[Syncano userAgent]
                                      } mutableCopy];
	if (self.name.length > 0) {
		[loginDict setObject:self.name forKey:@"name"];
	}
	if (self.state.length > 0) {
		[loginDict setObject:self.state forKey:@"state"];
	}
	if (self.timezone.length > 0) {
		[loginDict setObject:self.timezone forKey:@"timezone"];
	}
	if (self.authKey.length > 0) {
		[loginDict setObject:self.authKey forKey:@"auth_key"];
	}
	if (self.sinceId) {
		[loginDict setObject:self.sinceId forKey:@"since_id"];
	}
	else if (self.sinceTime) {
		NSString *dateText = [[SyncanoDateFormatter sharedDateFormatter] stringFromDate:self.sinceTime];
		[loginDict setObject:dateText forKey:@"since_time"];
	}
	NSData *dataToSend = [self dataFromJSON:loginDict];
	[self.socket writeData:dataToSend withTimeout:-1 tag:0];
	return YES;
}

- (void)startSecureConnection {
	/*
   NSDictionary *tlsOptions = @{
   (NSString *)kCFStreamSSLLevel:(NSString *)kCFStreamSocketSecurityLevelNegotiatedSSL,
   (NSString *)kCFStreamSSLAllowsExpiredCertificates:@(YES),
   (NSString *)kCFStreamSSLAllowsExpiredRoots:@(YES),
   (NSString *)kCFStreamSSLAllowsAnyRoot:@(YES),
   (NSString *)kCFStreamSSLValidatesCertificateChain:@(NO),
   (NSString *)kCFStreamSSLPeerName:(id)kCFNull
   };
	 */
//	    /*
	NSDictionary *tlsOptions = @{
                               (NSString *)kCFStreamSSLLevel:(NSString *)kCFStreamSocketSecurityLevelNegotiatedSSL,
                               (NSString *)kCFStreamSSLPeerName:kSyncanoSyncServerPeerName
                               };
//	    */
	[self.socket startTLS:tlsOptions];
}

- (NSData *)dataFromJSON:(NSDictionary *)dictionary {
	NSMutableData *data = [[NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil] mutableCopy];
	[data appendData:[@"\n" dataUsingEncoding : NSUTF8StringEncoding]];
	return data;
}

- (id)jsonFromData:(NSData *)data {
	id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
	return json;
}

- (SyncanoResponse *)responseForClass:(Class)class fromJSON:(NSDictionary *)json {
	SyncanoResponse *response = nil;
	if ([(id)class respondsToSelector : @selector(responseFromJSON:)]) {
		response = [class performSelector:@selector(responseFromJSON:) withObject:json];
	}
	return response;
}

#pragma mark - Notifying Throught Delegate Or Callback

- (void)notifyAboutConnectionOpened {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.connectionOpenCallback) {
            self.connectionOpenCallback();
        }
        if ([self.delegate respondsToSelector:@selector(syncServerConnectionOpened:)]) {
            [self.delegate syncServerConnectionOpened:self];
        }
    });
	[self dequeRequest];
}

- (void)notifyAboutConnectionClosed:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.connectionClosedCallback) {
            self.connectionClosedCallback(error);
        }
        if ([self.delegate respondsToSelector:@selector(syncServer:connectionClosedWithError:)]) {
            [self.delegate syncServer:self connectionClosedWithError:error];
        }
    });
}

- (void)notifyAboutMessageReceived:(NSDictionary *)json {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.messageReceivedCallback) {
            self.messageReceivedCallback(json);
        }
        if ([self.delegate respondsToSelector:@selector(syncServer:messageReceived:)]) {
            [self.delegate syncServer:self messageReceived:json];
        }
    });
}

- (void)notifyAboutHistoryReceived:(NSDictionary *)history isLastOne:(BOOL)isLastOne {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.historyReceivedCallback) {
            self.historyReceivedCallback(history, isLastOne);
        }
        if ([self.delegate respondsToSelector:@selector(syncServer:historyReceived:isLastHistoryItem:)]) {
            [self.delegate syncServer:self historyReceived:history isLastHistoryItem:isLastOne];
        }
    });
}

- (void)notifyAboutSyncServerError:(NSString *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.syncServerErrorCallback) {
            self.syncServerErrorCallback(error);
        }
        if ([self.delegate respondsToSelector:@selector(syncServer:errorReceived:)]) {
            [self.delegate syncServer:self errorReceived:error];
        }
    });
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)notifyAboutDeletedObjects:(NSArray *)targets
                          channel:(SyncanoChannel *)channel {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.deletedCallback) {
            self.deletedCallback(targets, channel);
        }
        if ([self.delegate respondsToSelector:@selector(syncServer:notificationDeleted:)]) {
            [self.delegate syncServer:self notificationDeleted:targets];
        }
        if ([self.delegate respondsToSelector:@selector(syncServer:notificationDeleted:channel:)]) {
            [self.delegate syncServer:self notificationDeleted:targets channel:channel];
        }
    });
}

#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)notifyAboutChangedObjects:(NSArray *)changesArray
                          channel:(SyncanoChannel *)channel {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.changedCallback) {
            self.changedCallback(changesArray, channel);
        }
        if ([self.delegate respondsToSelector:@selector(syncServer:notificationChanged:)]) {
            [self.delegate syncServer:self notificationChanged:changesArray];
        }
        if ([self.delegate respondsToSelector:@selector(syncServer:notificationChanged:channel:)]) {
            [self.delegate syncServer:self notificationChanged:changesArray channel:channel];
        }
    });
}

#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)notifyAboutAddedObject:(SyncanoData *)data
                       channel:(SyncanoChannel *)channel {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.addedCallback) {
            self.addedCallback(data, channel);
        }
        if ([self.delegate respondsToSelector:@selector(syncServer:notificationAdded:)]) {
            [self.delegate syncServer:self notificationAdded:data];
        }
        if ([self.delegate respondsToSelector:@selector(syncServer:notificationAdded:channel:)]) {
            [self.delegate syncServer:self notificationAdded:data channel:channel];
        }
    });
}

- (void)notifyAboutDeletedRelation:(SyncanoDataRelation *)relation
                          channel:(SyncanoChannel *)channel {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.relationDeletedCallback) {
            self.relationDeletedCallback(relation, channel);
        }
        if ([self.delegate respondsToSelector:@selector(syncServer:notificationRelationDeleted:channel:)]) {
            [self.delegate syncServer:self notificationRelationDeleted:relation channel:channel];
        }
    });
}

- (void)notifyAboutAddedRelation:(SyncanoDataRelation *)relation
                       channel:(SyncanoChannel *)channel {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.relationAddedCallback) {
            self.relationAddedCallback(relation, channel);
        }
        if ([self.delegate respondsToSelector:@selector(syncServer:notificationRelationAdded:channel:)]) {
            [self.delegate syncServer:self notificationRelationAdded:relation channel:channel];
        }
    });
}

- (SyncanoChannel *)channelFromJSON:(NSDictionary *)json {
	SyncanoChannel *channel = [SyncanoChannel objectFromJSON:json[kSyncanoSubscriptionChannelKey]];
	return channel;
}

- (SyncanoDataRelation *)relationFromJSON:(NSDictionary *)json {
    SyncanoDataRelation *relation = [SyncanoDataRelation objectFromJSON:json[kSyncanoSubscriptionTargetKey]];
    return relation;
}

- (BOOL)isObjectTypeDataRelation:(NSDictionary *)json {
    BOOL isDataRelation = NO;
    if ([json[kSyncanoObjectTypeKey] isEqualToString:kSyncanoObjectTypeDataRelation] == YES) {
        isDataRelation = YES;
    }
    return isDataRelation;
}

#pragma mark - Processing Messages From Syncano

- (void)processAuthMessage:(NSDictionary *)json {
	SyncanoAuth *auth = [SyncanoAuth objectFromJSON:json];
	self.uuid = auth.uuid;
	self.clientLoggedIn = YES;
    [self log:@"Auth: %@", auth];
	if ([auth OK]) {
		[self notifyAboutConnectionOpened];
	}
}

- (void)processPingMessage:(NSDictionary *)json {
	SyncanoPing *ping = [SyncanoPing objectFromJSON:json];
	self.lastPingTimestamp = ping.timestamp;
    [self log:@"Ping: %@", ping];
}

- (void)processErrorMessage:(NSDictionary *)json {
	SyncanoError *error = [SyncanoError objectFromJSON:json];
    [self log:@"Error: %@", error];
	[self notifyAboutSyncServerError:error.error];
}

- (void)processCallresponseMessage:(NSDictionary *)json {
	NSNumber *messageId = json[@"message_id"];
	SYNCallback *syncanoCallback = self.callbacksForId[messageId];
	[self.callbacksForId removeObjectForKey:messageId];
	SyncanoResponse *response = [self responseForClass:syncanoCallback.responseClass fromJSON:json];
    [self log:@"Callresponse id: %@", messageId];
	[syncanoCallback runCallbackWithObject:response];
	if (self.callbacksForId.count < kSyncanoSyncServerMaxNumberOfRequests) {
		[self dequeRequest];
	}
}

- (void)processHistoryMessage:(NSDictionary *)json {
	id history = json;
	BOOL isLastOne = [json[@"type"] isEqualToString:@"done"] && [json[kSyncanoObjectTypeKey] isEqualToString:@"history"];
	[self notifyAboutHistoryReceived:history isLastOne:isLastOne];
}

- (void)processGenerealMessage:(NSDictionary *)json {
	[self notifyAboutMessageReceived:json];
}

- (void)processChangedMessage:(NSDictionary *)json {
	NSArray *targets = json[kSyncanoSubscriptionTargetKey][kSyncanoSubscriptionIdKey];
	if ([targets isKindOfClass:[NSArray class]] == NO) {
		targets = @[targets];
	}
	SyncanoDataChanges *changes = [SyncanoDataChanges objectFromJSON:json];
	SyncanoChannel *channel = [self channelFromJSON:json];
	NSMutableArray *changesArray = [NSMutableArray arrayWithCapacity:targets.count];
	for (NSString *id in targets) {
		SyncanoDataChanges *targetChange = [changes copy];
		targetChange.uid = id;
		[changesArray addObject:targetChange];
	}
    [self log:@"Changed JSON: %@", json];
	[self notifyAboutChangedObjects:changesArray channel:channel];
}

- (void)processAddedMessage:(NSDictionary *)json {
	NSDictionary *dataJSON = json[@"data"];
	SyncanoData *data = [SyncanoData objectFromJSON:dataJSON];
    SyncanoDataRelation *relation = [self relationFromJSON:json];
	SyncanoChannel *channel = [self channelFromJSON:json];
    if ([self isObjectTypeDataRelation:json]) {
        [self notifyAboutAddedRelation:relation channel:channel];
    } else {
        [self notifyAboutAddedObject:data channel:channel];
    }
}

- (void)processDeletedMessage:(NSDictionary *)json {
	NSArray *targets = json[kSyncanoSubscriptionTargetKey][kSyncanoSubscriptionIdKey];
	SyncanoChannel *channel = [self channelFromJSON:json];
    SyncanoDataRelation *relation = [self relationFromJSON:json];
	if (   (targets != nil)
        && ([targets isKindOfClass:[NSArray class]] == NO)) {
		targets = @[targets];
	}
    if ([self isObjectTypeDataRelation:json]) {
        [self notifyAboutDeletedRelation:relation channel:channel];
    } else {
        [self notifyAboutDeletedObjects:targets channel:channel];
    }
}

#pragma mark - Reading Raw Data From Syncano

- (void)readDataFromSocket {
	/*
   ASYNC SOCKET DOES NOT HANDLE PROPERLY READING TO DATA WHEN INCOMING
   DATA IS FLOWING IN PACKETS AND ONE PACKET DOES NOT CONTAIN TERMINAL
   CHARACTER DATA
   
   [self.socket readDataToData:[@"}\n" dataUsingEncoding : NSUTF8StringEncoding] withTimeout:-1 tag:0];
	 */
	[self.socket readDataWithTimeout:-1 tag:0];
}

- (void)receivedData:(NSData *)data tag:(long)tag {
	id json = [self jsonFromData:data];
	NSString *type = json[@"type"];
	BOOL isHistory = ([[json[@"history"] uppercaseString] isEqualToString:@"TRUE"] || [json[kSyncanoObjectTypeKey] isEqualToString:@"history"]);
	if (json[@"error"]) {
		[self processErrorMessage:json];
	}
	else if (isHistory) {
		[self processHistoryMessage:json];
	}
	else if ([type isEqualToString:@"auth"]) {
		[self processAuthMessage:json];
	}
	else if ([type isEqualToString:@"ping"]) {
		[self processPingMessage:json];
	}
	else if ([type isEqualToString:@"callresponse"]) {
		[self processCallresponseMessage:json];
	}
	else if ([type isEqualToString:@"change"]) {
		[self processChangedMessage:json];
	}
	else if ([type isEqualToString:@"new"]) {
		[self processAddedMessage:json];
	}
	else if ([type isEqualToString:@"delete"]) {
		[self processDeletedMessage:json];
	}
	else {
		[self processGenerealMessage:json];
	}
}

- (NSRange)rangeOfTerminalDataInData:(NSData *)data {
	NSData *dataToFind = [kSyncanoSyncServerTerminalCharacter dataUsingEncoding:NSUTF8StringEncoding];
	NSRange rangeOfData = [data rangeOfData:dataToFind options:0 range:NSMakeRange(0, data.length)];
	return rangeOfData;
}

- (void)processUnprocessedData {
	NSRange rangeOfData = [self rangeOfTerminalDataInData:self.unprocessedData];
	BOOL isTerminalCharacterFoundInUnprocessedData = (rangeOfData.location != NSNotFound);
	if (isTerminalCharacterFoundInUnprocessedData) {
		NSData *dataUpToTerminalCharacterFound = [self.unprocessedData subdataWithRange:NSMakeRange(0, rangeOfData.location + rangeOfData.length)];
		NSData *dataAfterTerminalCharacter = [self.unprocessedData subdataWithRange:NSMakeRange((rangeOfData.location + rangeOfData.length), (self.unprocessedData.length - (rangeOfData.location + rangeOfData.length)))];
		[self receivedData:dataUpToTerminalCharacterFound tag:0];
		self.unprocessedData = [dataAfterTerminalCharacter mutableCopy];
		[self processUnprocessedData];
	}
}

- (void)processNewIncomingData:(NSData *)incomingData {
	[self.unprocessedData appendData:incomingData];
	[self processUnprocessedData];
}

#pragma mark - Queueing Mechanism

- (void)queueRequest:(SyncanoParameters *)parameters callback:(SyncanoSyncServerCallback)callback {
	SYNQueuedRequest *queuedRequest = [[SYNQueuedRequest alloc] initWithParams:parameters callback:callback batchCallback:NULL];
	[self.requestsQueue addObject:queuedRequest];
}

- (void)dequeRequest {
	if (self.requestsQueue.count > 0) {
		SYNQueuedRequest *queuedRequest = self.requestsQueue[0];
		[self.requestsQueue removeObjectAtIndex:0];
		[self prepareParametersAndSend:queuedRequest.parameters callback:queuedRequest.callback];
	}
}

#pragma mark - Class Methods
/*----------------------------------------------------------------------------*/

+ (void)initialize {
}

+ (SyncanoSyncServer *)syncanoSyncServerForDomain:(NSString *)domain apiKey:(NSString *)apiKey {
	SyncanoSyncServer *syncanoSyncServer = [[self alloc] initWithDomain:domain apiKey:apiKey];
	return syncanoSyncServer;
}

#pragma mark - Properties
/*----------------------------------------------------------------------------*/

- (dispatch_queue_t)delegateQueue {
	if (_delegateQueue == nil) {
		_delegateQueue = dispatch_queue_create("com.syncano.syncserver.delegateQueue", DISPATCH_QUEUE_SERIAL);
	}
	return _delegateQueue;
}

- (GCDAsyncSocket *)socket {
	if (_socket == nil) {
		_socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.delegateQueue];
	}
	return _socket;
}

- (NSMutableDictionary *)callbacksForId {
	if (_callbacksForId == nil) {
		_callbacksForId = [NSMutableDictionary dictionaryWithCapacity:32];
	}
	return _callbacksForId;
}

- (NSMutableArray *)requestsQueue {
	if (_requestsQueue == nil) {
		_requestsQueue = [[NSMutableArray alloc] initWithCapacity:32];
	}
	return _requestsQueue;
}

- (NSMutableData *)unprocessedData {
	if (_unprocessedData == nil) {
		_unprocessedData = [NSMutableData data];
	}
	return _unprocessedData;
}

- (SyncanoReachability *)reachability {
	if (_reachability == nil) {
		_reachability = [SyncanoReachability reachabilityForDomain:kSyncanoSyncServerHost];
		[_reachability startMonitoring];
	}
	return _reachability;
}

#pragma mark - Public Methods
/*----------------------------------------------------------------------------*/

- (void)commonInit {
	_messageId = 0;
    _logMessages = NO;
	[self reachability];
}

- (id)init {
	self = [super init];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (SyncanoSyncServer *)initWithDomain:(NSString *)domain apiKey:(NSString *)apiKey {
	self = [super init];
	if (self) {
		[self commonInit];
		self.apiKey = apiKey;
		self.domain = domain;
	}
	return self;
}

- (BOOL)connect:(NSError **)errorPointer {
	if ([self isConnectionOpen]) {
		return NO;
	}
	BOOL success = [self.socket connectToHost:kSyncanoSyncServerHost onPort:kSyncanoSyncServerPort withTimeout:kSyncanoSyncServerDefaultTimeout error:errorPointer];
  if (success) {
    __weak SyncanoSyncServer *_weakSelf = self;
    [_reachability setReachabilityStatusChangeBlock:^(SyncanoNetworkReachabilityStatus status) {
      if (_weakSelf.reachability.isReachable) {
        [_weakSelf connect:errorPointer];
      } else {
        [_weakSelf closeConnection];
      }
    }];
  }
	return success;
}

- (BOOL)        connect:(NSError **)errorPointer
         connectionOpen:(SyncanoSyncServerConnectionOpenCallback)connectionOpenCallback
       connectionClosed:(SyncanoSyncServerConnectionClosedCallback)connectionClosedCallback
        messageReceived:(SyncanoSyncServerMessageReceivedCallback)messageReceivedCallback
        historyReceived:(SyncanoSyncServerHistoryReceivedCallback)historyReceivedCallback
        syncServerError:(SyncanoSyncServerErrorCallback)syncServerErrorCallback
    notificationDeleted:(SyncanoSyncServerDeletedCallback)deletedCallback
    notificationChanged:(SyncanoSyncServerChangedCallback)changedCallback
      notificationAdded:(SyncanoSyncServerAddedCallback)addedCallback
notificationRelationDeleted:(SyncanoSyncServerRelationDeletedCallback)relationDeletedCallback
notificationRelationAdded:(SyncanoSyncServerRelationAddedCallback)relationAddedCallback {
	self.connectionOpenCallback = connectionOpenCallback;
	self.connectionClosedCallback = connectionClosedCallback;
	self.messageReceivedCallback = messageReceivedCallback;
	self.historyReceivedCallback = historyReceivedCallback;
	self.syncServerErrorCallback = syncServerErrorCallback;
	self.deletedCallback = deletedCallback;
	self.changedCallback = changedCallback;
	self.addedCallback = addedCallback;
    self.relationDeletedCallback = relationDeletedCallback;
    self.relationAddedCallback = relationAddedCallback;
	return [self connect:errorPointer];
}

- (void)closeConnection {
	[self.socket disconnect];
}

- (BOOL)isConnectionOpen {
	return [self.socket isConnected];
}

- (void)prepareParametersAndSend:(SyncanoParameters *)parameters callback:(SyncanoSyncServerResponseCallback)callback {
	NSNumber *messageId = @(++self.messageId);
	NSDictionary *jsonToSend = [parameters syncServerDictionaryForMessageId:messageId];
	NSData *dataToSend = [self dataFromJSON:jsonToSend];
	SYNCallback *syncanoCallback = [[SYNCallback alloc] init];
	syncanoCallback.responseClass = [[parameters responseFromJSON:nil] class];
	syncanoCallback.callback = callback;
	syncanoCallback.callbackQueue = dispatch_get_main_queue();
	[self.callbacksForId setObject:syncanoCallback forKey:messageId];
	[self.socket writeData:dataToSend withTimeout:kSyncanoSyncServerDefaultTimeout tag:0];
}

- (void)sendRequest:(SyncanoParameters *)parameters callback:(SyncanoSyncServerResponseCallback)callback {
	[self queueRequest:parameters callback:callback];
	if ([self isConnectionOpen] && self.callbacksForId.count < kSyncanoSyncServerMaxNumberOfRequests) {
		[self dequeRequest];
	}
}

#pragma mark - protocol GCDAsyncSocketDelegate
/*----------------------------------------------------------------------------*/

/**
 * This method is called immediately prior to socket:didAcceptNewSocket:.
 * It optionally allows a listening socket to specify the socketQueue for a new accepted socket.
 * If this method is not implemented, or returns NULL, the new accepted socket will create its own default queue.
 *
 * Since you cannot autorelease a dispatch_queue,
 * this method uses the "new" prefix in its name to specify that the returned queue has been retained.
 *
 * Thus you could do something like this in the implementation:
 * return dispatch_queue_create("MyQueue", NULL);
 *
 * If you are placing multiple sockets on the same queue,
 * then care should be taken to increment the retain count each time this method is invoked.
 *
 * For example, your implementation might look something like this:
 * dispatch_retain(myExistingQueue);
 * return myExistingQueue;
 **/

//- (dispatch_queue_t)newSocketQueueForConnectionFromAddress:(NSData *)address onSocket:(GCDAsyncSocket *)sock;

/**
 * Called when a socket accepts a connection.
 * Another socket is automatically spawned to handle it.
 *
 * You must retain the newSocket if you wish to handle the connection.
 * Otherwise the newSocket instance will be released and the spawned connection will be closed.
 *
 * By default the new socket will have the same delegate and delegateQueue.
 * You may, of course, change this at any time.
 **/

//- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket;

/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
 **/

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
	[self startSecureConnection];
	[self readDataFromSocket];
}

/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	[self readDataFromSocket];
    [self log:@"DidReadData, tag: %ld", tag];
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self log:@"DidReadString: %@", string];
	[self processNewIncomingData:data];
}

/**
 * Called when a socket has read in data, but has not yet completed the read.
 * This would occur if using readToData: or readToLength: methods.
 * It may be used to for things such as updating progress bars.
 **/

//- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag;

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    [self log:@"DidWriteData, tag: %ld", tag];
}

/**
 * Called when a socket has written some data, but has not yet completed the entire write.
 * It may be used to for things such as updating progress bars.
 **/

//- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag;

/**
 * Called if a read operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the read's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the read will timeout as usual.
 *
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been read so far for the read operation.
 *
 * Note that this method may be called multiple times for a single read if you return positive numbers.
 **/

//- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
//                 elapsed:(NSTimeInterval)elapsed
//               bytesDone:(NSUInteger)length;

/**
 * Called if a write operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the write's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the write will timeout as usual.
 *
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been written so far for the write operation.
 *
 * Note that this method may be called multiple times for a single write if you return positive numbers.
 **/

//- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
//                 elapsed:(NSTimeInterval)elapsed
//               bytesDone:(NSUInteger)length;

/**
 * Conditionally called if the read stream closes, but the write stream may still be writeable.
 *
 * This delegate method is only called if autoDisconnectOnClosedReadStream has been set to NO.
 * See the discussion on the autoDisconnectOnClosedReadStream method for more information.
 **/

//- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock;

/**
 * Called when a socket disconnects with or without error.
 *
 * If you call the disconnect method, and the socket wasn't already disconnected,
 * this delegate method will be called before the disconnect method returns.
 **/

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
  self.clientLoggedIn = NO;
	[self notifyAboutConnectionClosed:err];
}

/**
 * Called after the socket has successfully completed SSL/TLS negotiation.
 * This method is not called unless you use the provided startTLS method.
 *
 * If a SSL/TLS negotiation fails (invalid certificate, etc) then the socket will immediately close,
 * and the socketDidDisconnect:withError: delegate method will be called with the specific SSL error code.
 **/

- (void)socketDidSecure:(GCDAsyncSocket *)sock {
    [self log:@"SocketDidSecure"];
	[self loginClient];
}

#pragma mark - protocol SyncanoProtocolNotification <NSObject>
#pragma mark required

#pragma mark - Asynchronized

- (void)notificationSend:(SyncanoParameters_Notifications_Send *)params callback:(void (^)(SyncanoResponse *response))callback {
	[self sendRequest:params callback:callback];
}

- (void)notificationGetHistory:(SyncanoParameters_Notifications_GetHistory *)params callback:(void (^)(SyncanoResponse_Notifications_GetHistory *response))callback {
	[self sendRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Notifications_GetHistory *)response);
		}
	}];
}

#pragma mark - protocol SyncanoProtocolSubscriptions <NSObject>
#pragma mark required

#pragma mark - Asynchronized

- (void)subscriptionSubscribeProject:(SyncanoParameters_Subscriptions_SubscribeProject *)params callback:(void (^)(SyncanoResponse *response))callback {
	[self sendRequest:params callback:callback];
}

- (void)subscriptionUnsubscribeProject:(SyncanoParameters_Subscriptions_UnsubscribeProject *)params callback:(void (^)(SyncanoResponse *response))callback {
	[self sendRequest:params callback:callback];
}

- (void)subscriptionSubscribeCollection:(SyncanoParameters_Subscriptions_SubscribeCollection *)params callback:(void (^)(SyncanoResponse *response))callback {
	[self sendRequest:params callback:callback];
}

- (void)subscriptionUnsubscribeCollection:(SyncanoParameters_Subscriptions_UnsubscribeCollection *)params callback:(void (^)(SyncanoResponse *response))callback {
	[self sendRequest:params callback:callback];
}

- (void)subscriptionGet:(SyncanoParameters_Subscriptions_Get *)params callback:(void (^)(SyncanoResponse_Subscriptions_Get *response))callback {
	[self sendRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Subscriptions_Get *)response);
		}
	}];
}

#pragma mark - protocol SyncanoProtocolIdentities <NSObject>
#pragma mark required

#pragma mark - Asynchronized

- (void)connectionGet:(SyncanoParameters_Connections_Get *)params callback:(void (^)(SyncanoResponse_Connections_Get *response))callback {
	[self sendRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Connections_Get *)response);
		}
	}];
}

- (void)connectionGetAll:(SyncanoParameters_Connections_Get_All *)params callback:(void (^)(SyncanoResponse_Connections_Get_All *response))callback {
	[self sendRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Connections_Get_All *)response);
		}
	}];
}

- (void)connectionUpdate:(SyncanoParameters_Connections_Update *)params callback:(void (^)(SyncanoResponse_Connections_Update *response))callback {
	[self sendRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Connections_Update *)response);
		}
	}];
}

@end

@implementation SYNCallback
- (void)runCallbackWithObject:(id)object {
	dispatch_queue_t queue = self.callbackQueue;
	if (!queue) {
		queue = dispatch_get_main_queue();
	}
	if ([object isKindOfClass:[SyncanoResponse class]] && self.callback) {
		dispatch_async(queue, ^{
      self.callback((SyncanoResponse *)object);
		});
	}
	else if ([object isKindOfClass:[NSArray class]] && self.batchCallback) {
		dispatch_async(queue, ^{
      self.batchCallback((NSArray *)object);
		});
	}
}

@end

@implementation SYNQueuedRequest
- (id)init {
	return [self initWithParams:nil callback:NULL batchCallback:NULL];
}

- (id)initWithParams:(SyncanoParameters *)params
            callback:(SyncanoSyncServerCallback)callback
       batchCallback:(SyncanoSyncServerBatchCallback)batchCallback {
	self = [super init];
	if (self) {
		self.parameters = params;
		self.callback = callback;
		self.batchCallback = batchCallback;
	}
	return self;
}

@end
