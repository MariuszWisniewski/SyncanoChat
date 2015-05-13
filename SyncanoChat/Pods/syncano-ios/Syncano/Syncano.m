//
//  Syncano.m
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#import "Syncano.h"
#import "Syncano+Private.h"
#import "SyncanoDefines.h"

#import <AFNetworking/AFNetworking.h>

NSInteger const kSyncanoMaxNumberOfRequestsInBatchCall = 10;

NSString *const kSyncanoDomainApi = @"https://%@.syncano.com/api";
NSString *const kSyncanoDomainApiForReachability = @"%@.syncano.com";

NSString *const kSyncanoModuleJSONRPC = @"jsonrpc";

NSString *const multicallParamsKey = @"paramsKey";

NSString *const userAgentKey = @"User-Agent";

NSInteger const kSyncanoMaxNumberOfRequests = 2;

NSString *const kSyncanoException = @"SyncanoException";
NSString *const kSyncanoExceptionReasonNoMulticallParameters = @"No Multicall Parameters";

@interface SyncanoParametersCallbackPair : NSObject
@property (strong, nonatomic) SyncanoParameters *params;
@property (strong, nonatomic) NSArray *batchParams;
@property (strong, nonatomic) SyncanoCallback callback;
@property (strong, nonatomic) SyncanoBatchCallback batchCallback;
+ (instancetype)pairWithParams:(SyncanoParameters *)params callback:(SyncanoCallback)callback;
+ (instancetype)pairWithBatchParams:(NSArray *)batchParams batchCallback:(SyncanoBatchCallback)callback;
@end

@interface AFHTTPRequestOperation (SyncanoRequest) <SyncanoRequest>
@end
@implementation AFHTTPRequestOperation (SyncanoRequest)
@end

#pragma mark - Private Interface
/*----------------------------------------------------------------------------*/

@interface Syncano ()
@property (strong, readwrite)  NSString *domain;
@property (strong, readwrite)  NSString *apiKey;
@property (strong, nonatomic)  AFHTTPRequestOperationManager *asynchronousOperationManager;
@property (strong, nonatomic)  AFHTTPRequestOperationManager *synchronousOperationManager;
@property (strong, nonatomic)  AFJSONRequestSerializer *requestSerializer;
@property (strong, nonatomic)  AFHTTPRequestSerializer *batchRequestSerializer;
@property (strong, readwrite, nonatomic) SyncanoReachability *reachability;

@property (strong, nonatomic) NSMutableArray *singleRequestsQueue;
@property (strong, nonatomic) NSMutableArray *batchRequestsQueue;

- (NSString *)fullDomain;
- (NSString *)fullDomainForReachability;
- (NSString *)serializeRequest:(NSURLRequest *)request parameters:(NSDictionary *)parameters error:(NSError **)error;
- (NSDictionary *)parametersDictionaryForBatchRequestParameters:(NSArray *)batchParameters;
- (NSArray *)syncanoResponsesFromBatchRequestResponseObject:(id)responseObject requestParameters:(NSArray *)params;
- (void)addBasicFieldToParameters:(SyncanoParameters *)params;
- (void)addAPIKeyToParameters:(SyncanoParameters *)params;
- (void)addTimezoneToParameters:(SyncanoParameters *)params;
- (void)addAuthKeyToParameters:(SyncanoParameters *)params;
- (NSException *)exceptionForReason:(NSString *)reason;
@end

#pragma mark - Implementation
/*----------------------------------------------------------------------------*/

@implementation Syncano

#pragma mark - Private
/*----------------------------------------------------------------------------*/

- (NSString *)fullDomain {
	return [NSString stringWithFormat:kSyncanoDomainApi, self.domain];
}

- (NSString *)fullDomainForReachability {
	return [NSString stringWithFormat:kSyncanoDomainApiForReachability, self.domain];
}

- (NSString *)serializeRequest:(NSURLRequest *)request parameters:(NSDictionary *)parameters error:(NSError **)error {
    if (parameters == nil) {
        NSException *noParamsException = [self exceptionForReason:kSyncanoExceptionReasonNoMulticallParameters];
        [noParamsException raise];
    }
    NSArray *multicallParameters = [parameters objectForKey:multicallParamsKey];
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:multicallParameters options:NSJSONWritingPrettyPrinted error:error];
	NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	return jsonString;
}

- (NSDictionary *)parametersDictionaryForBatchRequestParameters:(NSArray *)batchParameters {
	NSMutableArray *multicallParameters = [NSMutableArray arrayWithCapacity:batchParameters.count];
	for (int i = 0; i < batchParameters.count; ++i) {
		SyncanoParameters *parameters = batchParameters[i];
		[self addBasicFieldToParameters:parameters];
		NSDictionary *postParams = [parameters jsonRPCPostDictionaryForJsonRPCId:@(0)];
		[multicallParameters addObject:postParams];
	}
	return @{ multicallParamsKey:multicallParameters };
}

- (NSArray *)syncanoResponsesFromBatchRequestResponseObject:(id)responseObject requestParameters:(NSArray *)params {
	if ([responseObject isKindOfClass:[NSArray class]] == NO) {
		responseObject = @[responseObject];
	}
	NSArray *responses = [responseObject sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES]]];
	NSMutableArray *syncanoResponses = [NSMutableArray arrayWithCapacity:responses.count];
	for (int i = 0; i < params.count; ++i) {
		SyncanoParameters *parameters = [params objectAtIndex:i];
		[syncanoResponses addObject:[parameters responseFromJSON:[responses objectAtIndex:i]]];
	}
	return syncanoResponses;
}

