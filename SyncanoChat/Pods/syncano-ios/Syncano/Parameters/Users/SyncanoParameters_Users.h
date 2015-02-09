//
//  SyncanoParameters_Users.h
//  Syncano
//
//  Created by Syncano Inc. on 07/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters.h"

/**
   Common user parameters
 */
@interface SyncanoParameters_Users : SyncanoParameters
/**
   User ID. Optional for User API key with associated user, otherwise it's mandatory.
 */
@property (strong)    NSString *userId;
/**
   User name. Optional for User API key with associated user, otherwise it's mandatory.
 */
@property (strong)    NSString *userName;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Users *)initWithUserName:(NSString *)userName;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Users *)initWithUserId:(NSString *)userId;
/**
   @return SyncanoParameters
 */
- (SyncanoParameters_Users *)init;

@end

/**
   Logs in a user.
 */
@interface SyncanoParameters_Users_Login : SyncanoParameters
/**
   User name.
 */
@property (strong) NSString *userName;
/**
   User's password.
 */
@property (strong) NSString *password;

- (SyncanoParameters_Users_Login *)initWithUserName:(NSString *)userName password:(NSString *)password;

@end

/**
   Creates a new user.
 */
@interface SyncanoParameters_Users_New : SyncanoParameters
/**
   User name.
 */
@property (strong) NSString *userName;
/**
   User's nick.
 */
@property (strong) NSString *nick;
/**
   User's avatar.
 */
@property (strong) UIImage *avatar;
/**
   User's password.
 */
@property (strong) NSString *password;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Users_New *)initWithUserName:(NSString *)userName;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Users_New *)initWithUserName:(NSString *)userName password:(NSString *)password;

@end

/**
   Gets all users from within instance.

   @note To paginate and to get more data, use since_id or since_time parameter.
 */
@interface SyncanoParameters_Users_GetAll : SyncanoParameters
/**
   If specified, will only return users with id higher than since_id (newer).
 */
@property (strong)    NSString *sinceId;
/**
   Number of users to be returned. Default and max value: 100
 */
@property (strong)    NSNumber *limit;

@end

/**
   Gets users of specified criteria that are associated with Data Objects within specified collection.
 */
@interface SyncanoParameters_Users_Get : SyncanoParameters_ProjectId_CollectionId_CollectionKey

/**
   Returns only users whose Data Objects are in specified state. Possible values: Pending, Moderated, All. Default value: All.
 */
@property (strong)    NSString *state;
/**
   Folder name that data will be returned from. Max 100 values per request. If not present returns data from across all collection folders.
 */
@property (strong)    NSArray *folders;
/**
   Filtering by related Data Object's content. Possible values:

   TEXT - only return users that sent data with text,
   IMAGE - only return users that sent data with an image.
 */
@property (strong, nonatomic)    NSString *filter;

@end

/**
   Get one user.
 */
@interface SyncanoParameters_Users_GetOne : SyncanoParameters_Users

@end

/**
   Updates a specified user.
 */
@interface SyncanoParameters_Users_Update : SyncanoParameters_Users

/**
   User id defining user. If both id and name are specified, will use id for getting user while user_name will be updated with provided new value. userId is automatically filled when used with User API key.
 */
@property (strong) NSString *userId;
/**
   User name defining user. If both id and name are specified, will use id for getting user while user_name will be updated with provided new value. User_id is automatically filled when used with User API key.
 */
@property (strong) NSString *userName;
/**
   New user nick.
 */
@property (strong)  NSString *nick;
/**
   User avatar. If specified as empty string - will instead delete current avatar.
 */
@property (strong)  UIImage *avatar;
/**
   New user password.
 */
@property (strong) NSString *passwordNew;
/**
   Current password for confirmation. Required only when used with User API key.
 */
@property (strong) NSString *passwordCurrent;

/**
   @param currentPassword Current password for confirmation. Required only when used with User API key.

   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Users_Update *)initWithCurrentPassword:(NSString *)currentPassword;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Users_Update *)init;

@end

/**
   Count users of specified criteria.
 */
@interface SyncanoParameters_Users_Count : SyncanoParameters

/**
   Project id (optional). If defined, will only count users that has a Data Object associated within project.
 */
@property (strong)    NSString *project_id;
/**
   Collection id defining collection (optional). If defined, will only count users that has a Data Object associated within collection.
 */
@property (strong)    NSString *collection_id;
/**
   Collection key defining collection (optional). If defined, will only count users that has a Data Object associated within collection.
 */
@property (strong)    NSString *collection_key;
/**
   Return only users whose Data Objects are in specified state. Accepted values: Pending, Moderated, All. Default value: All.
 */
@property (strong)    NSString *state;

/**
   Folder name that data will be returned from. Max 100 values per request. If not present returns data from across all collection folders.
 */
@property (strong)    NSArray *folders;
/**
   Filtering by related Data Object's content. Possible values:

   TEXT - only count users that sent data with text,
   IMAGE - only count users that sent data with an image.
 */
@property (strong, nonatomic)    NSString *filter;

@end

/**
   Deletes (permanently) specified user and all associated data.
 */
@interface SyncanoParameters_Users_Delete : SyncanoParameters_Users

@end
