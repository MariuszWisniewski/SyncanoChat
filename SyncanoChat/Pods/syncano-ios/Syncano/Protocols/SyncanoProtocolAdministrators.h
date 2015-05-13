//
//  SyncanoProtocolAdministrators.h
//  Syncano
//
//  Created by Syncano Inc. on 13/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_Administrators.h"
#import "SyncanoResponse_Administrators.h"
#import "SyncanoProtocolRequest.h"

/**
 SyncanoProtocolAdministrators is used to transmit information about SyncanoAdmin objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer communicating with Syncano API.
 */
@protocol SyncanoProtocolAdministrators <NSObject>
@required

#pragma mark - Synchronized

///-
/// @name Synchronous requests
///-

/**
 Create new administrator
 
 @param params Parameters of new administrator
 
 @return Response for creation of new administrator
 */
- (SyncanoResponse *)adminNew:(SyncanoParameters_Administrators_New *)params;
/**
 Get administrator list
 
 @param params Administrator list parameters
 
 @return Response for administrator list
 */
- (SyncanoResponse_Administrators_Get *)adminGet:(SyncanoParameters_Administrators_Get *)params;
/**
 Get one administrator
 
 @param params Single administrator getter parameters
 
 @return Response for single administrator
 */
- (SyncanoResponse_Administrators_GetOne *)adminGetOne:(SyncanoParameters_Administrators_GetOne *)params;
/**
 Update existing administrator
 
 @param params Update administrator parameters
 
 @return Reponse to existing administrator update
 */
- (SyncanoResponse_Administrators_Update *)adminUpdate:(SyncanoParameters_Administrators_Update *)params;
/**
 Delete existing administrator
 
 @param params Delete administrator parameters
 
 @return Reponse to existing administrator deletion
 */
- (SyncanoResponse *)adminDelete:(SyncanoParameters_Administrators_Delete *)params;

#pragma mark - Asynchronized

///-
/// @name Asynchronous requests
///-

/**
 Create new administrator
 
 @param params Parameters of new administrator
 */
- (id <SyncanoRequest> )adminNew:(SyncanoParameters_Administrators_New *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Get administrator list
 
 @param params administrator list parameters
 */
- (id <SyncanoRequest> )adminGet:(SyncanoParameters_Administrators_Get *)params callback:(void (^)(SyncanoResponse_Administrators_Get *response))callback;

/**
 Get one administrator
 
 @param params Single administrator getter parameters
 */
- (id <SyncanoRequest> )adminGetOne:(SyncanoParameters_Administrators_GetOne *)params callback:(void (^)(SyncanoResponse_Administrators_GetOne *response))callback;

/**
 Update existing administrator
 
 @param params Update administrator parameters
 */
- (id <SyncanoRequest> )adminUpdate:(SyncanoParameters_Administrators_Update *)params callback:(void (^)(SyncanoResponse_Administrators_Update *response))callback;

/**
 Delete existing administrator
 
 @param params Delete administrator parameters
 */
- (id <SyncanoRequest> )adminDelete:(SyncanoParameters_Administrators_Delete *)params callback:(void (^)(SyncanoResponse *response))callback;

@end
