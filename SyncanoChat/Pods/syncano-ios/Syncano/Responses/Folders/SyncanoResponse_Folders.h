//
//  SyncanoResponse_Folders.h
//  Syncano
//
//  Created by Syncano Inc. on 09/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse.h"
#import "SyncanoObjects.h"

@interface SyncanoResponse_Folders_New : SyncanoResponse
/**
 Newly created folder
 */
@property (strong)    SyncanoFolder *folder;
@end

@interface SyncanoResponse_Folders_Get : SyncanoResponse
/**
 Requested list of folders
 */
@property (strong)    NSArray *folder;
@end

@interface SyncanoResponse_Folders_GetOne : SyncanoResponse
/**
 Requested single folder
 */
@property (strong)    SyncanoFolder *folder;
@end
