//
//  SyncanoResponse_Users.h
//  Syncano
//
//  Created by Syncano Inc. on 09/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse.h"
#import "SyncanoObjects.h"

@interface SyncanoResponse_Users_Login : SyncanoResponse
/**
   User authorization key.
 */
@property (strong) NSString *authKey;

@end

@interface SyncanoResponse_Users_New : SyncanoResponse
/**
   Newly created user
 */
@property (strong)    SyncanoUser *user;
@end

@interface SyncanoResponse_Users_GetAll : SyncanoResponse
/**
   Requested list of all users
 */
@property (strong)    NSArray *user;
@end

@interface SyncanoResponse_Users_Get : SyncanoResponse
/**
   Requested list of users
 */
@property (strong)    NSArray *user;
@end

@interface SyncanoResponse_Users_GetOne : SyncanoResponse
/**
   Requested user
 */
@property (strong)    SyncanoUser *user;
@end

@interface SyncanoResponse_Users_Update : SyncanoResponse
/**
   Updated user
 */
@property (strong)    SyncanoUser *user;
@end

@interface SyncanoResponse_Users_Count : SyncanoResponse
/**
   Count of users
 */
@property (strong)    NSNumber *count;
@end
