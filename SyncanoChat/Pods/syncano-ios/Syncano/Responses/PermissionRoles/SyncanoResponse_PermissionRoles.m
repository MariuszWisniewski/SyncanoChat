//
//  SyncanoResponse_PermissionRoles.m
//  Syncano
//
//  Created by Syncano Inc. on 12/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse_PermissionRoles.h"

@implementation SyncanoResponse_PermissionRoles_Get

- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"roles"]) {
		return [SyncanoRole class];
	}
	return nil;
}

- (BOOL)isKeyArray:(NSString *)key {
	if ([key isEqualToString:@"roles"]) {
		return YES;
	}
	return NO;
}

@end