- (void)addBasicFieldToParameters:(SyncanoParameters *)params {
	[self addAPIKeyToParameters:params];
	[self addTimezoneToParameters:params];
	[self addAuthKeyToParameters:params];
}

- (void)addAPIKeyToParameters:(SyncanoParameters *)params {
	if (params.apiKey.length == 0) {
		params.apiKey = self.apiKey;
	}
}

- (void)addTimezoneToParameters:(SyncanoParameters *)params {
	if (params.timezone.length == 0) {
		params.timezone = self.timezone;
	}
}

- (void)addAuthKeyToParameters:(SyncanoParameters *)params {
	if (params.authKey.length == 0) {
		params.authKey = self.authKey;
	}
}

- (NSException *)exceptionForReason:(NSString *)reason {
    if (reason) {
        return [NSException exceptionWithName:kSyncanoException reason:reason userInfo:nil];
    }
    return nil;
}

#pragma mark - Properties
/*----------------------------------------------------------------------------*/

- (AFHTTPRequestOperationManager *)asynchronousOperationManager {
	if (_asynchronousOperationManager == nil) {
		_asynchronousOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[self fullDomain]]];
		_asynchronousOperationManager.operationQueue.maxConcurrentOperationCount = kSyncanoMaxNumberOfRequests;
    
		AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
		securityPolicy.SSLPinningMode = AFSSLPinningModeCertificate;
		securityPolicy.validatesCertificateChain = NO;
		securityPolicy.pinnedCertificates = @[[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"server" ofType:@"der"]]];
    
		_asynchronousOperationManager.securityPolicy = securityPolicy;
        
	}
	return _asynchronousOperationManager;
}

- (AFHTTPRequestOperationManager *)synchronousOperationManager {
	if (_synchronousOperationManager == nil) {
		_synchronousOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[self fullDomain]]];
		_synchronousOperationManager.operationQueue.maxConcurrentOperationCount = kSyncanoMaxNumberOfRequests;
    
		AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
		securityPolicy.SSLPinningMode = AFSSLPinningModeCertificate;
		securityPolicy.validatesCertificateChain = NO;
		securityPolicy.pinnedCertificates = @[[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"server" ofType:@"der"]]];
		_synchronousOperationManager.securityPolicy = securityPolicy;
	}
	return _synchronousOperationManager;
}

- (AFJSONRequestSerializer *)requestSerializer {
	if (_requestSerializer == nil) {
		_requestSerializer = [AFJSONRequestSerializer serializer];
	}
	return _requestSerializer;
}

- (AFHTTPRequestSerializer *)batchRequestSerializer {
	if (_batchRequestSerializer == nil) {
		_batchRequestSerializer = [AFHTTPRequestSerializer serializer];
		__weak id weakSelf = self;
		[_batchRequestSerializer setQueryStringSerializationWithBlock: ^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
      return [weakSelf serializeRequest:request parameters:parameters error:error];
		}];
	}
	return _batchRequestSerializer;
}

- (SyncanoReachability *)reachability {
	if (_reachability == nil) {
		_reachability = [SyncanoReachability reachabilityForDomain:[self fullDomainForReachability]];
	}
	return _reachability;
}

- (NSMutableArray *)singleRequestsQueue {
	if (_singleRequestsQueue == nil) {
		_singleRequestsQueue = [NSMutableArray new];
	}
	return _singleRequestsQueue;
}

- (NSMutableArray *)batchRequestsQueue {
	if (_batchRequestsQueue == nil) {
		_batchRequestsQueue = [NSMutableArray new];
	}
	return _batchRequestsQueue;
}

#pragma mark - Class Methods
/*----------------------------------------------------------------------------*/

+ (void)initialize {
#ifdef DEBUG
	//    [[AFNetworkActivityLogger sharedLogger] startLogging];
	//    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
#endif
}

+ (Syncano *)syncanoForDomain:(NSString *)domain apiKey:(NSString *)apiKey {
	Syncano *syncano = [[self alloc] initWithDomain:domain apiKey:apiKey];
	return syncano;
}

#pragma mark - Public Methods
/*----------------------------------------------------------------------------*/

- (void)commonInit {
	self.logAllRequests = YES;
	self.logJSONResponses = NO;
}

- (id)init {
	self = [super init];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (Syncano *)initWithDomain:(NSString *)domain apiKey:(NSString *)apiKey {
	self = [super init];
	if (self) {
		[self commonInit];
		self.apiKey = apiKey;
		self.domain = domain;
		[self.reachability startMonitoring];
	}
	return self;
}

#pragma mark - Downloading images from given URL

- (id <SyncanoRequest> )downloadImageFromURL:(NSString *)url
                                    callback:(void (^)(UIImage *image))callback {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setValue:[[self class] userAgent] forHTTPHeaderField:userAgentKey];
	AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
	[requestOperation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
    UIImage *image = responseObject;
    if (callback) {
      callback(image);
		}
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
    if (callback) {
      callback(nil);
		}
	}];
	[requestOperation start];
	id <SyncanoRequest> syncanoRequest = requestOperation;
	return syncanoRequest;
}

- (UIImage *)downloadImageFromURL:(NSString *)url {
	__block UIImage *imageResponse = nil;
	dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
	[self downloadImageFromURL:url callback: ^(UIImage *image) {
    imageResponse = image;
    dispatch_semaphore_signal(semaphore);
	}];
	while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
	}
	return imageResponse;
}

#pragma mark - General Request Creating

