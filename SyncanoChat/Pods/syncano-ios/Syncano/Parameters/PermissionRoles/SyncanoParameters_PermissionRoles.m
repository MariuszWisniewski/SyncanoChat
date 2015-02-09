//
//  SyncanoParameters_PermissionRoles.m
//  Syncano
//
//  Created by Syncano Inc. on 12/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_PermissionRoles.h"
#import "SyncanoParameters_Private.h"
#import "SyncanoResponse_PermissionRoles.h"

@implementation SyncanoParameters_PermissionRoles_Get
- (NSString *)methodName {
	return @"role.get";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_PermissionRoles_Get responseFromJSON:json];
}

@end
