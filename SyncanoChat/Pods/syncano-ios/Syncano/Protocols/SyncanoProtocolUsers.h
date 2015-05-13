//
//  SyncanoProtocolUsers.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#ifndef Syncano_SyncanoProtocolUsers_h
#define Syncano_SyncanoProtocolUsers_h

#import "SyncanoParameters_Users.h"
#import "SyncanoResponse_Users.h"
#import "SyncanoProtocolRequest.h"

/**
 SyncanoProtocolUsers is used to transmit information about SyncanoUser objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer communicating with Syncano API.
 */
@protocol SyncanoProtocolUsers <NSObject>
@required

#pragma mark - Synchronized

///-
/// @name Synchronous requests
///-

/**
 Logs in a user.
 
 @note This method is intended for User API key usage.
 
 @param params User login parameters.
 
 @return Response for logging in user.
 */
- (SyncanoResponse_Users_Login *)userLogin:(SyncanoParameters_Users_Login *)params;

/**
 Create new user
 
 @param params Parameters of new user
 
 @return Response for creation of new user
 */
- (SyncanoResponse_Users_New *)userNew:(SyncanoParameters_Users_New *)params;

/**
 Get all users list
 
 @param params User list parameters
 
 @return Response for user list
 */
- (SyncanoResponse_Users_GetAll *)userGetAll:(SyncanoParameters_Users_GetAll *)params;

/**
 Get user list
 
 @param params user list parameters
 
 @return Response for user list
 */
- (SyncanoResponse_Users_Get *)userGet:(SyncanoParameters_Users_Get *)params;

/**
 Get one user
 
 @param params Single user getter parameters
 
 @return Response for single user
 */
- (SyncanoResponse_Users_GetOne *)userGetOne:(SyncanoParameters_Users_GetOne *)params;

/**
 Update existing user
 
 @param params Update user parameters
 
 @return Reponse to existing user update
 */
- (SyncanoResponse_Users_Update *)userUpdate:(SyncanoParameters_Users_Update *)params;

/**
 Count existing users
 
 @param params Count users parameters
 
 @return Reponse to existing user count request
 */
- (SyncanoResponse_Users_Count *)userCount:(SyncanoParameters_Users_Count *)params;

/**
 Delete existing user
 
 @param params Delete user parameters
 
 @return Reponse to existing user deletion
 */
- (SyncanoResponse *)userDelete:(SyncanoParameters_Users_Delete *)params;

#pragma mark - Asynchronized

///-
/// @name Asynchronous requests
///-

/**
 Logs in a user.
 
 @note This method is intended for User API key usage.
 
 @param params User login parameters.
 @param callback Callback response for logging in user.
 */
- (id <SyncanoRequest> )userLogin:(SyncanoParameters_Users_Login *)params callback:(void (^)(SyncanoResponse_Users_Login *response))callback;

/**
 Create new user
 
 @param params Parameters of new user
 */
- (id <SyncanoRequest> )userNew:(SyncanoParameters_Users_New *)params callback:(void (^)(SyncanoResponse_Users_New *response))callback;

/**
 Get all users list
 
 @param params User list parameters
 */
- (id <SyncanoRequest> )userGetAll:(SyncanoParameters_Users_GetAll *)params callback:(void (^)(SyncanoResponse_Users_GetAll *response))callback;

/**
 Get user list
 
 @param params user list parameters
 */
- (id <SyncanoRequest> )userGet:(SyncanoParameters_Users_Get *)params callback:(void (^)(SyncanoResponse_Users_Get *response))callback;

/**
 Get one user
 
 @param params Single user getter parameters
 */
- (id <SyncanoRequest> )userGetOne:(SyncanoParameters_Users_GetOne *)params callback:(void (^)(SyncanoResponse_Users_GetOne *response))callback;

/**
 Update existing user
 
 @param params Update user parameters
 */
- (id <SyncanoRequest> )userUpdate:(SyncanoParameters_Users_Update *)params callback:(void (^)(SyncanoResponse_Users_Update *response))callback;

/**
 Count existing users
 
 @param params Count users parameters
 */
- (id <SyncanoRequest> )userCount:(SyncanoParameters_Users_Count *)params callback:(void (^)(SyncanoResponse_Users_Count *response))callback;

/**
 Delete existing user
 
 @param params Delete user parameters
 */
- (id <SyncanoRequest> )userDelete:(SyncanoParameters_Users_Delete *)params callback:(void (^)(SyncanoResponse *response))callback;

@end

#endif