- (id <SyncanoRequest> )pausedRequestWithOperationManager:(AFHTTPRequestOperationManager *)operationManager params:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
	NSMutableURLRequest *request = [operationManager.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:kSyncanoModuleJSONRPC relativeToURL:operationManager.baseURL] absoluteString] parameters:params error:nil];
    [request setValue:[[self class] userAgent] forHTTPHeaderField:userAgentKey];
	AFHTTPRequestOperation *operation = [operationManager HTTPRequestOperationWithRequest:request success: ^(AFHTTPRequestOperation *operation, id responseObject) {
    if (self.logJSONResponses) {
      SyncanoDebugLog(@"Syncano JSON Response: %@", responseObject);
		}
    if (success) {
      success(operation, responseObject);
		}
	} failure:failure];
	if ([NSThread isMainThread]) {
		[operationManager.operationQueue addOperation:operation];
//		[operation pause];
	}
	else {
		dispatch_sync(dispatch_get_main_queue(), ^{
      [operationManager.operationQueue addOperation:operation];
//      [operation pause];
		});
	}
  
	if (self.logAllRequests) {
		SyncanoDebugLog(@"Request: %@, %@ with Params: %@", operation, operation.request.allHTTPHeaderFields, params);
	}
  
	return operation;
}

#pragma mark - Single Requests
/*----------------------------------------------------------------------------*/

- (SyncanoResponse *)sendRequest:(SyncanoParameters *)params {
	__block SyncanoResponse *responseToReturn = nil;
	dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
	id <SyncanoRequest> request = [self getPausedRequest:params operationManager:self.synchronousOperationManager success: ^(id < SyncanoRequest > request, SyncanoResponse *response) {
    responseToReturn = response;
    dispatch_semaphore_signal(semaphore);
	} failure: ^(id <SyncanoRequest> request, NSError *error) {
    SyncanoResponse *response = [params responseFromJSON:nil];
    response.error = error;
    responseToReturn = response;
    dispatch_semaphore_signal(semaphore);
	}];
	[request resume];
	while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
	}
	return responseToReturn;
}

- (id <SyncanoRequest> )sendAsyncRequest:(SyncanoParameters *)params callback:(SyncanoCallback)callback {
	return [self sendAsyncRequest:params success: ^(id < SyncanoRequest > request, SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	} failure: ^(id <SyncanoRequest> request, NSError *error) {
    if (callback) {
      SyncanoResponse *response = [params responseFromJSON:nil];
      response.error = error;
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )sendAsyncRequest:(SyncanoParameters *)params
                                 success:(SyncanoSuccess)success
                                 failure:(SyncanoFailure)failure {
	id <SyncanoRequest> request = [self getPausedRequest:params success:success failure:failure];
	[request resume];
	return request;
}

- (id <SyncanoRequest> )getPausedRequest:(SyncanoParameters *)params
                                 success:(SyncanoSuccess)success
                                 failure:(SyncanoFailure)failure {
	return [self getPausedRequest:params operationManager:self.asynchronousOperationManager success:success failure:failure];
}

- (id <SyncanoRequest> )getPausedRequest:(SyncanoParameters *)params
                        operationManager:(AFHTTPRequestOperationManager *)operationManager
                                 success:(SyncanoSuccess)success
                                 failure:(SyncanoFailure)failure {
	[self addBasicFieldToParameters:params];
	operationManager.requestSerializer = self.requestSerializer;
	id <SyncanoRequest> request = [self pausedRequestWithOperationManager:operationManager params:[params jsonRPCPostDictionaryForJsonRPCId:@(0)] success: ^(AFHTTPRequestOperation *operation, id responseObject) {
    SyncanoResponse *response = [params responseFromJSON:responseObject];
    if (response.error == nil && success) {
      success(operation, response);
		}
    else if (response.error && failure) {
      failure(operation, response.error);
		}
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
    if (failure) {
      failure(operation, error);
		}
	}];
	return request;
}

#pragma mark - Batch Request
/*----------------------------------------------------------------------------*/

- (NSArray *)sendBatchRequest:(NSArray *)params {
	__block NSArray *responsesToReturn = nil;
	dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
	id <SyncanoRequest> request = [self getPausedBatchRequest:params operationManager:self.synchronousOperationManager success: ^(id < SyncanoRequest > request, NSArray *responses) {
    responsesToReturn = responses;
    dispatch_semaphore_signal(semaphore);
	} failure: ^(id <SyncanoRequest> request, NSError *error) {
    SyncanoResponse *response = [[SyncanoResponse alloc] init];
    response.error = error;
    responsesToReturn = @[response];
    dispatch_semaphore_signal(semaphore);
	}];
	[request resume];
	while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
	}
	return responsesToReturn;
}

- (id <SyncanoRequest> )sendAsyncBatchRequest:(NSArray *)params callback:(SyncanoBatchCallback)callback {
	return [self sendAsyncBatchRequest:params success: ^(id < SyncanoRequest > request, NSArray *responses) {
    if (callback) {
      callback(responses);
		}
	} failure: ^(id <SyncanoRequest> request, NSError *error) {
    if (callback) {
      SyncanoResponse *response = [[SyncanoResponse alloc] init];
      response.error = error;
      callback(@[response]);
		}
	}];
}

- (id <SyncanoRequest> )sendAsyncBatchRequest:(NSArray *)params
                                      success:(SyncanoBatchSuccess)success
                                      failure:(SyncanoFailure)failure {
	id <SyncanoRequest> request = [self getPausedBatchRequest:params success:success failure:failure];
	[request resume];
	return request;
}

- (id <SyncanoRequest> )getPausedBatchRequest:(NSArray *)params
                                      success:(SyncanoBatchSuccess)success
                                      failure:(SyncanoFailure)failure {
	return [self getPausedBatchRequest:params operationManager:self.asynchronousOperationManager success:success failure:failure];
}

- (id <SyncanoRequest> )getPausedBatchRequest:(NSArray *)params
                             operationManager:(AFHTTPRequestOperationManager *)operationManager
                                      success:(SyncanoBatchSuccess)success
                                      failure:(SyncanoFailure)failure {
    if (params.count > kSyncanoMaxNumberOfRequestsInBatchCall) {
        if (failure) failure(nil, nil);
        return nil;
    }
    NSDictionary *batchParameters = [self parametersDictionaryForBatchRequestParameters:params];
    operationManager.requestSerializer = self.batchRequestSerializer;
    id <SyncanoRequest> request = [self pausedRequestWithOperationManager:operationManager params:batchParameters success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responses = [self syncanoResponsesFromBatchRequestResponseObject:responseObject requestParameters:params];
        if (success) {
            success(operation, responses);
        }
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
    return request;
}

- (void)cancellAllRequests {
	[self.asynchronousOperationManager.operationQueue cancelAllOperations];
	[self.synchronousOperationManager.operationQueue cancelAllOperations];
}

#pragma mark - Protocols
/*----------------------------------------------------------------------------*/

#pragma mark protocol SyncanoProtocolProjects
/*----------------------------------------*/

#pragma mark - Synchronized

- (SyncanoResponse_Projects_New *)projectNew:(SyncanoParameters_Projects_New *)params {
	return (SyncanoResponse_Projects_New *)[self sendRequest:params];
}

- (SyncanoResponse_Projects_Get *)projectGet:(SyncanoParameters_Projects_Get *)params {
	return (SyncanoResponse_Projects_Get *)[self sendRequest:params];
}

- (SyncanoResponse_Projects_GetOne *)projectGetOne:(SyncanoParameters_Projects_GetOne *)params {
	return (SyncanoResponse_Projects_GetOne *)[self sendRequest:params];
}

- (SyncanoResponse_Projects_Update *)projectUpdate:(SyncanoParameters_Projects_Update *)params {
	return (SyncanoResponse_Projects_Update *)[self sendRequest:params];
}

- (SyncanoResponse *)projectAuthorize:(SyncanoParameters_Projects_Authorize *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)projectDeauthorize:(SyncanoParameters_Projects_Deauthorize *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)projectDelete:(SyncanoParameters_Projects_Delete *)params {
	return [self sendRequest:params];
}

#pragma mark - Asynchronized

- (id <SyncanoRequest> )projectNew:(SyncanoParameters_Projects_New *)params callback:(void (^)(SyncanoResponse_Projects_New *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Projects_New *)response);
		}
	}];
}

