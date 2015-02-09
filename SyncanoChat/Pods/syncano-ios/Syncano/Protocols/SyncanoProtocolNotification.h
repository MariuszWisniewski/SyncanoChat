//
//  SyncanoProtocolNotification.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#ifndef Syncano_SyncanoProtocolNotification_h
#define Syncano_SyncanoProtocolNotification_h

#import "SyncanoParameters_Notifications.h"
#import "SyncanoResponse_Notifications.h"
#import "SyncanoProtocolRequest.h"

/**
 SyncanoProtocolNotification is used to transmit information about SyncanoParameters_Notifications_Send objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer communicating with Syncano API.
 @note This protocol defines only asynchronous methods, it is to be used only with SyncanoSyncServer
 */
@protocol SyncanoProtocolNotification <NSObject>
@required

#pragma mark - Synchronized

// Not present, to be used only with SyncServer

#pragma mark - Asynchronized

///-
/// @name Asynchronous requests
///-

/**
 Send custom notification through Sync Server.
 
 @note User API key usage permitted if send_notification permission is added through apikey.authorize().
 
 @param params Parameters for sending custom notification to client through Sync Server.
 */
- (void)notificationSend:(SyncanoParameters_Notifications_Send *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Get specified collection history of notifications of current or specified client. History items are stored for 24 hours.
 
 @note User API key usage permitted if subscribe permission is added through apikey.authorize().
 
 @param params Parameters for getting notification history
 */
- (void)notificationGetHistory:(SyncanoParameters_Notifications_GetHistory *)params callback:(void (^)(SyncanoResponse_Notifications_GetHistory *response))callback;
@end

#endif
