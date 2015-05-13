//
//  SyncanoProtocolCollections.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#ifndef Syncano_SyncanoProtocolCollections_h
#define Syncano_SyncanoProtocolCollections_h

#import "SyncanoParameters_Collections.h"
#import "SyncanoResponse_Collections.h"
#import "SyncanoProtocolRequest.h"

/**
 SyncanoProtocolCollections is used to transmit information about SyncanoCollection objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer communicating with Syncano API.
 */
@protocol SyncanoProtocolCollections <NSObject>
@required

#pragma mark - Synchronized

///-
/// @name Synchronous requests
///-

/**
 Create new collection
 
 @param params Parameters of new collection
 
 @return Response for creation of new collection
 */
- (SyncanoResponse_Collections_New *)collectionNew:(SyncanoParameters_Collections_New *)params;

/**
 Get collection list
 
 @note User API key usage permitted. Returns only collections that have``read_data`` permission added through collection.authorize() or project.authorize().
 
 @param params Collection list parameters
 
 @return Response for collection list
 */
- (SyncanoResponse_Collections_Get *)collectionGet:(SyncanoParameters_Collections_Get *)params;

/**
 Get one collection
 
 @note User API key usage permitted if read_data permission is added to specified collection through collection.authorize() or project.authorize().
 
 @param params Single collection getter parameters
 
 @return Response for single collection
 */
- (SyncanoResponse_Collections_GetOne *)collectionGetOne:(SyncanoParameters_Collections_GetOne *)params;

/**
 Activate collection
 
 @param params Activate collection parameters
 
 @return Reponse to collection activation
 */
- (SyncanoResponse *)collectionActivate:(SyncanoParameters_Collections_Activate *)params;

/**
 Deactivate collection
 
 @param params Deactivate collection parameters
 
 @return Reponse to collection deactivation
 */
- (SyncanoResponse *)collectionDeactivate:(SyncanoParameters_Collections_Deactivate *)params;

/**
 Update existing collection
 
 @param params Update collection parameters
 
 @return Reponse to existing collection update
 */
- (SyncanoResponse_Collections_Update *)collectionUpdate:(SyncanoParameters_Collections_Update *)params;

/**
 Adds collection-level permission to specified User API client. Requires Backend API key with Admin permission role.
 
 @param params Authorize collection parameters.
 
 @return Response for authorizing collection.
 */
- (SyncanoResponse *)collectionAuthorize:(SyncanoParameters_Collections_Authorize *)params;

/**
 Removes collection-level permission from specified User API client. Requires Backend API key with Admin permission role.
 
 @param params Deauthorize collection parameters.
 
 @return Response for deauthorizing collection.
 */
- (SyncanoResponse *)collectionDeauthorize:(SyncanoParameters_Collections_Deauthorize *)params;

/**
 Delete existing collection
 
 @param params Delete collection parameters
 
 @return Reponse to existing collection deletion
 */
- (SyncanoResponse *)collectionDelete:(SyncanoParameters_Collections_Delete *)params;

/**
 Add tag to existing collection
 
 @param params Add tag to collection parameters
 
 @return Reponse to tag addition
 */
- (SyncanoResponse *)collectionAddTag:(SyncanoParameters_Collections_AddTag *)params;

/**
 Remove tag of existing collection
 
 @param params Remove tag of collection parameters
 
 @return Reponse to tag deletion
 */
- (SyncanoResponse *)collectionDeleteTag:(SyncanoParameters_Collections_DeleteTag *)params;

#pragma mark - Asynchronized

///-
/// @name Asynchronous requests
///-

/**
 Create new collection
 
 @param params Parameters of new collection
 */
- (id <SyncanoRequest> )collectionNew:(SyncanoParameters_Collections_New *)params callback:(void (^)(SyncanoResponse_Collections_New *response))callback;

/**
 Get collection list
 
 @note User API key usage permitted. Returns only collections that have``read_data`` permission added through collection.authorize() or project.authorize().
 
 @param params Collection list parameters
 */
- (id <SyncanoRequest> )collectionGet:(SyncanoParameters_Collections_Get *)params callback:(void (^)(SyncanoResponse_Collections_Get *response))callback;

/**
 Get one collection
 
 @note User API key usage permitted if read_data permission is added to specified collection through collection.authorize() or project.authorize().
 
 @param params Single collection getter parameters
 */
- (id <SyncanoRequest> )collectionGetOne:(SyncanoParameters_Collections_GetOne *)params callback:(void (^)(SyncanoResponse_Collections_GetOne *response))callback;

/**
 Activate collection
 
 @param params Activate collection parameters
 */
- (id <SyncanoRequest> )collectionActivate:(SyncanoParameters_Collections_Activate *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Deactivate collection
 
 @param params Deactivate collection parameters
 */
- (id <SyncanoRequest> )collectionDeactivate:(SyncanoParameters_Collections_Deactivate *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Update existing collection
 
 @param params Update collection parameters
 */
- (id <SyncanoRequest> )collectionUpdate:(SyncanoParameters_Collections_Update *)params callback:(void (^)(SyncanoResponse_Collections_Update *response))callback;

/**
 Adds collection-level permission to specified User API client. Requires Backend API key with Admin permission role.
 
 @param params Authorize collection parameters.
 @param callback Callback with response for authorizing collection.
 */
- (id <SyncanoRequest> )collectionAuthorize:(SyncanoParameters_Collections_Authorize *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Removes collection-level permission from specified User API client. Requires Backend API key with Admin permission role.
 
 @param params Deauthorize collection parameters.
 @param callback Callback with response for deauthorizing collection.
 */
- (id <SyncanoRequest> )collectionDeauthorize:(SyncanoParameters_Collections_Deauthorize *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Delete existing collection
 
 @param params Delete collection parameters
 */
- (id <SyncanoRequest> )collectionDelete:(SyncanoParameters_Collections_Delete *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Add tag to existing collection
 
 @param params Add tag to collection parameters
 */
- (id <SyncanoRequest> )collectionAddTag:(SyncanoParameters_Collections_AddTag *)params callback:(void (^)(SyncanoResponse *response))callback;

/**
 Remove tag of existing collection
 
 @param params Remove tag of collection parameters
 */
- (id <SyncanoRequest> )collectionDeleteTag:(SyncanoParameters_Collections_DeleteTag *)params callback:(void (^)(SyncanoResponse *response))callback;

@end

#endif
