//
//  SyncanoParameters_Collections.h
//  Syncano
//
//  Created by Syncano Inc. on 03/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters.h"

extern NSString *const kSyncanoParametersCollectionStatusActive;
extern NSString *const kSyncanoParametersCollectionStatusInactive;
extern NSString *const kSyncanoParametersCollectionStatusAll;

/**
   Create a new collection within the specified project.
 */
@interface SyncanoParameters_Collections_New : SyncanoParameters

/**
   Project id that the collection will be created for.
 */
@property (strong)  NSString *projectId;
/**
   New collection's name.
 */
@property (strong)  NSString *name;
/**
   New collection's key.
 */
@property (strong)  NSString *key;
/**
   New collection's description.
 */
@property (strong)  NSString *collectionDescription;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Collections_New *)initWithProjectId:(NSString *)projectId name:(NSString *)name;

@end

/**
   Get collections from a specified project.
 */
@interface SyncanoParameters_Collections_Get : SyncanoParameters
/**
   Project id.
 */
@property (strong)               NSString *projectId;
/**
   Status of events to list. Accepted values: active, inactive, all. Default value: all.
 */
@property (strong, nonatomic)    NSString *status;
/**
   If specified, will only list events that has specified tag(s) defined. Note: tags are case sensitive.
 */
@property (strong)               NSArray *withTags;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Collections_Get *)initWithProjectId:(NSString *)projectId;

@end

/**
   Get one collection from a specified project.
 */
@interface SyncanoParameters_Collections_GetOne : SyncanoParameters_ProjectId_CollectionId_CollectionKey
@end

/**
   Activates specified collection.
 */
@interface SyncanoParameters_Collections_Activate : SyncanoParameters
/**
   Project id
 */
@property (strong)    NSString *projectId;
/**
   ID of collection to be activated
 */
@property (strong)    NSString *collectionId;
/**
   If set to True, will force the activation by deactivating all other collections that may share it's data_key.
 */
@property (strong)    NSNumber *force;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Collections_Activate *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId;

@end

/**
   Deactivates specified collection.
 */
@interface SyncanoParameters_Collections_Deactivate : SyncanoParameters_ProjectId_CollectionId_CollectionKey
@end

/**
   Update existing collection
 */
@interface SyncanoParameters_Collections_Update : SyncanoParameters_ProjectId_CollectionId_CollectionKey
/**
   New collection name.
 */
@property (strong)    NSString *name;
/**
   New collection description.
 */
@property (strong)    NSString *collectionDescription;

@end

/**
   Authorize Collection
 */
@interface SyncanoParameters_Collections_Authorize : SyncanoParameters
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
   Defines project containing specified container.
 */
@property (strong) NSString *projectId;
/**
   Collection id defining collection that permission will be added to.
 */
@property (strong) NSString *collectionId;
/**
   Collection key defining collection that permission will be added to.
 */
@property (strong) NSString *collectionKey;
/**
   Creates parameters to authorize collection.

   @param apiClientId  User API client id.
   @param permission   User API client's permission to add.
   @param projectId    Defines project containing specified container.
   @param collectionId Collection id defining collection that permission will be added to.

   @return Syncano parameters with required fields initialized.
 */
- (SyncanoParameters_Collections_Authorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId collectionId:(NSString *)collectionId;
/**
   Creates parameters to authorize collection.

   @param apiClientId   User API client id.
   @param permission    User API client's permission to add.
   @param projectId     Defines project containing specified container.
   @param collectionKey Collection key defining collection that permission will be added to.

   @return Syncano parameters with required fields initialized.
 */
- (SyncanoParameters_Collections_Authorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId collectionKey:(NSString *)collectionKey;

@end

/**
   Deauthorize collection
 */
@interface SyncanoParameters_Collections_Deauthorize : SyncanoParameters
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
   Defines project containing specified container.
 */
@property (strong) NSString *projectId;
/**
   Collection id defining collection that permission will be added to.
 */
@property (strong) NSString *collectionId;
/**
   Collection key defining collection that permission will be added to.
 */
@property (strong) NSString *collectionKey;
/**
   Creates parameters to deauthorize collection.

   @param apiClientId  User API client id.
   @param permission   User API client's permission to add.
   @param projectId    Defines project containing specified container.
   @param collectionId Collection id defining collection that permission will be added to.

   @return Syncano parameters with required fields initialized.
 */
- (SyncanoParameters_Collections_Deauthorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId collectionId:(NSString *)collectionId;
/**
   Creates parameters to deauthorize collection.

   @param apiClientId   User API client id.
   @param permission    User API client's permission to add.
   @param projectId     Defines project containing specified container.
   @param collectionKey Collection key defining collection that permission will be added to.

   @return Syncano parameters with required fields initialized.
 */
- (SyncanoParameters_Collections_Deauthorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId collectionKey:(NSString *)collectionKey;

@end

/**
   Permanently delete a specified collection and all associated data.
 */
@interface SyncanoParameters_Collections_Delete : SyncanoParameters_ProjectId_CollectionId_CollectionKey
@end

/**
   Add a tag to specific event.

   @note tags are case sensitive.
 */
@interface SyncanoParameters_Collections_AddTag : SyncanoParameters

/**
   Project id.
 */
@property (strong)    NSString *projectId;
/**
   Event codeword or ID.
 */
@property (strong)    NSString *collectionId;
/**
   Event codeword or ID.
 */
@property (strong)    NSString *collectionKey;
/**
   Tag(s) to be added.
 */
@property (strong)    NSArray *tags;
/**
   Tag(s) weight. Default value: 1. remove_other (optional)
 */
@property (strong)    NSNumber *weight;

@property (strong)    NSNumber *removeOther;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Collections_AddTag *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId tags:(NSArray *)tags;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Collections_AddTag *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey tags:(NSArray *)tags;

@end

/**
   Delete a tag or tags from specified collection.

   @note tags are case sensitive.
 */
@interface SyncanoParameters_Collections_DeleteTag : SyncanoParameters
/**
   Project id.
 */
@property (strong)    NSString *projectId;
/**
   Collection id or key defining collection.
 */
@property (strong)    NSString *collectionId;
/**
   Collection id or key defining collection.

 */
@property (strong)    NSString *collectionKey;
/**
   Tag(s) to be deleted.
 */
@property (strong)    NSArray *tags;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Collections_DeleteTag *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId tags:(NSArray *)tags;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Collections_DeleteTag *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey tags:(NSArray *)tags;

@end
