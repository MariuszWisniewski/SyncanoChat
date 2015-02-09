//
//  SyncanoProtocolProjects.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#ifndef Syncano_SyncanoProtocolProjects_h
#define Syncano_SyncanoProtocolProjects_h

#import "SyncanoParameters_Projects.h"
#import "SyncanoResponse_Projects.h"
#import "SyncanoProtocolRequest.h"

/**
 SyncanoProtocolProjects is used to transmit information about SyncanoProject objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer) communicating with Syncano API.
 */
@protocol SyncanoProtocolProjects <NSObject>
@required

#pragma mark - Synchronized

///-
/// @name Synchronous requests
///-

/**
 Create new project
 
 @param params Parameters of new project
 
 @return Response for creation of new project
 */
- (SyncanoResponse_Projects_New *)projectNew:(SyncanoParameters_Projects_New *)params;

/**
 Get project list
 
 @note User API key usage permitted. Returns only projects that have``read_data`` permission added through project.authorize().
 
 @param params Project list parameters
 
 @return Response for project list
 */
- (SyncanoResponse_Projects_Get *)projectGet:(SyncanoParameters_Projects_Get *)params;

/**
 Get one project
 
 @note User API key usage permitted if read_data permission is added to specified folder through project.authorize().
 
 @param params Single project getter parameters
 
 @return Response for single project
 */
- (SyncanoResponse_Projects_GetOne *)projectGetOne:(SyncanoParameters_Projects_GetOne *)params;

/**
 Update existing project
 
 @param params Update project parameters
 
 @return Reponse to existing project update
 */
- (SyncanoResponse_Projects_Update *)projectUpdate:(SyncanoParameters_Projects_Update *)params;

/**
 Adds project-level permission to specified User API client. Requires Backend API key with Admin permission role.
 
 @param params Project authorize parameters.
 
 @return Response to authorizing project.
 */
- (SyncanoResponse *)projectAuthorize:(SyncanoParameters_Projects_Authorize *)params;

/**
 Removes project-level permission from specified User API client. Requires Backend API key with Admin permission role.
 
 @param params Project deauthorize parameters.
 
 @return Response to deauthorizing project.
 */
- (SyncanoResponse *)projectDeauthorize:(SyncanoParameters_Projects_Deauthorize *)params;

/**
 Delete existing project
 
 @param params Delete project parameters
 
 @return Reponse to existing project deletion
 */
- (SyncanoResponse *)projectDelete:(SyncanoParameters_Projects_Delete *)params;

#pragma mark - Asynchronized

///-
/// @name Asynchronous requests
///-

/**
 Create new project
 
 @param params Parameters of new project
 */
- (id <SyncanoRequest> )projectNew:(SyncanoParameters_Projects_New *)params callback:(void (^)(SyncanoResponse_Projects_New *response))callback;

/**
 Get project list
 
 @note User API key usage permitted. Returns only projects that have``read_data`` permission added through project.authorize().
 
 @param params Project list parameters
 */
- (id <SyncanoRequest> )projectGet:(SyncanoParameters_Projects_Get *)params callback:(void (^)(SyncanoResponse_Projects_Get *response))callback;

/**
 Get one project
 
 @note User API key usage permitted if read_data permission is added to specified folder through project.authorize().
 
 @param params Single project getter parameters
 */
- (id <SyncanoRequest> )projectGetOne:(SyncanoParameters_Projects_GetOne *)params callback:(void (^)(SyncanoResponse_Projects_GetOne *response))callback;

/**
 Update existing project
 
 @param params Update project parameters
 */
- (id <SyncanoRequest> )projectUpdate:(SyncanoParameters_Projects_Update *)params callback:(void (^)(SyncanoResponse_Projects_Update *response))callback;

/**
 Adds project-level permission to specified User API client. Requires Backend API key with Admin permission role.
 
 @param params Project authorize parameters.
 @param callback Callback with response to authorizing project.
 */
- (id <SyncanoRequest> )projectAuthorize:(SyncanoParameters_Projects_Authorize *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Removes project-level permission from specified User API client. Requires Backend API key with Admin permission role.
 
 @param params Project deauthorize parameters.
 @param callback Callback with response to deauthorizing project.
 */
- (id <SyncanoRequest> )projectDeauthorize:(SyncanoParameters_Projects_Deauthorize *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Delete existing project
 
 @param params Delete project parameters
 */
- (id <SyncanoRequest> )projectDelete:(SyncanoParameters_Projects_Delete *)params callback:(void (^)(SyncanoResponse *response))callback;

@end

#endif
