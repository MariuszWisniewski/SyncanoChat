//
//  SyncanoProtocolFolders.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#ifndef Syncano_SyncanoProtocolFolders_h
#define Syncano_SyncanoProtocolFolders_h

#import "SyncanoParameters_Folders.h"
#import "SyncanoResponse_Folders.h"
#import "SyncanoProtocolRequest.h"

/**
 SyncanoProtocolFolders is used to transmit information about SyncanoFolder objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer communicating with Syncano API.
 */
@protocol SyncanoProtocolFolders <NSObject>
@required

#pragma mark - Synchronized

/**
 Create new folder
 
 @param params Parameters of new folder
 
 @return Response for creation of new folder
 */
- (SyncanoResponse_Folders_New *)folderNew:(SyncanoParameters_Folders_New *)params;

/**
 Get folder list
 
 @note User API key usage permitted. Returns only collections that have``read_data`` permission added through folder.authorize(), collection.authorize() or project.authorize().
 
 @param params Folder list parameters
 
 @return Response for listing folders
 */
- (SyncanoResponse_Folders_Get *)folderGet:(SyncanoParameters_Folders_Get *)params;

/**
 Get one folder
 
 @note User API key usage permitted if read_data permission is added to specified folder through folder.authorize(), collection.authorize() or project.authorize().
 
 @param params Single folder getter parameters
 
 @return Response for getting one folder
 */
- (SyncanoResponse_Folders_GetOne *)folderGetOne:(SyncanoParameters_Folders_GetOne *)params;

/**
 Update existing folder
 
 @param params Update folder parameters
 
 @return Response for updating folder
 */
- (SyncanoResponse *)folderUpdate:(SyncanoParameters_Folders_Update *)params;

/**
 Adds folder-level permission to specified User API client. Requires Backend API key with Admin permission role.
 
 @param params Authorize folder paramaters.
 
 @return Response for authorizing folder.
 */
- (SyncanoResponse *)folderAuthorize:(SyncanoParameters_Folders_Authorize *)params;

/**
 Removes folder-level permission from specified User API client. Requires Backend API key with Admin permission role.
 
 @param params Deauthorize folder paramaters.
 
 @return Response for deauthorizing folder.
 */
- (SyncanoResponse *)folderDeauthorize:(SyncanoParameters_Folders_Deauthorize *)params;

/**
 Delete existing folder
 
 @param params Delete folder parameters
 
 @return Response for deleting folder
 */
- (SyncanoResponse *)folderDelete:(SyncanoParameters_Folders_Delete *)params;

#pragma mark - Asynchronized

///-
/// @name Synchronous requests
///-

/**
 Create new folder
 
 @param params Parameters of new folder
 */
- (id <SyncanoRequest> )folderNew:(SyncanoParameters_Folders_New *)params callback:(void (^)(SyncanoResponse_Folders_New *response))callback;

/**
 Get folder list
 
 @note User API key usage permitted. Returns only collections that have``read_data`` permission added through folder.authorize(), collection.authorize() or project.authorize().
 
 @param params Folder list parameters
 */
- (id <SyncanoRequest> )folderGet:(SyncanoParameters_Folders_Get *)params callback:(void (^)(SyncanoResponse_Folders_Get *response))callback;

/**
 Get one folder
 
 @note User API key usage permitted if read_data permission is added to specified folder through folder.authorize(), collection.authorize() or project.authorize().
 
 @param params Single folder getter parameters
 */
- (id <SyncanoRequest> )folderGetOne:(SyncanoParameters_Folders_GetOne *)params callback:(void (^)(SyncanoResponse_Folders_GetOne *response))callback;

/**
 Update existing folder
 
 @param params Update folder parameters
 */
- (id <SyncanoRequest> )folderUpdate:(SyncanoParameters_Folders_Update *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Adds folder-level permission to specified User API client. Requires Backend API key with Admin permission role.
 
 @param params Authorize folder paramaters.
 @param callback Callback with response for authorizing folder.
 */
- (id <SyncanoRequest> )folderAuthorize:(SyncanoParameters_Folders_Authorize *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Removes folder-level permission from specified User API client. Requires Backend API key with Admin permission role.
 
 @param params Deauthorize folder paramaters.
 @param callback Callback with response for deauthorizing folder.
 */
- (id <SyncanoRequest> )folderDeauthorize:(SyncanoParameters_Folders_Deauthorize *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Delete existing folder
 
 @param params Delete folder parameters
 */
- (id <SyncanoRequest> )folderDelete:(SyncanoParameters_Folders_Delete *)params callback:(void (^)(SyncanoResponse *response))callback;

@end

#endif
