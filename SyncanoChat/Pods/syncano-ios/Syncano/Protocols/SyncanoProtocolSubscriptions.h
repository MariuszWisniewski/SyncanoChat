//
//  SyncanoProtocolSubscriptions.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#ifndef Syncano_SyncanoProtocolSubscriptions_h
#define Syncano_SyncanoProtocolSubscriptions_h

#import "SyncanoParameters_Subscriptions.h"
#import "SyncanoResponse_Subscriptions.h"
#import "SyncanoProtocolRequest.h"

/**
 SyncanoProtocolSubscriptions is used to transmit information about SyncanoSubscription objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer communicating with Syncano API.
 @note This protocol defines only asynchronous methods, it is to be used only with SyncanoSyncServer
 */
@protocol SyncanoProtocolSubscriptions <NSObject>
@required

#pragma mark - Synchronized

//Not present, to be used only with SyncServer

#pragma mark - Asynchronized

///-
/// @name Asynchronous requests
///-

/**
 Subscribe to project.
 
 @note User API key usage permitted with context session or connection if subscribe permission is added through apikey.authorize() and read_data permission is added to specified project through project.authorize().
 
 @param params   parameters for subscription
 */
- (void)subscriptionSubscribeProject:(SyncanoParameters_Subscriptions_SubscribeProject *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Unsubscribe project.
 
 @note User API key usage permitted.
 
 @param params   parameters for unsubscription
 */
- (void)subscriptionUnsubscribeProject:(SyncanoParameters_Subscriptions_UnsubscribeProject *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Subscribe to collection within specified project.
 
 @note User API key usage permitted with context session or connection if subscribe permission is added through apikey.authorize() and read_data permission is added to specified collection through collection.authorize() or project.authorize().
 
 @param params   parameters for subscription
 */
- (void)subscriptionSubscribeCollection:(SyncanoParameters_Subscriptions_SubscribeCollection *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Unsubscribe to collection within specified project.
 
 @note User API key usage permitted.
 
 @param params   parameters for unsubscription
 */
- (void)subscriptionUnsubscribeCollection:(SyncanoParameters_Subscriptions_UnsubscribeCollection *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Get subscriptions
 
 @note User API key usage permitted.
 
 @param params   Parameters for getting subscriptions
 */
- (void)subscriptionGet:(SyncanoParameters_Subscriptions_Get *)params callback:(void (^)(SyncanoResponse_Subscriptions_Get *response))callback;

@end

#endif
