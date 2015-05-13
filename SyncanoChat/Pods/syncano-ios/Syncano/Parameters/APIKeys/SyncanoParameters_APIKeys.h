//
//  SyncanoParameters_APIKeys.h
//  Syncano
//
//  Created by Syncano Inc. on 12/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters.h"

extern NSString *const kSyncanoParametersAPIKeyTypeBackend;
extern NSString *const kSyncanoParametersAPIKeyTypeUser;

/**
   Parameters for starting session
 */
@interface SyncanoParameters_APIKeys_StartSession : SyncanoParameters
@end

/**
   Parameters for creating new APIKey
 */
@interface SyncanoParameters_APIKeys_New : SyncanoParameters
/**
   New API client's permission role id (see role.get()). Not used when creating User API key (type = user)
 */
@property (strong) NSString *roleId;
/**
   Description of new API client.
 */
@property (strong) NSString *apiKeyDescription;
/**
   Type of new API client. Possible values:
   backend (default) - API key that is not user-aware and has global permissions,
   user - user-aware API key that can define per container permissions.
 */
@property (strong) NSString *type;

/**
   Creates parameters object with required fields initialized

   @param type Type of new API client.
   @param description Description of new API client.

   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_APIKeys_New *)initWithType:(NSString *)type description:(NSString *)description;

@end

/**
   Parameters for getting API keys list
 */
@interface SyncanoParameters_APIKeys_Get : SyncanoParameters
@end

/**
   Parameters for getting one API key
 */
@interface SyncanoParameters_APIKeys_GetOne : SyncanoParameters
/// API client id. If not specified, will use current client.
@property (strong) NSString *apiClientId; //optional
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_APIKeys_GetOne *)initWithApiClientId:(NSString *)apiClientId;

@end

/**
   Parameters for updating API key description
 */
@interface SyncanoParameters_APIKeys_UpdateDescription : SyncanoParameters
@property (strong) NSString *apiKeyDescription;
// API client id. If not specified, will update current client.
@property (strong) NSString *apiClientId;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_APIKeys_UpdateDescription *)initWithDescription:(NSString *)description;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_APIKeys_UpdateDescription *)initWithDescription:(NSString *)description apiClientId:(NSString *)apiClientId;

@end

/**
   Parameters for authorizing API Keys
 */
@interface SyncanoParameters_APIKeys_Authorize : SyncanoParameters
/**
   User API client id.
 */
@property (strong) NSString *apiClientId;
/**
   User API client's permission to add. Possible values:
   send_notification - can send notifications through notification.send(),
   add_user - can create new users through user.new(),
   access_sync - can access Sync Server,
   subscribe - can subscribe to data through Sync Server
 */
@property (strong) NSString *permission;
/**
   Creates parameters to authorize API Key

   @param apiClientId   User API client id.
   @param permission User API client's permission to add.

   @return Syncano parameters with required fields initialized
 */
- (SyncanoParameters_APIKeys_Authorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission;
@end

/**
   Parameters for deauthorizing API Keys.
 */
@interface SyncanoParameters_APIKeys_Deauthorize : SyncanoParameters
/**
   User API client id.
 */
@property (strong) NSString *apiClientId;
/**
   User API client's permission to remove. Possible values:
   send_notification - can send notifications through notification.send(),
   add_user - can create new users through user.new(),
   access_sync - can access Sync Server,
   subscribe - can subscribe to data through Sync Server
 */
@property (strong) NSString *permission;
/**
   Creates parameters to deauthorize API Key.

   @param apiClientId   User API client id.
   @param permission User API client's permission to remove.

   @return Syncano parameters with required fields initialized.
 */
- (SyncanoParameters_APIKeys_Deauthorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission;
@end

/**
   Parameters for API key deletion
 */
@interface SyncanoParameters_APIKeys_Delete : SyncanoParameters
@property (strong) NSString *apiClientId;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_APIKeys_Delete *)initWithApiClientId:(NSString *)apiClientId;

@end
