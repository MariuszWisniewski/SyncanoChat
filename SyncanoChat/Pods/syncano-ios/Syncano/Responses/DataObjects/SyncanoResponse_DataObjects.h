//
//  SyncanoResponse_DataObjects.h
//  Syncano
//
//  Created by Syncano Inc. on 09/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse.h"
#import "SyncanoObjects.h"

@interface SyncanoResponse_DataObjects_New : SyncanoResponse
/**
 Newly created SyncanoData object
 */
@property (strong)    SyncanoData *data;
@end

@interface SyncanoResponse_DataObjects_Get : SyncanoResponse
/**
 Requested list of SyncanoData objects
 */
@property (strong)    NSArray *data;
@end

@interface SyncanoResponse_DataObjects_GetOne : SyncanoResponse
/**
 Requested SyncanoData object
 */
@property (strong)    SyncanoData *data;
@end

@interface SyncanoResponse_DataObjects_Update : SyncanoResponse
/**
 Updated SyncanoData object
 */
@property (strong)    SyncanoData *data;
@end

@interface SyncanoResponse_DataObjects_Copy : SyncanoResponse
/**
 Copied SyncanoData object
 */
@property (strong)    SyncanoData *data;
@end

@interface SyncanoResponse_DataObjects_Count : SyncanoResponse
/**
 Count of SyncanoData objects
 */
@property (strong)    NSNumber *count;
@end
