//
//  SyncanoResponse_Administrators.m
//  Syncano
//
//  Created by Syncano Inc. on 12/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse_Administrators.h"

@implementation SyncanoResponse_Administrators_Get
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"admin"]) {
		return [SyncanoAdmin class];
	}
	return nil;
}

- (BOOL)isKeyArray:(NSString *)key {
	if ([key isEqualToString:@"admin"]) {
		return YES;
	}
	return NO;
}

@end

@implementation SyncanoResponse_Administrators_GetOne
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"admin"]) {
		return [SyncanoAdmin class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_Administrators_Update
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"admin"]) {
		return [SyncanoAdmin class];
	}
	return nil;
}

@end