- (id <SyncanoRequest> )projectGet:(SyncanoParameters_Projects_Get *)params callback:(void (^)(SyncanoResponse_Projects_Get *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Projects_Get *)response);
		}
	}];
}

- (id <SyncanoRequest> )projectGetOne:(SyncanoParameters_Projects_GetOne *)params callback:(void (^)(SyncanoResponse_Projects_GetOne *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Projects_GetOne *)response);
		}
	}];
}

- (id <SyncanoRequest> )projectUpdate:(SyncanoParameters_Projects_Update *)params callback:(void (^)(SyncanoResponse_Projects_Update *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Projects_Update *)response);
		}
	}];
}

- (id <SyncanoRequest> )projectAuthorize:(SyncanoParameters_Projects_Authorize *)params callback:(void (^)(SyncanoResponse *))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )projectDeauthorize:(SyncanoParameters_Projects_Deauthorize *)params callback:(void (^)(SyncanoResponse *))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )projectDelete:(SyncanoParameters_Projects_Delete *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

#pragma mark protocol SyncanoProtocolCollections
/*----------------------------------------*/

#pragma mark - Synchronized

- (SyncanoResponse_Collections_New *)collectionNew:(SyncanoParameters_Collections_New *)params {
	return (SyncanoResponse_Collections_New *)[self sendRequest:params];
}

- (SyncanoResponse_Collections_Get *)collectionGet:(SyncanoParameters_Collections_Get *)params {
	return (SyncanoResponse_Collections_Get *)[self sendRequest:params];
}

- (SyncanoResponse_Collections_GetOne *)collectionGetOne:(SyncanoParameters_Collections_GetOne *)params {
	return (SyncanoResponse_Collections_GetOne *)[self sendRequest:params];
}

- (SyncanoResponse *)collectionActivate:(SyncanoParameters_Collections_Activate *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)collectionDeactivate:(SyncanoParameters_Collections_Deactivate *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse_Collections_Update *)collectionUpdate:(SyncanoParameters_Collections_Update *)params {
	return (SyncanoResponse_Collections_Update *)[self sendRequest:params];
}

- (SyncanoResponse *)collectionAuthorize:(SyncanoParameters_Collections_Authorize *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)collectionDeauthorize:(SyncanoParameters_Collections_Deauthorize *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)collectionDelete:(SyncanoParameters_Collections_Delete *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)collectionAddTag:(SyncanoParameters_Collections_AddTag *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)collectionDeleteTag:(SyncanoParameters_Collections_DeleteTag *)params {
	return [self sendRequest:params];
}

#pragma mark - Asynchronized

- (id <SyncanoRequest> )collectionNew:(SyncanoParameters_Collections_New *)params callback:(void (^)(SyncanoResponse_Collections_New *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Collections_New *)response);
		}
	}];
}

- (id <SyncanoRequest> )collectionGet:(SyncanoParameters_Collections_Get *)params callback:(void (^)(SyncanoResponse_Collections_Get *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Collections_Get *)response);
		}
	}];
}

