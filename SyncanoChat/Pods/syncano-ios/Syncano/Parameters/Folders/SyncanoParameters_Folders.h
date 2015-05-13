//
//  SyncanoParameters_Folders.h
//  Syncano
//
//  Created by Syncano Inc. on 07/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters.h"

/**
   Common folder parameters
 */
@interface SyncanoParameters_Folders_Name : SyncanoParameters

/**
   Project id.
 */
@property (strong)    NSString *projectId;
/**
   Collection id or key defining collection where folder will be created.
 */
@property (strong)    NSString *collectionId;
/**
   Collection id or key defining collection where folder will be created.
 */
@property (strong)    NSString *collectionKey;
/**
   Folder name
 */
@property (strong)    NSString *name;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Folders_Name *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId name:(NSString *)name;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Folders_Name *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey name:(NSString *)name;

@end

/**
   Create new folder within a specified collection.
 */
@interface SyncanoParameters_Folders_New : SyncanoParameters_Folders_Name

@end

/**
   Get folders for a specified collection.
 */
@interface SyncanoParameters_Folders_Get : SyncanoParameters_ProjectId_CollectionId_CollectionKey

@end

/**
   Get single folder for a specified collection
 */
@interface SyncanoParameters_Folders_GetOne : SyncanoParameters
/**
   Project id.
 */
@property (strong)    NSString *projectId;
/**
   Collection id or key defining a collection for which the folder will be returned.
 */
@property (strong)    NSString *collectionId;
/**
   Collection id or key defining a collection for which the folder will be returned.
 */
@property (strong)    NSString *collectionKey;
/**
   Folder name defining folder.
 */
@property (strong)    NSString *folderName;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Folders_GetOne *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId folderName:(NSString *)folderName;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Folders_GetOne *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey folderName:(NSString *)folderName;

@end

/**
   Update existing folder
 */
@interface SyncanoParameters_Folders_Update : SyncanoParameters_Folders_Name
/**
   New folder name.
 */
@property (strong) NSString *updatedName;
/**
   New source id, can be used for mapping folders to external source.
 */
@property (strong) NSString *sourceId;

@end

/**
   Authorizes existing folder.
 */
@interface SyncanoParameters_Folders_Authorize : SyncanoParameters
/**
   User API client id.
 */
@property (strong) NSString *apiClientId;
/**
   User API client's permission to add. Possible values:
   create_data - can create new Data Objects within container,
   read_data - can read all Data Objects within container,
   read_own_data - can read only Data Objects within container that were created by associated user,
   update_data - can update all Data Objects within container,
   update_own_data - can update only Data Objects within container that were created by associated user,
   delete_data - can delete all Data Objects within container,
   delete_own_data - can delete only Data Objects within container that were created by associated user
 */
@property (strong) NSString *permission;
/**
   Project containing specified container.
 */
@property (strong) NSString *projectId;
/**
   Id of collection containing specified folder.
 */
@property (strong) NSString *collectionId;
/**
   Key of collection containing specified folder.
 */
@property (strong) NSString *collectionKey;
/**
   Folder name defining folder that permission will be added to.
 */
@property (strong) NSString *folderName;
/**
   Creates parameters to authorize folder

   @param apiClientId  User API client id.
   @param permission   User API client's permission to add.
   @param projectId    Project containing specified container.
   @param collectionId Id of collection containing specified folder.
   @param folderName   Folder name defining folder that permission will be added to.

   @return Syncano parameters with required fields initialized.
 */
- (SyncanoParameters_Folders_Authorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId collectionId:(NSString *)collectionId folderName:(NSString *)folderName;

/**
   Creates parameters to authorize folder

   @param apiClientId   User API client id.
   @param permission    User API client's permission to add.
   @param projectId     Project containing specified container.
   @param collectionKey Key of collection containing specified folder.
   @param folderName    Folder name defining folder that permission will be added to.

   @return Syncano parameters with required fields initialized.
 */
- (SyncanoParameters_Folders_Authorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId collectionKey:(NSString *)collectionKey folderName:(NSString *)folderName;
@end

/**
   Deauthorizes existing folder.
 */
@interface SyncanoParameters_Folders_Deauthorize : SyncanoParameters
/**
   User API client id.
 */
@property (strong) NSString *apiClientId;
/**
   User API client's permission to remove. Possible values:
   create_data - can create new Data Objects within container,
   read_data - can read all Data Objects within container,
   read_own_data - can read only Data Objects within container that were created by associated user,
   update_data - can update all Data Objects within container,
   update_own_data - can update only Data Objects within container that were created by associated user,
   delete_data - can delete all Data Objects within container,
   delete_own_data - can delete only Data Objects within container that were created by associated user
 */
@property (strong) NSString *permission;
/**
   Project containing specified container.
 */
@property (strong) NSString *projectId;
/**
   Id of collection containing specified folder.
 */
@property (strong) NSString *collectionId;
/**
   Key of collection containing specified folder.
 */
@property (strong) NSString *collectionKey;
/**
   Folder name defining folder that permission will be removed from.
 */
@property (strong) NSString *folderName;
/**
   Creates parameters to deauthorize folder

   @param apiClientId  User API client id.
   @param permission   User API client's permission to remove.
   @param projectId    Project containing specified container.
   @param collectionId Id of collection containing specified folder.
   @param folderName   Folder name defining folder that permission will be removed from.

   @return Syncano parameters with required fields initialized.
 */
- (SyncanoParameters_Folders_Deauthorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId collectionId:(NSString *)collectionId folderName:(NSString *)folderName;

/**
   Creates parameters to deauthorize folder

   @param apiClientId   User API client id.
   @param permission    User API client's permission to remove.
   @param projectId     Project containing specified container.
   @param collectionKey Key of collection containing specified folder.
   @param folderName    Folder name defining folder that permission will be removed from.

   @return Syncano parameters with required fields initialized.
 */
- (SyncanoParameters_Folders_Deauthorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId collectionKey:(NSString *)collectionKey folderName:(NSString *)folderName;
@end

/**
   Permanently delete specified folder and all associated data.
 */
@interface SyncanoParameters_Folders_Delete : SyncanoParameters_Folders_Name
@end
