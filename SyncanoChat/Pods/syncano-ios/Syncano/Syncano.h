//
//  Syncano.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SyncanoParametersListing.h"
#import "SyncanoResponsesListing.h"
#import "SyncanoProtocolsListing.h"
#import "SyncanoReachability.h"

extern NSInteger const kSyncanoMaxNumberOfRequestsInBatchCall;

typedef void (^SyncanoCallback)(SyncanoResponse *response);
typedef void (^SyncanoSuccess)(id <SyncanoRequest> request, SyncanoResponse *response);
typedef void (^SyncanoBatchSuccess)(id <SyncanoRequest> request, NSArray *responses);
typedef void (^SyncanoFailure)(id <SyncanoRequest> request, NSError *error);
typedef void (^SyncanoBatchCallback)(NSArray *responses);

/**
 Syncano class should be used to send any requests to Syncano using your
 credentials. You can use universal sendRequest method or methods listed
 in implemented protocols.
 */
@interface Syncano : NSObject <SyncanoProtocolAPIKeys, SyncanoProtocolProjects,
SyncanoProtocolCollections, SyncanoProtocolFolders,
SyncanoProtocolDataObjects, SyncanoProtocolUsers,
SyncanoProtocolPermissionRoles, SyncanoProtocolAdministrators>

/**
 Your subdomain in Syncano
 */
@property (strong, readonly) NSString *domain;

/**
 API Key of used instance
 */
@property (strong, readonly) NSString *apiKey;

/**
 Preferred timezone
 */
@property (strong, readwrite) NSString *timezone;

/**
 User authorization key.
 */
@property (strong, readwrite) NSString *authKey;

/**
 Reachability for current instance domain. Use to monitor domain reachability.
 You do not have to start monitoring manually, Syncano will start it for you.
 */
@property (strong, readonly, nonatomic) SyncanoReachability *reachability;

///
/// @name Debug
///

/**
 Use to enable/disable logging all requests being sent to Syncano.
 Even when enabled, works only in DEBUG mode!
 */

@property (assign, readwrite) BOOL logAllRequests;

/**
 Use to enable/disable logging all JSON responses incoming from Syncano.
 Even when enabled, works only in DEBUG mode!
 */
@property (assign, readwrite) BOOL logJSONResponses;

///-
/// @name Initialization
///-

/**
 Creates Syncano object. You should store it and use it as an shared
 instance in your application.
 
 @param domain   Your subdomain in Syncano
 @param apiKey  API Key of used instance
 
 @return Syncano object, configured to communicate with your subdomain instance
 using given credentials.
 */
+ (Syncano *)syncanoForDomain:(NSString *)domain apiKey:(NSString *)apiKey;

/**
 Initializes allocated Syncano object. You should store this initialized object
 and use it as an shared instance in your application.
 
 @param domain   Your subdomain in Syncano
 @param apiKey  API Key of used instance
 
 @return Syncano initialized object, configured to communicate with your
 subdomain instance using given credentials.
 */
- (Syncano *)initWithDomain:(NSString *)domain apiKey:(NSString *)apiKey;

///-
/// @name Sending requests
///-

/**
 Sends a synchronous request to Syncano, using given parameters.
 
 @param params Parameters with which request will be sent.
 
 @return Response for request sent with given parameters.
 It will contain response for request sent with given parameters, or error when
 request failed (either because of Syncano error or because of network issues)
 */
- (SyncanoResponse *)sendRequest:(SyncanoParameters *)params;

/**
 Sends an asynchronous request to Syncano, using given parameters.
 
 @param params   Parameters with which request will be sent.
 @param callback Block that will be performed when response is ready.
 It will contain response for request sent with given parameters, or error when
 request failed (either because of Syncano error or because of network issues)
 
 @return Object implementing 'SyncanoRequest' protocol, which will enable asking
 about its state, as well as pausing/resuming/cancellation of the request.
 */
- (id <SyncanoRequest> )sendAsyncRequest:(SyncanoParameters *)params
                                callback:(SyncanoCallback)callback;

/**
 Sends an asynchronous request to Syncano using given parameters.
 Instead of using only one callback like 'sendAsyncRequest:callback'
 it uses two blocks: 'success', which will be called only when response from
 Syncano server wass successful, and 'failure', which will be called either
 on error on Syncano, or in case of error with internet connection.
 
 @param params  Parameters with which request will be sent.
 @param success Block that will be called if both https requests went through
 and response from Syncano was successful.
 @param failure Block that will be called in case of Syncano error or problems
 with internet connection, which will affect reaching Syncano server.
 
 @return Object implementing 'SyncanoRequest' protocol, which will enable asking
 about its state, as well as pausing/resuming/cancellation of the request.
 */
- (id <SyncanoRequest> )sendAsyncRequest:(SyncanoParameters *)params
                                 success:(SyncanoSuccess)success
                                 failure:(SyncanoFailure)failure;

/**
 Sends a synchronous batch request to Syncano with multiple parameters.
 
 @param params Array of parameters that will be sent.
 
 @return Array of responses for request with given parameters.
 It will hold objects containing either responses for sent requests, or errors
 when request failed (either because of Syncano error or because of network
 issues)
 */
- (NSArray *)sendBatchRequest:(NSArray *)params;

/**
 Sends an asynchronous batch request to Syncano with multiple parameters.
 
 @param params   Parameters with which request will be sent.
 @param callback Block that will be performed when response is ready.
 It will hold objects containing either responses for sent requests, or errors
 when request failed (either because of Syncano error or because of network
 issues)
 */
- (id <SyncanoRequest> )sendAsyncBatchRequest:(NSArray *)params
                                     callback:(SyncanoBatchCallback)callback;

/**
 Sends an asynchronous batch request to Syncano with multiple parameters.
 
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
 
 @param params  Parameters with which request will be sent.
 @param success Block that will be called if https requests went through
 successfully.
 @param failure Block that will be called in case of problems with internet
 connection, which will affect reaching Syncano server.
 
 @return Object implementing 'SyncanoRequest' protocol, which will enable
 asking about its state, as well as pausing/resuming/cancellation
 of the request.
 */
- (id <SyncanoRequest> )sendAsyncBatchRequest:(NSArray *)params
                                      success:(SyncanoBatchSuccess)success
                                      failure:(SyncanoFailure)failure;

/**
 Cancells all pending requests.
 */
- (void)cancellAllRequests;

@end