- (id <SyncanoRequest> )collectionGetOne:(SyncanoParameters_Collections_GetOne *)params callback:(void (^)(SyncanoResponse_Collections_GetOne *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Collections_GetOne *)response);
		}
	}];
}

- (id <SyncanoRequest> )collectionActivate:(SyncanoParameters_Collections_Activate *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )collectionDeactivate:(SyncanoParameters_Collections_Deactivate *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )collectionUpdate:(SyncanoParameters_Collections_Update *)params callback:(void (^)(SyncanoResponse_Collections_Update *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Collections_Update *)response);
		}
	}];
}

- (id <SyncanoRequest> )collectionAuthorize:(SyncanoParameters_Collections_Authorize *)params callback:(void (^)(SyncanoResponse *))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )collectionDeauthorize:(SyncanoParameters_Collections_Deauthorize *)params callback:(void (^)(SyncanoResponse *))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )collectionDelete:(SyncanoParameters_Collections_Delete *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )collectionAddTag:(SyncanoParameters_Collections_AddTag *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )collectionDeleteTag:(SyncanoParameters_Collections_DeleteTag *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

#pragma mark protocol SyncanoProtocolFolders
/*----------------------------------------*/

#pragma mark - Synchronized

- (SyncanoResponse_Folders_New *)folderNew:(SyncanoParameters_Folders_New *)params {
	return (SyncanoResponse_Folders_New *)[self sendRequest:params];
}

- (SyncanoResponse_Folders_Get *)folderGet:(SyncanoParameters_Folders_Get *)params {
	return (SyncanoResponse_Folders_Get *)[self sendRequest:params];
}

- (SyncanoResponse_Folders_GetOne *)folderGetOne:(SyncanoParameters_Folders_GetOne *)params {
	return (SyncanoResponse_Folders_GetOne *)[self sendRequest:params];
}

- (SyncanoResponse *)folderUpdate:(SyncanoParameters_Folders_Update *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)folderAuthorize:(SyncanoParameters_Folders_Authorize *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)folderDeauthorize:(SyncanoParameters_Folders_Deauthorize *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)folderDelete:(SyncanoParameters_Folders_Delete *)params {
	return [self sendRequest:params];
}

#pragma mark - Asynchronized

- (id <SyncanoRequest> )folderNew:(SyncanoParameters_Folders_New *)params callback:(void (^)(SyncanoResponse_Folders_New *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Folders_New *)response);
		}
	}];
}

- (id <SyncanoRequest> )folderGet:(SyncanoParameters_Folders_Get *)params callback:(void (^)(SyncanoResponse_Folders_Get *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Folders_Get *)response);
		}
	}];
}

- (id <SyncanoRequest> )folderGetOne:(SyncanoParameters_Folders_GetOne *)params callback:(void (^)(SyncanoResponse_Folders_GetOne *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Folders_GetOne *)response);
		}
	}];
}

- (id <SyncanoRequest> )folderUpdate:(SyncanoParameters_Folders_Update *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )folderAuthorize:(SyncanoParameters_Folders_Authorize *)params callback:(void (^)(SyncanoResponse *))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )folderDeauthorize:(SyncanoParameters_Folders_Deauthorize *)params callback:(void (^)(SyncanoResponse *))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )folderDelete:(SyncanoParameters_Folders_Delete *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

#pragma mark protocol SyncanoProtocolDataObjects
/*----------------------------------------*/

#pragma mark - Synchronized

- (SyncanoResponse_DataObjects_New *)dataNew:(SyncanoParameters_DataObjects_New *)params {
	return (SyncanoResponse_DataObjects_New *)[self sendRequest:params];
}

- (SyncanoResponse_DataObjects_Get *)dataGet:(SyncanoParameters_DataObjects_Get *)params {
	return (SyncanoResponse_DataObjects_Get *)[self sendRequest:params];
}

- (SyncanoResponse_DataObjects_GetOne *)dataGetOne:(SyncanoParameters_DataObjects_GetOne *)params {
	return (SyncanoResponse_DataObjects_GetOne *)[self sendRequest:params];
}

- (SyncanoResponse_DataObjects_Update *)dataUpdate:(SyncanoParameters_DataObjects_Update *)params {
	return (SyncanoResponse_DataObjects_Update *)[self sendRequest:params];
}

- (SyncanoResponse *)dataMove:(SyncanoParameters_DataObjects_Move *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse_DataObjects_Copy *)dataCopy:(SyncanoParameters_DataObjects_Copy *)params {
	return (SyncanoResponse_DataObjects_Copy *)[self sendRequest:params];
}

- (SyncanoResponse *)dataAddParent:(SyncanoParameters_DataObjects_AddParent *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)dataRemoveParent:(SyncanoParameters_DataObjects_RemoveParent *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)dataAddChild:(SyncanoParameters_DataObjects_AddChild *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)dataRemoveChild:(SyncanoParameters_DataObjects_RemoveChild *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)dataDelete:(SyncanoParameters_DataObjects_Delete *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse_DataObjects_Count *)dataCount:(SyncanoParameters_DataObjects_Count *)params {
	return (SyncanoResponse_DataObjects_Count *)[self sendRequest:params];
}

- (UIImage *)downloadImageFull:(SyncanoImage *)imageInfo {
	return [self downloadImageFromURL:imageInfo.image];
}

- (UIImage *)downloadImageThumbnail:(SyncanoImage *)imageInfo {
	return [self downloadImageFromURL:imageInfo.thumbnail];
}

- (UIImage *)downloadAvatarFull:(SyncanoAvatar *)avatarInfo {
	return [self downloadImageFromURL:avatarInfo.image];
}

- (UIImage *)downloadAvatarThumbnail:(SyncanoAvatar *)avatarInfo {
	return [self downloadImageFromURL:avatarInfo.thumbnail];
}

#pragma mark - Asynchronized

- (id <SyncanoRequest> )dataNew:(SyncanoParameters_DataObjects_New *)params callback:(void (^)(SyncanoResponse_DataObjects_New *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_DataObjects_New *)response);
		}
	}];
}

