//
//  SyncanoResponse_Administrators.h
//  Syncano
//
//  Created by Syncano Inc. on 12/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse.h"
#import "SyncanoObjects.h"

@interface SyncanoResponse_Administrators_Get : SyncanoResponse
/**
 Array containing returned administrator list
 */
@property (strong) NSArray *admin;
@end

@interface SyncanoResponse_Administrators_GetOne : SyncanoResponse
/**
 SyncanoResponse containing administator
 */
@property (strong) SyncanoAdmin *admin;
@end

@interface SyncanoResponse_Administrators_Update : SyncanoResponse
/**
 SyncanoResponse containing administator
 */
@property (strong) SyncanoAdmin *admin;
@end
