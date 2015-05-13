//
//  SyncanoResponse_PermissionRoles.h
//  Syncano
//
//  Created by Syncano Inc. on 12/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse.h"
#import "SyncanoObjects.h"

@interface SyncanoResponse_PermissionRoles_Get : SyncanoResponse
/**
 List of all permission roles of current instance.
 */
@property (strong)  NSArray *roles;
@end
