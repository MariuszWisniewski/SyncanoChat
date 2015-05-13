//
//  SyncanoProtocolDataObjects.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#ifndef Syncano_SyncanoProtocolDataObjects_h
#define Syncano_SyncanoProtocolDataObjects_h

#import "SyncanoParameters_DataObjects.h"
#import "SyncanoResponse_DataObjects.h"
#import "SyncanoProtocolRequest.h"

/**
 SyncanoProtocolDataObjects is used to transmit information about SyncanoData objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer communicating with Syncano API.
 */
@protocol SyncanoProtocolDataObjects <NSObject>
@required

#pragma mark - Synchronized

///-
/// @name Synchronous requests
///-

/**
 Create new data object
 
 @note User API key usage permitted. Requires create_data permission added through folder.authorize(), collection.authorize() or project.authorize(). user_name field is automatically filled in with current user's info.
 
 @param params Parameters of new data object
 
 @return Response for creation of new data object
 */
- (SyncanoResponse_DataObjects_New *)dataNew:(SyncanoParameters_DataObjects_New *)params;

/**
 Get data object list
 
 @note User API key usage permitted. Returns Data Objects that are in a container with a read_data permission and associated with current user Data Objects that are in a container with a read_own_data permission.
 
 @param params Data object list parameters
 
 @return Response for data object list
 */
- (SyncanoResponse_DataObjects_Get *)dataGet:(SyncanoParameters_DataObjects_Get *)params;

/**
 Get one data object
 
 @note User API key usage permitted. Returns Data Object if it is in a container with a read_data permission or is associated with current user and in a container with a read_own_data permission.
 
 @param params Single data object getter parameters
 
 @return Response for single data object
 */
- (SyncanoResponse_DataObjects_GetOne *)dataGetOne:(SyncanoParameters_DataObjects_GetOne *)params;

/**
 Update existing data object
 
 @note User API key usage permitted. Updates only data that are in a container with an update_data permission (or update_own_data for Data Objects associated with current user).
 
 @param params Update data object parameters
 
 @return Reponse to existing data object update
 */
- (SyncanoResponse_DataObjects_Update *)dataUpdate:(SyncanoParameters_DataObjects_Update *)params;

/**
 Move existing data object
 
 @note User API key usage permitted. Updates only data that are in a container with an update_data permission (or update_own_data for Data Objects associated with current user).
 
 @param params Move data object parameters
 
 @return Reponse to existing data object move
 */
- (SyncanoResponse *)dataMove:(SyncanoParameters_DataObjects_Move *)params;

/**
 Copy existing data object
 
 @note User API key usage permitted. Can copy only data that are in a container with a read_data permission (or read_own_data for Data Objects associated with current user). Target container also needs to have create_data permission.
 
 @param params Copy data object parameters
 
 @return Reponse to existing data object copy
 */
- (SyncanoResponse_DataObjects_Copy *)dataCopy:(SyncanoParameters_DataObjects_Copy *)params;

/**
 Add parent to existing data object
 
 @note User API key usage permitted. Data Object that parent is added to is required to be in a container with an update_data permission or (or update_own_data if it is associated with current user). Also, parent itself is required to be in a container with a (read_data permission or read_own_data if it is associated with current user).
 
 @param params Add parent to data object parameters
 
 @return Reponse to existing data object parent addition
 */
- (SyncanoResponse *)dataAddParent:(SyncanoParameters_DataObjects_AddParent *)params;

/**
 Remove parent to existing data object
 
 @note User API key usage permitted. Data Object that parent is removed from is required to be in a container with an update_data permission or (or update_own_data if it is associated with current user). Also, parent itself is required to be in a container with a (read_data permission or read_own_data if it is associated with current user).
 
 @param params Remove parent to data object parameters
 
 @return Reponse to existing data object parent removal
 */
- (SyncanoResponse *)dataRemoveParent:(SyncanoParameters_DataObjects_RemoveParent *)params;

/**
 Adds additional child to data with specified dataId. If removeOther is True, all other children of specified Data Object will be removed.
 
 @note User API key usage permitted. Data Object that child is added to is required to be in a container with an update_data permission or (or update_own_data if it is associated with current user). Also, child itself is required to be in a container with a (read_data permission or read_own_data if it is associated with current user).
 
 @param params Add child to data object parameters
 
 @return Response for adding child to existing data object
 */
- (SyncanoResponse *)dataAddChild:(SyncanoParameters_DataObjects_AddChild *)params;