- (id <SyncanoRequest> )dataGet:(SyncanoParameters_DataObjects_Get *)params callback:(void (^)(SyncanoResponse_DataObjects_Get *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_DataObjects_Get *)response);
		}
	}];
}

- (id <SyncanoRequest> )dataGetOne:(SyncanoParameters_DataObjects_GetOne *)params callback:(void (^)(SyncanoResponse_DataObjects_GetOne *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_DataObjects_GetOne *)response);
		}
	}];
}

- (id <SyncanoRequest> )dataUpdate:(SyncanoParameters_DataObjects_Update *)params callback:(void (^)(SyncanoResponse_DataObjects_Update *))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_DataObjects_Update *)response);
		}
	}];
}

- (id <SyncanoRequest> )dataMove:(SyncanoParameters_DataObjects_Move *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )dataCopy:(SyncanoParameters_DataObjects_Copy *)params callback:(void (^)(SyncanoResponse_DataObjects_Copy *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_DataObjects_Copy *)response);
		}
	}];
}

- (id <SyncanoRequest> )dataAddParent:(SyncanoParameters_DataObjects_AddParent *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )dataRemoveParent:(SyncanoParameters_DataObjects_RemoveParent *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )dataAddChild:(SyncanoParameters_DataObjects_AddChild *)params callback:(void (^)(SyncanoResponse *))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )dataRemoveChild:(SyncanoParameters_DataObjects_RemoveChild *)params callback:(void (^)(SyncanoResponse *))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )dataDelete:(SyncanoParameters_DataObjects_Delete *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )dataCount:(SyncanoParameters_DataObjects_Count *)params callback:(void (^)(SyncanoResponse_DataObjects_Count *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_DataObjects_Count *)response);
		}
	}];
}

- (id <SyncanoRequest> )downloadImageFull:(SyncanoImage *)imageInfo callback:(void (^)(UIImage *))callback {
	return [self downloadImageFromURL:imageInfo.image callback:callback];
}

- (id <SyncanoRequest> )downloadImageThumbnail:(SyncanoImage *)imageInfo callback:(void (^)(UIImage *))callback {
	return [self downloadImageFromURL:imageInfo.thumbnail callback:callback];
}

- (id <SyncanoRequest> )downloadAvatarFull:(SyncanoAvatar *)avatarInfo callback:(void (^)(UIImage *))callback {
	return [self downloadImageFromURL:avatarInfo.image callback:callback];
}

- (id <SyncanoRequest> )downloadAvatarThumbnail:(SyncanoAvatar *)avatarInfo callback:(void (^)(UIImage *))callback {
	return [self downloadImageFromURL:avatarInfo.thumbnail callback:callback];
}

#pragma mark protocol SyncanoProtocolUsers
/*----------------------------------------*/

#pragma mark - Synchronized

- (SyncanoResponse_Users_Login *)userLogin:(SyncanoParameters_Users_Login *)params {
	return (SyncanoResponse_Users_Login *)[self sendRequest:params];
}

- (SyncanoResponse_Users_New *)userNew:(SyncanoParameters_Users_New *)params {
	return (SyncanoResponse_Users_New *)[self sendRequest:params];
}

- (SyncanoResponse_Users_GetAll *)userGetAll:(SyncanoParameters_Users_GetAll *)params {
	return (SyncanoResponse_Users_GetAll *)[self sendRequest:params];
}

- (SyncanoResponse_Users_Get *)userGet:(SyncanoParameters_Users_Get *)params {
	return (SyncanoResponse_Users_Get *)[self sendRequest:params];
}

- (SyncanoResponse_Users_GetOne *)userGetOne:(SyncanoParameters_Users_GetOne *)params {
	return (SyncanoResponse_Users_GetOne *)[self sendRequest:params];
}

- (SyncanoResponse_Users_Update *)userUpdate:(SyncanoParameters_Users_Update *)params {
	return (SyncanoResponse_Users_Update *)[self sendRequest:params];
}

- (SyncanoResponse_Users_Count *)userCount:(SyncanoParameters_Users_Count *)params {
	return (SyncanoResponse_Users_Count *)[self sendRequest:params];
}

- (SyncanoResponse *)userDelete:(SyncanoParameters_Users_Delete *)params {
	return [self sendRequest:params];
}

#pragma mark - Asynchronized

- (id <SyncanoRequest> )userLogin:(SyncanoParameters_Users_Login *)params callback:(void (^)(SyncanoResponse_Users_Login *))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Users_Login *)response);
		}
	}];
}

- (id <SyncanoRequest> )userNew:(SyncanoParameters_Users_New *)params callback:(void (^)(SyncanoResponse_Users_New *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Users_New *)response);
		}
	}];
}

- (id <SyncanoRequest> )userGetAll:(SyncanoParameters_Users_GetAll *)params callback:(void (^)(SyncanoResponse_Users_GetAll *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Users_GetAll *)response);
		}
	}];
}

- (id <SyncanoRequest> )userGet:(SyncanoParameters_Users_Get *)params callback:(void (^)(SyncanoResponse_Users_Get *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Users_Get *)response);
		}
	}];
}

