//
//  SyncanoResponse_Projects.h
//  Syncano
//
//  Created by Syncano Inc. on 09/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse.h"
#import "SyncanoObjects.h"

@interface SyncanoResponse_Projects_New : SyncanoResponse
/**
 Newly created Project SyncanoObject
 */
@property (strong)    SyncanoProject *project;
@end

@interface SyncanoResponse_Projects_Get : SyncanoResponse
/**
 List of project objects
 */
@property (strong)    NSArray *project;
@end

@interface SyncanoResponse_Projects_GetOne : SyncanoResponse
/**
 Single project object
 */
@property (strong)    SyncanoProject *project;
@end

@interface SyncanoResponse_Projects_Update : SyncanoResponse
/**
 Updated project object
 */
@property (strong)    SyncanoProject *project;
@end
