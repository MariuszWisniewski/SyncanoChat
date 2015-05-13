//
//  SyncanoProtocolConnections.h
//  Syncano
//
//  Created by Syncano Inc. on 13/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_Connections.h"
#import "SyncanoResponse_Connections.h"
#import "SyncanoProtocolRequest.h"

/**
 SyncanoProtocolConnections is used to transmit information about SyncanoConnection objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer communicating with Syncano API.
 @note This protocol defines only asynchronous methods, it is to be used only with SyncanoSyncServer
 */
@protocol SyncanoProtocolConnections <NSObject>
@required

#pragma mark - Synchronized

//Not present, to be used only with SyncServer

#pragma mark - Asynchronized

///-
/// @name Asynchronous requests
///-

/**
 Get currently connected API client connections up to a limit (max 100).
 
 @param params Connection list parameters
 */
- (void)connectionGet:(SyncanoParameters_Connections_Get *)params callback:(void (^)(SyncanoResponse_Connections_Get *response))callback;

/**
 Get all connections from current instance up to a limit (max 100).
 
 @param params Connection list parameters
 */
- (void)connectionGetAll:(SyncanoParameters_Connections_Get_All *)params callback:(void (^)(SyncanoResponse_Connections_Get_All *response))callback;

/**
 Updates specified API client connection info.
 
 @param params Update connection parameters
 */
- (void)connectionUpdate:(SyncanoParameters_Connections_Update *)params callback:(void (^)(SyncanoResponse_Connections_Update *response))callback;

@end
