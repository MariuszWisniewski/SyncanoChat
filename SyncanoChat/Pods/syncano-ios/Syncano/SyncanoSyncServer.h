//
//  SyncanoSyncServer.h
//  Syncano
//
//  Created by Syncano Inc. on 13/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SyncanoParametersListing.h"
#import "SyncanoResponsesListing.h"
#import "SyncanoProtocolsListing.h"

extern NSTimeInterval const kSyncanoSyncServerDefaultTimeout;

typedef void (^SyncanoSyncServerCallback)(SyncanoResponse *response);
typedef void (^SyncanoSyncServerBatchCallback)(NSArray *responses);

typedef void (^SyncanoSyncServerConnectionOpenCallback)(void);
typedef void (^SyncanoSyncServerConnectionClosedCallback)(NSError *error);
typedef void (^SyncanoSyncServerMessageReceivedCallback)(id message);
typedef void (^SyncanoSyncServerHistoryReceivedCallback)(id message, BOOL isLastHistoryItem);
typedef void (^SyncanoSyncServerResponseCallback)(SyncanoResponse *response);
typedef void (^SyncanoSyncServerErrorCallback)(NSString *error);
typedef void (^SyncanoSyncServerDeletedCallback)(NSArray *deletedIDs, SyncanoChannel *channel);
typedef void (^SyncanoSyncServerChangedCallback)(NSArray *dataChanges, SyncanoChannel *channel);
typedef void (^SyncanoSyncServerAddedCallback)(SyncanoData *addedData, SyncanoChannel *channel);
typedef void (^SyncanoSyncServerRelationDeletedCallback)(SyncanoDataRelation *relation, SyncanoChannel *channel);
typedef void (^SyncanoSyncServerRelationAddedCallback)(SyncanoDataRelation *relation, SyncanoChannel *channel);

/**
 SyncanoSyncServer class should be used to send any requests to Syncano using Sync Server functionality, and passed credentials, as well as to send and receive notifications, and to subscribe/unsubscribe from changes. You can use universal sendRequest method or methods listed in implemented protocols.
 */

@protocol SyncanoSyncServerDelegate;

@interface SyncanoSyncServer : NSObject
<
SyncanoProtocolNotification,
SyncanoProtocolSubscriptions,
SyncanoProtocolConnections
>

/**
 *  Delegate to which all callbacks about connection state will be sent. Can be used instead, or in parallel witch set callback blocks.
 */
@property (weak, nonatomic) id <SyncanoSyncServerDelegate> delegate;

/**
 Client can pass timezone parameter with valid timezone from Olson tz database. To easily find timezone you can use [Time Zone Converter](http://www.timezoneconverter.com/cgi-bin/findzone.tzc). This timezone will be used for the whole connection unless overriden in specific API calls.
 
 @warning Has to be set before [connect:](connect:connectionOpen:connectionClosed:messageReceived:historyReceived:syncServerError:notificationDeleted:notificationChanged:notificationAdded:) method is called to affect the connection.
 */
@property (strong, nonatomic)   NSString *timezone;

/**
 By passing `name` you will create an identity with specified name. Name does not need to be unique, but it can be useful to find specific identities.
 
 @warning Has to be set before [connect:](connect:connectionOpen:connectionClosed:messageReceived:historyReceived:syncServerError:notificationDeleted:notificationChanged:notificationAdded:) method is called to affect the connection.
 */
@property (strong, nonatomic)   NSString *name;

/**
 By passing `state` you will assign state to created identity. State does not need to be unique, serves informational purposes e.g. for other identities.
 
 @warning Has to be set before [connect:](connect:connectionOpen:connectionClosed:messageReceived:historyReceived:syncServerError:notificationDeleted:notificationChanged:notificationAdded:) method is called to affect the connection.
 */
@property (strong, nonatomic)  NSString *state;

/**
 By passing `sinceId` you will get history items that have greater id than specified.
 
 @warning Has to be set before [connect:](connect:connectionOpen:connectionClosed:messageReceived:historyReceived:syncServerError:notificationDeleted:notificationChanged:notificationAdded:) method is called to affect the connection.
 */
@property (strong, nonatomic) NSNumber *sinceId;

/**
 By passing `sinceTime` you will get history items that occurred after specified time.
 
 @warning Has to be set before [connect:](connect:connectionOpen:connectionClosed:messageReceived:historyReceived:syncServerError:notificationDeleted:notificationChanged:notificationAdded:) method is called to affect the connection.
 */
@property (strong, nonatomic) NSDate *sinceTime;

/**
 When using User API key, you need to additionally pass auth_key which you can obtain through user.login() API method. You also need to first authorize User API client with access_sync permission through apikey.authorize().
 
 @warning Has to be set before [connect:](connect:connectionOpen:connectionClosed:messageReceived:historyReceived:syncServerError:notificationDeleted:notificationChanged:notificationAdded:) method is called to affect the connection.
 */
@property (strong, nonatomic) NSString *authKey;

/**
 UUID is being set after connection with Sync Server was successfully established.
 It can be used to distinguish between different connections, as well as to
 ignore notifications send by ourselves.
 
 @warning Until connection was established, it's equal to nil.
 */
@property (strong, readonly, nonatomic) NSString *uuid;

/**
 Use to enable/disable logging all messages incoming from Syncano.
 Even when enabled, works only in DEBUG mode!
 */
