//
//  SyncanoParameters_Projects.h
//  Syncano
//
//  Created by Syncano Inc. on 03/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters.h"

/**
   Create a new project params
 */
@interface SyncanoParameters_Projects_New : SyncanoParameters
/**
   New project's name.
 */
@property (strong)  NSString *name;
/**
   New project's description
 */
@property (strong)  NSString *projectDescription;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Projects_New *)initWithName:(NSString *)name;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Projects_New *)initWithName:(NSString *)name description:(NSString *)description;

@end

/**
   Get projects.
 */
@interface SyncanoParameters_Projects_Get : SyncanoParameters
@end

/**
   Get one project
 */
@interface SyncanoParameters_Projects_GetOne : SyncanoParameters
/**
   Project ID
 */
@property (strong)    NSString *projectId;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Projects_GetOne *)initWithProjectId:(NSString *)projectId;

@end

/**
   Update existing project
 */
@interface SyncanoParameters_Projects_Update : SyncanoParameters
/**
   Existing project's id.
 */
@property (strong)  NSString *projectId;
/**
   New name of specified project.
 */
@property (strong)  NSString *name;
/**
   New description of specified project.
 */
@property (strong)  NSString *projectDescription;
/**
   Created parameters to update selected project.

   @param projectId Existing project's id.

   @return Syncano parameters with required fields initialized.
 */
- (SyncanoParameters_Projects_Update *)initWithProjectId:(NSString *)projectId;

@end

@interface SyncanoParameters_Projects_Authorize : SyncanoParameters
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
   Project id defining project that permission will be added to.
 */
@property (strong) NSString *projectId;
/**
   Creates parameters to add project-level permission to specified User API client. Requires Backend API key with Admin permission role.

   @param apiClientId   User API client id.
   @param permission User API client's permission to add.
   @param projectId  Project id defining project that permission will be added to.

   @return Syncano parameters with required fields initialized.
 */
- (SyncanoParameters_Projects_Authorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId;
@end

@interface SyncanoParameters_Projects_Deauthorize : SyncanoParameters
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
   Project id defining project that permission will be removed from.
 */
@property (strong) NSString *projectId;
/**
   Creates parameters to removes project-level permission from specified User API client. Requires Backend API key with Admin permission role.

   @param apiClientId   User API client id.
   @param permission User API client's permission to remove.
   @param projectId  Project id defining project that permission will be removed from.

   @return Syncano parameters with required fields initialized.
 */
- (SyncanoParameters_Projects_Deauthorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId;
@end

/**
   Delete (permanently) project with specified project_id.
 */
@interface SyncanoParameters_Projects_Delete : SyncanoParameters
/**
   Project id defining project to be deleted.
 */
@property (strong)    NSString *projectId;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Projects_Delete *)initWithProjectId:(NSString *)projectId;

@end
