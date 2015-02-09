//
//  SyncanoResponse_Collections.h
//  Syncano
//
//  Created by Syncano Inc. on 09/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse.h"
#import "SyncanoObjects.h"

@interface SyncanoResponse_Collections_New : SyncanoResponse
/**
 Newly created collection
 */
@property (strong)    SyncanoCollection *collection;
@end

@interface SyncanoResponse_Collections_Get : SyncanoResponse
/**
 Requested list of collections
 */
@property (strong)    NSArray *collection;
@end

@interface SyncanoResponse_Collections_GetOne : SyncanoResponse
/**
 Requested collection
 */
@property (strong)    SyncanoCollection *collection;
@end

@interface SyncanoResponse_Collections_Update : SyncanoResponse
/**
 Updated collection
 */
@property (strong)    SyncanoCollection *collection;
@end