/**
 Removes a child (or children) from data with specified dataId.
 
 @note User API key usage permitted. Data Object that child is removed from is required to be in a container with an update_data permission or (or update_own_data if it is associated with current user). Also, child itself is required to be in a container with a (read_data permission or read_own_data if it is associated with current user).
 
 @param params Remove child (or children) from data object parameters.
 
 @return Response for removing child (or children) from existing data object.
 */
- (SyncanoResponse *)dataRemoveChild:(SyncanoParameters_DataObjects_RemoveChild *)params;

/**
 Delete existing data object
 
 @note User API key usage permitted. Deletes only Data Objects that are in a container with a delete_data permission and associated with current user Data Objects that are in a container with delete_own_data permission.
 
 @param params Delete data object parameters
 
 @return Reponse to existing data object deletion
 */
- (SyncanoResponse *)dataDelete:(SyncanoParameters_DataObjects_Delete *)params;

/**
 Count existing data objects
 
 @note User API key usage permitted. Counts only Data Objects that are in a container with a read_data permission and associated with current user Data Objects that are in a container with``read_own_data`` permission.
 
 @param params Count data objects parameters
 
 @return Reponse to existing data object count request
 */
- (SyncanoResponse_DataObjects_Count *)dataCount:(SyncanoParameters_DataObjects_Count *)params;

/**
 Downloads full image linked in imageInfo
 
 @param imageInfo Image information returned by Syncano in data.get() function
 
 @return Full sized image linked in imageInfo
 */
- (UIImage *)downloadImageFull:(SyncanoImage *)imageInfo;

/**
 Downloads image thumbnail linked in imageInfo
 
 @param imageInfo Image information returned by Syncano in data.get() function
 
 @return Thumbnail image linked in imageInfo
 */
- (UIImage *)downloadImageThumbnail:(SyncanoImage *)imageInfo;

/**
 Downloads full image linked in avatarInfo
 
 @param avatarInfo User avatar information returned by Syncano in data.get() function
 
 @return Full sized image linked in avatarInfo
 */
- (UIImage *)downloadAvatarFull:(SyncanoAvatar *)avatarInfo;

/**
 Downloads image thumbnail linked in avatarInfo
 
 @param avatarInfo User avatar information returned by Syncano in data.get() function
 
 @return Thumbnail image linked in avatarInfo
 */
- (UIImage *)downloadAvatarThumbnail:(SyncanoAvatar *)avatarInfo;

#pragma mark - Asynchronized

///-
/// @name Asynchronous requests
///-

/**
 Create new data object
 
 @note User API key usage permitted. Requires create_data permission added through folder.authorize(), collection.authorize() or project.authorize(). user_name field is automatically filled in with current user's info.
 
 @param params Parameters of new data object
 */
- (id <SyncanoRequest> )dataNew:(SyncanoParameters_DataObjects_New *)params callback:(void (^)(SyncanoResponse_DataObjects_New *response))callback;

/**
 Get data object list
 
 @note User API key usage permitted. Returns Data Objects that are in a container with a read_data permission and associated with current user Data Objects that are in a container with a read_own_data permission.
 
 @param params Data object list parameters
 */
- (id <SyncanoRequest> )dataGet:(SyncanoParameters_DataObjects_Get *)params callback:(void (^)(SyncanoResponse_DataObjects_Get *response))callback;

/**
 Get one data object
 
 @note User API key usage permitted. Returns Data Object if it is in a container with a read_data permission or is associated with current user and in a container with a read_own_data permission.
 
 @param params Single data object getter parameters
 */
- (id <SyncanoRequest> )dataGetOne:(SyncanoParameters_DataObjects_GetOne *)params callback:(void (^)(SyncanoResponse_DataObjects_GetOne *response))callback;

/**
 Update existing data object
 
 @note User API key usage permitted. Updates only data that are in a container with an update_data permission (or update_own_data for Data Objects associated with current user).
 
 @param params Update data object parameters
 */
- (id <SyncanoRequest> )dataUpdate:(SyncanoParameters_DataObjects_Update *)params callback:(void (^)(SyncanoResponse_DataObjects_Update *response))callback;

/**
 Move existing data object
 
 @note User API key usage permitted. Updates only data that are in a container with an update_data permission (or update_own_data for Data Objects associated with current user).
 
 @param params Move data object parameters
 */
