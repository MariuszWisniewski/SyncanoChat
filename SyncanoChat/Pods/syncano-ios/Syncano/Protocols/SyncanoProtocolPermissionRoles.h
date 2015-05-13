//
//  SyncanoProtocolPermissionRoles.h
//  Syncano
//
//  Created by Syncano Inc. on 12/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_PermissionRoles.h"
#import "SyncanoResponse_PermissionRoles.h"
#import "SyncanoProtocolRequest.h"

/**
 SyncanoProtocolPermissionRoles is used to transmit information about SyncanoRole objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer) communicating with Syncano API.
 */
@protocol SyncanoProtocolPermissionRoles <NSObject>
@required

#pragma mark - Synchronized

///-
/// @name Synchronous requests
///-

/**
 List of permission roles
 
 @param params Parameters for role list request
 
 @return Reponse to role list request
 */
- (SyncanoResponse_PermissionRoles_Get *)roleGet:(SyncanoParameters_PermissionRoles_Get *)params;

#pragma mark - Asynchronized

///-
/// @name Asynchronous requests
///-

/**
 List of permission roles
 
 @param params Parameters for role list request
 */
- (id <SyncanoRequest> )roleGet:(SyncanoParameters_PermissionRoles_Get *)params callback:(void (^)(SyncanoResponse_PermissionRoles_Get *response))callback;
@end