- (id <SyncanoRequest> )userGetOne:(SyncanoParameters_Users_GetOne *)params callback:(void (^)(SyncanoResponse_Users_GetOne *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Users_GetOne *)response);
		}
	}];
}

- (id <SyncanoRequest> )userUpdate:(SyncanoParameters_Users_Update *)params callback:(void (^)(SyncanoResponse_Users_Update *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Users_Update *)response);
		}
	}];
}

- (id <SyncanoRequest> )userCount:(SyncanoParameters_Users_Count *)params callback:(void (^)(SyncanoResponse_Users_Count *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Users_Count *)response);
		}
	}];
}

- (id <SyncanoRequest> )userDelete:(SyncanoParameters_Users_Delete *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

#pragma mark - protocol SyncanoProtocolPermissionRoles <NSObject>

#pragma mark - Synchronized

- (SyncanoResponse_PermissionRoles_Get *)roleGet:(SyncanoParameters_PermissionRoles_Get *)params {
	return (SyncanoResponse_PermissionRoles_Get *)[self sendRequest:params];
}

#pragma mark - Asynchronized

- (id <SyncanoRequest> )roleGet:(SyncanoParameters_PermissionRoles_Get *)params callback:(void (^)(SyncanoResponse_PermissionRoles_Get *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_PermissionRoles_Get *)response);
		}
	}];
}

#pragma mark - SyncanoProtocolAdministrators <NSObject>

#pragma mark - Synchronized

- (SyncanoResponse *)adminNew:(SyncanoParameters_Administrators_New *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse_Administrators_Get *)adminGet:(SyncanoParameters_Administrators_Get *)params {
	return (SyncanoResponse_Administrators_Get *)[self sendRequest:params];
}

- (SyncanoResponse_Administrators_GetOne *)adminGetOne:(SyncanoParameters_Administrators_GetOne *)params {
	return (SyncanoResponse_Administrators_GetOne *)[self sendRequest:params];
}

- (SyncanoResponse_Administrators_Update *)adminUpdate:(SyncanoParameters_Administrators_Update *)params {
	return (SyncanoResponse_Administrators_Update *)[self sendRequest:params];
}

- (SyncanoResponse *)adminDelete:(SyncanoParameters_Administrators_Delete *)params {
	return [self sendRequest:params];
}

#pragma mark - Asynchronized

- (id <SyncanoRequest> )adminNew:(SyncanoParameters_Administrators_New *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )adminGet:(SyncanoParameters_Administrators_Get *)params callback:(void (^)(SyncanoResponse_Administrators_Get *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Administrators_Get *)response);
		}
	}];
}

- (id <SyncanoRequest> )adminGetOne:(SyncanoParameters_Administrators_GetOne *)params callback:(void (^)(SyncanoResponse_Administrators_GetOne *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Administrators_GetOne *)response);
		}
	}];
}

- (id <SyncanoRequest> )adminUpdate:(SyncanoParameters_Administrators_Update *)params callback:(void (^)(SyncanoResponse_Administrators_Update *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_Administrators_Update *)response);
		}
	}];
}

- (id <SyncanoRequest> )adminDelete:(SyncanoParameters_Administrators_Delete *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

#pragma mark - protocol SyncanoProtocolAPIKeys <NSObject>

#pragma mark - Synchronized

- (SyncanoResponse_APIKeys_StartSession *)apiKeyStartSession:(SyncanoParameters_APIKeys_StartSession *)params {
	return (SyncanoResponse_APIKeys_StartSession *)[self sendRequest:params];
}

- (SyncanoResponse_APIKeys_New *)apiKeyNew:(SyncanoParameters_APIKeys_New *)params {
	return (SyncanoResponse_APIKeys_New *)[self sendRequest:params];
}

- (SyncanoResponse_APIKeys_Get *)apiKeyGet:(SyncanoParameters_APIKeys_Get *)params {
	return (SyncanoResponse_APIKeys_Get *)[self sendRequest:params];
}

- (SyncanoResponse_APIKeys_GetOne *)apiKeyGetOne:(SyncanoParameters_APIKeys_GetOne *)params {
	return (SyncanoResponse_APIKeys_GetOne *)[self sendRequest:params];
}

- (SyncanoResponse_APIKeys_UpdateDescription *)apiKeyUpdateDescription:(SyncanoParameters_APIKeys_UpdateDescription *)params {
	return (SyncanoResponse_APIKeys_UpdateDescription *)[self sendRequest:params];
}

- (SyncanoResponse *)apiKeyAuthorize:(SyncanoParameters_APIKeys_Authorize *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)apiKeyDeauthorize:(SyncanoParameters_APIKeys_Deauthorize *)params {
	return [self sendRequest:params];
}

- (SyncanoResponse *)apiKeyDelete:(SyncanoParameters_APIKeys_Delete *)params {
	return [self sendRequest:params];
}

#pragma mark - Asynchronized

- (id <SyncanoRequest> )apiKeyStartSession:(SyncanoParameters_APIKeys_StartSession *)params callback:(void (^)(SyncanoResponse_APIKeys_StartSession *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_APIKeys_StartSession *)response);
		}
	}];
}

- (id <SyncanoRequest> )apiKeyNew:(SyncanoParameters_APIKeys_New *)params callback:(void (^)(SyncanoResponse_APIKeys_New *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_APIKeys_New *)response);
		}
	}];
}

- (id <SyncanoRequest> )apiKeyGet:(SyncanoParameters_APIKeys_Get *)params callback:(void (^)(SyncanoResponse_APIKeys_Get *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_APIKeys_Get *)response);
		}
	}];
}

