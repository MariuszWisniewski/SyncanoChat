//
//  SyncanoResponse_Connections.h
//  Syncano
//
//  Created by Syncano Inc. on 13/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse.h"
#import "SyncanoObjects.h"

@interface SyncanoResponse_Connections_Get : SyncanoResponse
/**
 Requested list of connection objects
 */
@property (strong) NSArray *connections;
@end

@interface SyncanoResponse_Connections_Get_All : SyncanoResponse
/**
 Requested list of all connection objects
 */
@property (strong) NSArray *connections;
@end

@interface SyncanoResponse_Connections_Update : SyncanoResponse
/**
 Updated connection object
 */
@property (strong) SyncanoConnection *connection;
@end
