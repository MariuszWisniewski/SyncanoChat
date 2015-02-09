//
//  SyncanoParameters_Notifications.h
//  Syncano
//
//  Created by Syncano Inc. on 07/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters.h"

/**
   Sends custom notification to API client through Sync Server.

   If uuid is specified - will only send to this specific instance.
 */
@interface SyncanoParameters_Notifications_Send : SyncanoParameters
/**
   Destination API client id. If not specified, will query current API client's connections.
 */
@property (strong)    NSString *apiClientId;
/**
   UUID of specified API client's connection. If not specified, will send a broadcast to all specified API client's connections.
 */
@property (strong)    NSString *uuid;
/**
   Any number of additional parameters will be sent as well into data structure.
 */
@property (strong)    NSDictionary *additional;
@end

/**
   Get a history of notifications of current API client. History items are stored for 24 hours.
 */
@interface SyncanoParameters_Notifications_GetHistory : SyncanoParameters
/**
   If specified, will only return data with id higher than since_id (newer).
 */
@property (strong)    NSString *sinceId;
/**
   String with date. If specified, will only return data with timestamp after specified value (newer).
 */
@property (strong)    NSDate *sinceTime;
/**
   Maximum number of history items to get. Default and max: 100.
 */
@property (strong)    NSNumber *limit;
/**
   Order of data that will be returned. Possible values:

   - ASC (default) - oldest first,
   - DESC - newest first.
 */
@property (strong, nonatomic)    NSString *order;
@end