- (id <SyncanoRequest> )apiKeyGetOne:(SyncanoParameters_APIKeys_GetOne *)params callback:(void (^)(SyncanoResponse_APIKeys_GetOne *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_APIKeys_GetOne *)response);
		}
	}];
}

- (id <SyncanoRequest> )apiKeyUpdateDescription:(SyncanoParameters_APIKeys_UpdateDescription *)params callback:(void (^)(SyncanoResponse_APIKeys_UpdateDescription *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback((SyncanoResponse_APIKeys_UpdateDescription *)response);
		}
	}];
}

- (id <SyncanoRequest> )apiKeyAuthorize:(SyncanoParameters_APIKeys_Authorize *)params callback:(void (^)(SyncanoResponse *))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )apiKeyDeauthorize:(SyncanoParameters_APIKeys_Deauthorize *)params callback:(void (^)(SyncanoResponse *))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

- (id <SyncanoRequest> )apiKeyDelete:(SyncanoParameters_APIKeys_Delete *)params callback:(void (^)(SyncanoResponse *response))callback {
	return [self sendAsyncRequest:params callback: ^(SyncanoResponse *response) {
    if (callback) {
      callback(response);
		}
	}];
}

@end

@implementation SyncanoParametersCallbackPair
+ (instancetype)pairWithParams:(SyncanoParameters *)params callback:(SyncanoCallback)callback {
	SyncanoParametersCallbackPair *pair = [[self alloc] init];
	pair.params = params;
	pair.callback = callback;
	return pair;
}

+ (instancetype)pairWithBatchParams:(NSArray *)batchParams batchCallback:(SyncanoBatchCallback)callback {
	SyncanoParametersCallbackPair *pair = [[self alloc] init];
	pair.batchParams = batchParams;
	pair.batchCallback = callback;
	return pair;
}

@end

@interface Syncano (PausedRequests)

/**
 Creates an asynchronous request to Syncano using given parameters.
 
 Instead of using only one callback like 'sendAsyncBatchRequest:callback'
 it uses two blocks: 'success', which will be called only when https request
 reached the server (but may have failed on Syncano server), and 'failure',
 which will be called in case of error with internet connection.
 
 @warning This behaviour is different that sending single requests. It is
 because when handling multiple requests being sent, it is possible only
 some of them will be successful on Syncano, and some of them will fail.
 Regardless of the fact, even if all of them failed on Syncano side (e.g.
 by providing wrong parameters type), responses will still be passed on
 'success' block.
 
 @warning Returned request will be in the paused state! It will not be
 sent to Syncano until it's resumed first.
 
 @code
 id <SyncanoRequest> request = [syncano getPausedBatchRequest ...];
 //do some needed action and resume it when needed
 [request resume];
 @endcode
 
 @param params  Parameters with which request will be sent.
 @param success Block that will be called if https requests went through
 successfully.
 @param failure Block that will be called in case of problems with internet
 connection, which will affect reaching Syncano server.
 
 @return Object implementing 'SyncanoRequest' protocol, which will enable
 asking about its state, as well as pausing/resuming/cancellation
 of the request.
 */
- (id <SyncanoRequest> )getPausedBatchRequest:(NSArray *)params
                                      success:(SyncanoBatchSuccess)success
                                      failure:(SyncanoFailure)failure;

/**
 Creates an asynchronous request to Syncano using given parameters.
 Instead of using only one callback like 'sendAsyncRequest:callback'
 it uses two blocks: 'success', which will be called only when response from
 Syncano server wass successful, and 'failure', which will be called either
 on error on Syncano, or in case of error with internet connection.
 
 @warning Returned request will be in the paused state! It will not be
 sent to Syncano until it's resumed first.
 
 @code
 id <SyncanoRequest> request = [syncano getPausedRequest ...];
 //do some needed action and resume it when needed
 [request resume];
 @endcode
 
 @param params  Parameters with which request will be sent.
 @param success Block that will be called if both https requests went through
 and response from Syncano was successful.
 @param failure Block that will be called in case of Syncano error or problems
 with internet connection, which will affect reaching Syncano server.
 
 @return Object implementing 'SyncanoRequest' protocol, which will enable asking
 about its state, as well as pausing/resuming/cancellation of the request.
 */
- (id <SyncanoRequest> )getPausedRequest:(SyncanoParameters *)params
                                 success:(SyncanoSuccess)success
                                 failure:(SyncanoFailure)failure;

@end

NSString *const kDefaultLibraryName = @"syncano-ios";
NSString *const KDefaultVersionNumber = @"3.1.32";

@implementation Syncano (Private)

+ (NSDictionary *)podspecFileContent {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"syncano-ios.podspec" ofType:@"json"];
    NSData *podspecData = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *podspecJsonContent = nil;
    if (podspecData) {
        podspecJsonContent = [NSJSONSerialization JSONObjectWithData:podspecData options:kNilOptions error:&error];
    }
    if (error) {
        podspecJsonContent = nil;
    }
    return podspecJsonContent;
}

+ (NSString *)libraryName {
    NSDictionary *podspec = [self podspecFileContent];
    NSString *name = [podspec objectForKey:@"name"];
    if (name == nil) {
        name = kDefaultLibraryName;
    }
    return name;
}

+ (NSString *)libraryVersionNumber {
    NSDictionary *podspec = [self podspecFileContent];
    NSString *version = [podspec objectForKey:@"version"];
    if (version == nil) {
        version = KDefaultVersionNumber;
    }
    return version;
}

+ (NSString *)userAgent {
    NSString *userAgent = [NSString stringWithFormat:@"%@-%@",[self libraryName],[self libraryVersionNumber]];
    return userAgent;
}

@end
