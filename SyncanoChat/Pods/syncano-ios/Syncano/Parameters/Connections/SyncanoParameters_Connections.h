//
//  SyncanoParameters_Connections.h
//  Syncano
//
//  Created by Syncano Inc. on 13/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters.h"

/**
   Get currently connected API client connections up to a limit (max 100).
 */
@interface SyncanoParameters_Connections_Get : SyncanoParameters
/**
   API client id. If not specified, will get connections for current API client.
 */
@property (strong) NSString *apiClientId;
/**
   If specified, will only return connections of specified name.
 */
@property (strong) NSString *name;
/**
   If specified, will only return data created after specified uuid (newer).
 */
@property (strong) NSString *sinceId;
/**
   Maximum number of API client connections to get. Default and max: 100.
 */
@property (strong) NSNumber *limit;
@end

/**
   Get all connections from current instance up to a limit (max 100).
 */
@interface SyncanoParameters_Connections_Get_All : SyncanoParameters
/**
   If specified, will only return connections of specified name.
 */
@property (strong) NSString *name;
/**
   If specified, will only return data created after specified uuid (newer).
 */
@property (strong) NSString *sinceId;
/**
   Maximum number of API client connections to get. Default and max: 100.
 */
@property (strong) NSNumber *limit;
@end

/**
   Updates specified API client connection info.
 */
@interface SyncanoParameters_Connections_Update : SyncanoParameters
/**
   Connection UUID.
 */
@property (strong) NSString *uuid;
/**
   New state to set.
 */
@property (strong) NSString *state;
/**
   API client id. If not specified, will query current API client connections.
 */
@property (strong) NSString *apiClientId;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Connections_Update *)initWithUUID:(NSString *)uuid state:(NSString *)state;

@end