- (id <SyncanoRequest> )dataMove:(SyncanoParameters_DataObjects_Move *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Copy existing data object
 
 @note User API key usage permitted. Can copy only data that are in a container with a read_data permission (or read_own_data for Data Objects associated with current user). Target container also needs to have create_data permission.
 
 @param params Copy data object parameters
 */
- (id <SyncanoRequest> )dataCopy:(SyncanoParameters_DataObjects_Copy *)params callback:(void (^)(SyncanoResponse_DataObjects_Copy *response))callback;

/**
 Add parent to existing data object
 
 @note User API key usage permitted. Data Object that parent is added to is required to be in a container with an update_data permission or (or update_own_data if it is associated with current user). Also, parent itself is required to be in a container with a (read_data permission or read_own_data if it is associated with current user).
 
 @param params Add parent to data object parameters
 */
- (id <SyncanoRequest> )dataAddParent:(SyncanoParameters_DataObjects_AddParent *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Remove parent to existing data object
 
 @note User API key usage permitted. Data Object that parent is removed from is required to be in a container with an update_data permission or (or update_own_data if it is associated with current user). Also, parent itself is required to be in a container with a (read_data permission or read_own_data if it is associated with current user).
 
 @param params Remove parent to data object parameters
 */
- (id <SyncanoRequest> )dataRemoveParent:(SyncanoParameters_DataObjects_RemoveParent *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Adds additional child to data with specified dataId. If removeOther is True, all other children of specified Data Object will be removed.
 
 @note User API key usage permitted. Data Object that child is added to is required to be in a container with an update_data permission or (or update_own_data if it is associated with current user). Also, child itself is required to be in a container with a (read_data permission or read_own_data if it is associated with current user).
 
 @param params Add child to data object parameters
 @param callback Callback with response for adding child to existing data object
 */
- (id <SyncanoRequest> )dataAddChild:(SyncanoParameters_DataObjects_AddChild *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Removes a child (or children) from data with specified dataId.
 
 @note User API key usage permitted. Data Object that child is removed from is required to be in a container with an update_data permission or (or update_own_data if it is associated with current user). Also, child itself is required to be in a container with a (read_data permission or read_own_data if it is associated with current user).
 
 @param params Remove child (or children) from data object parameters.
 @param callback Callback with response for removing child (or children) from existing data object.
 */
- (id <SyncanoRequest> )dataRemoveChild:(SyncanoParameters_DataObjects_RemoveChild *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Delete existing data object
 
 @note User API key usage permitted. Deletes only Data Objects that are in a container with a delete_data permission and associated with current user Data Objects that are in a container with delete_own_data permission.
 
 @param params Delete data object parameters
 */
- (id <SyncanoRequest> )dataDelete:(SyncanoParameters_DataObjects_Delete *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Count existing data objects
 
 @note User API key usage permitted. Counts only Data Objects that are in a container with a read_data permission and associated with current user Data Objects that are in a container with``read_own_data`` permission.
 
 @param params Count data objects parameters
 */
- (id <SyncanoRequest> )dataCount:(SyncanoParameters_DataObjects_Count *)params callback:(void (^)(SyncanoResponse_DataObjects_Count *response))callback;

/**
 Downloads full image linked in imageInfo
 
 @param imageInfo Image information returned by Syncano in data.get() function
 @param callback  Callback to invoke when image was downloaded from Syncano
 */
- (id <SyncanoRequest> )downloadImageFull:(SyncanoImage *)imageInfo callback:(void (^)(UIImage *image))callback;

/**
 Downloads image thumbnail linked in imageInfo
 
 @param imageInfo Image information returned by Syncano in data.get() function
 @param callback Callback to invoke when image was downloaded from Syncano
 */
- (id <SyncanoRequest> )downloadImageThumbnail:(SyncanoImage *)imageInfo callback:(void (^)(UIImage *image))callback;

/**
 Downloads full image linked in avatarInfo
 
 @param avatarInfo User avatar information returned by Syncano in data.get() function
 @param callback Callback to invoke when image was downloaded from Syncano
 */
- (id <SyncanoRequest> )downloadAvatarFull:(SyncanoAvatar *)avatarInfo callback:(void (^)(UIImage *))callback;

/**
 Downloads image thumbnail linked in avatarInfo
 
 @param avatarInfo User avatar information returned by Syncano in data.get() function
 @param callback Callback to invoke when image was downloaded from Syncano
 */
- (id <SyncanoRequest> )downloadAvatarThumbnail:(SyncanoAvatar *)avatarInfo callback:(void (^)(UIImage *))callback;

@end

#endif
