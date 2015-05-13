//
//  SyncanoResponse_APIKeys.h
//  Syncano
//
//  Created by Syncano Inc. on 12/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse.h"
#import "SyncanoObjects.h"

@interface SyncanoResponse_APIKeys_StartSession : SyncanoResponse
/**
   Session ID for current session
 */
@property (strong) NSString *session_id;
/**
   Response UUID
 */
@property (strong) NSString *uuid;
@end

@interface SyncanoResponse_APIKeys_New : SyncanoResponse
/**
   Created client SyncanoObject
 */
@property (strong) SyncanoApiKey *apiKey;
@end

@interface SyncanoResponse_APIKeys_Get : SyncanoResponse
/**
   Clients array from response
 */
@property (strong) NSArray *apikey;
@end

@interface SyncanoResponse_APIKeys_GetOne : SyncanoResponse
/**
   Single client from response
 */
@property (strong) SyncanoApiKey *apikey;
@end

@interface SyncanoResponse_APIKeys_UpdateDescription : SyncanoResponse
/**
   Updated client from response
 */
@property (strong) SyncanoApiKey *apikey;
@end
