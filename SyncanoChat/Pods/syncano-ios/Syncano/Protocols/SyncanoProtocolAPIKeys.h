//
//  SyncanoProtocolAPIKeys.h
//  Syncano
//
//  Created by Syncano Inc. on 13/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_APIKeys.h"
#import "SyncanoResponse_APIKeys.h"
#import "SyncanoProtocolRequest.h"

/**
 SyncanoProtocolAPIKeys is used to transmit information about SyncanoClient objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer communicating with Syncano API.
 */
@protocol SyncanoProtocolAPIKeys <NSObject>
@required

#pragma mark - Synchronized

///-
/// @name Synchronous requests
///-

/**
 Start session for API key
 
 @param params Parameters for starting API key
 
 @return Response for starting API key
 */
- (SyncanoResponse_APIKeys_StartSession *)apiKeyStartSession:(SyncanoParameters_APIKeys_StartSession *)params;

/**
 Create new API key
 
 @param params Parameters of new API key
 
 @return Response for creation of new API key
 */
- (SyncanoResponse_APIKeys_New *)apiKeyNew:(SyncanoParameters_APIKeys_New *)params;

/**
 Get API key list
 
 @param params API key list parameters
 
 @return Response for API key list
 */
- (SyncanoResponse_APIKeys_Get *)apiKeyGet:(SyncanoParameters_APIKeys_Get *)params;

/**
 Get one API key
 
 @param params Single API key getter parameters
 
 @return Response for single API key
 */
- (SyncanoResponse_APIKeys_GetOne *)apiKeyGetOne:(SyncanoParameters_APIKeys_GetOne *)params;

/**
 Update existing API key
 
 @param params Update API key parameters
 
 @return Reponse to existing API key update
 */
- (SyncanoResponse_APIKeys_UpdateDescription *)apiKeyUpdateDescription:(SyncanoParameters_APIKeys_UpdateDescription *)params;

/**
 Authorize API Key
 
 @param params Authorize API Key parameters
 
 @return Response to authorizing API Key
 */
- (SyncanoResponse *)apiKeyAuthorize:(SyncanoParameters_APIKeys_Authorize *)params;

/**
 Deauthorize API Key
 
 @param params Deauthorize API Key parameters
 
 @return Response to deauthorizing API Key
 */
- (SyncanoResponse *)apiKeyDeauthorize:(SyncanoParameters_APIKeys_Deauthorize *)params;

/**
 Delete existing API key
 
 @param params Delete API key parameters
 
 @return Reponse to existing API key deletion
 */
- (SyncanoResponse *)apiKeyDelete:(SyncanoParameters_APIKeys_Delete *)params;

#pragma mark - Asynchronized

///-
/// @name Asynchronous requests
///-

/**
 Start session for API key
 
 @param params Parameters for starting API key
 */
- (id <SyncanoRequest> )apiKeyStartSession:(SyncanoParameters_APIKeys_StartSession *)params callback:(void (^)(SyncanoResponse_APIKeys_StartSession *response))callback;

/**
 Create new API key
 
 @param params Parameters of new API key
 */
- (id <SyncanoRequest> )apiKeyNew:(SyncanoParameters_APIKeys_New *)params callback:(void (^)(SyncanoResponse_APIKeys_New *response))callback;

/**
 Get API key list
 
 @param params API key list parameters
 */
- (id <SyncanoRequest> )apiKeyGet:(SyncanoParameters_APIKeys_Get *)params callback:(void (^)(SyncanoResponse_APIKeys_Get *response))callback;

/**
 Get one API key
 
 @param params Single API key getter parameters
 */
- (id <SyncanoRequest> )apiKeyGetOne:(SyncanoParameters_APIKeys_GetOne *)params callback:(void (^)(SyncanoResponse_APIKeys_GetOne *response))callback;

/**
 Update existing API key
 
 @param params Update API key parameters
 */
- (id <SyncanoRequest> )apiKeyUpdateDescription:(SyncanoParameters_APIKeys_UpdateDescription *)params callback:(void (^)(SyncanoResponse_APIKeys_UpdateDescription *response))callback;

/**
 Authorize API Key
 
 @param params Authorize API Key parameters
 @param callback Callback with response to authorizing API Key
 */
- (id <SyncanoRequest> )apiKeyAuthorize:(SyncanoParameters_APIKeys_Authorize *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Deauthorize API Key
 
 @param params Deauthorize API Key parameters
 @param callback Callback with response to deauthorizing API Key
 */
- (id <SyncanoRequest> )apiKeyDeauthorize:(SyncanoParameters_APIKeys_Deauthorize *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Delete existing API key
 
 @param params Delete API key parameters
 */
- (id <SyncanoRequest> )apiKeyDelete:(SyncanoParameters_APIKeys_Delete *)params callback:(void (^)(SyncanoResponse *response))callback;

@end