@property (assign, readwrite) BOOL logMessages;

/**
 Creates SyncanoSyncServer object in given domain with passed credentials. You should store it and use as a shared object in your application.
 
 @param domain   Your subdomain in Syncano
 @param apiKey  API Key of used instance
 
 @return SyncanoSyncServer object, configured to communicate with your subdomain instance using given credentials.
 */
+ (SyncanoSyncServer *)syncanoSyncServerForDomain:(NSString *)domain apiKey:(NSString *)apiKey;

/**
 Initializes SyncanoSyncServer object in given domain with passed credentials. You should store it and used as a shared object in your application.
 
 @param domain   Your subdomain in Syncano
 @param apiKey  API Key of used instance
 
 @return SyncanoSyncServer initialized object, configured to communicate with your subdomain instance using given credentials.
 */
- (SyncanoSyncServer *)initWithDomain:(NSString *)domain apiKey:(NSString *)apiKey;

/**
 Connects to Syncano Sync Server using credentials passed when creating this Sync Server object.
 
 @param errorPointer             Pointer to NSError that will be set when an error occurs. Possible errors would be a `nil` host, invalid interface, or socket is already connected.
 @param connectionOpenCallback   Block to call when connection was opened.
 @param connectionClosedCallback Block to call when connection was closed.
 @param messageReceivedCallback  Block to call when received message from Sync Server.
 @param historyReceivedCallback  Block to call when received message history from Sync Server.
 @param syncServerErrorCallback  Block to call when received error from Sync Server.
 @param deletedCallback          Block to call when Sync Server notifies about deleted object(s).
 @param changedCallback          Block to call when Sync Server notifies about changed object(s).
 @param addedCallback            Block to call when Sync Server notifies about added object.
 
 @return NO if an error is detected (will also set the error pointer if one was given) or if connection was already open, YES if no errors were detected. This method will immediately return regardless of connection state and errors presence.
 */
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
notificationRelationAdded:(SyncanoSyncServerRelationAddedCallback)relationAddedCallback;

/**
 *  Connects to Syncano Sync Server using credentials passed when creating this Sync Server object.
 When using this method all callbacks will be sent to the delegate. Because of that, it's reccomended to set the delegate before opening the connection.
 *
 *  @param errorPointer Pointer to NSError that will be set when an error occurs. Possible errors would be a `nil` host, invalid interface, or socket is already connected.
 *
 *  @return NO if an error is detected (will also set the error pointer if one was given) or if connection was already open, YES if no errors were detected. This method will immediately return regardless of connection state and errors presence.
 */
- (BOOL)connect:(NSError **)errorPointer;

/**
 Closes connection to Sync Server
 */
- (void)closeConnection;

/**
 Checks if connection is already open.
 
 @return YES if connection was already opened, NO if connection was closed.
 */
- (BOOL)isConnectionOpen;

/**
 Sends request to Syncano by Sync Server functionality, using given parameters.
 
 @param parameters Parameters to send with this request.
 @param callback   Block to call when response from Syncano is ready.
 */
- (void)sendRequest:(SyncanoParameters *)parameters callback:(SyncanoSyncServerResponseCallback)callback;

@end

@protocol SyncanoSyncServerDelegate <NSObject>

@required
- (void)syncServerConnectionOpened:(SyncanoSyncServer *)syncServer;
- (void)syncServer:(SyncanoSyncServer *)syncServer connectionClosedWithError:(NSError *)error;

@optional

- (void)syncServer:(SyncanoSyncServer *)syncServer messageReceived:(id)message;
- (void)syncServer:(SyncanoSyncServer *)syncServer historyReceived:(id)message isLastHistoryItem:(BOOL)isLastHistoryItem;
- (void)syncServer:(SyncanoSyncServer *)syncServer errorReceived:(NSString *)error;

- (void)syncServer:(SyncanoSyncServer *)syncServer notificationDeleted:(NSArray *)deletedIds channel:(SyncanoChannel *)channel;
- (void)syncServer:(SyncanoSyncServer *)syncServer notificationChanged:(NSArray *)dataChanges channel:(SyncanoChannel *)channel;
- (void)syncServer:(SyncanoSyncServer *)syncServer notificationAdded:(SyncanoData *)addedData channel:(SyncanoChannel *)channel;
- (void)syncServer:(SyncanoSyncServer *)syncServer notificationRelationDeleted:(SyncanoDataRelation *)relation channel:(SyncanoChannel *)channel;
- (void)syncServer:(SyncanoSyncServer *)syncServer notificationRelationAdded:(SyncanoDataRelation *)relation channel:(SyncanoChannel *)channel;

- (void)syncServer:(SyncanoSyncServer *)syncServer notificationDeleted:(NSArray *)deletedIds DEPRECATED_MSG_ATTRIBUTE("Use syncServer:notificationDeleted:channel instead");

- (void)syncServer:(SyncanoSyncServer *)syncServer notificationChanged:(NSArray *)dataChanges DEPRECATED_MSG_ATTRIBUTE("Use syncServer:notificationChanged:channel: instead");

- (void)syncServer:(SyncanoSyncServer *)syncServer notificationAdded:(SyncanoData *)addedData DEPRECATED_MSG_ATTRIBUTE("Use syncServer:notificationAdded:channel: instead");

@end
