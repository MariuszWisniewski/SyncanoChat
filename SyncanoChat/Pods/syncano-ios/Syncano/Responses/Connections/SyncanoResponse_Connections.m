//
//  SyncanoResponse_Connections.m
//  Syncano
//
//  Created by Syncano Inc. on 13/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse_Connections.h"

@implementation SyncanoResponse_Connections_Get
- (BOOL)isKeyArray:(NSString *)key {
	if ([key isEqualToString:@"connection"]) {
		return YES;
	}
	return NO;
}

- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"connection"]) {
		return [SyncanoConnection class];
	}
	return nil;
}
@end

@implementation SyncanoResponse_Connections_Get_All
- (BOOL)isKeyArray:(NSString *)key {
	if ([key isEqualToString:@"connection"]) {
		return YES;
	}
	return NO;
}

- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"connection"]) {
		return [SyncanoConnection class];
	}
	return nil;
}
@end

@implementation SyncanoResponse_Connections_Update
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"connection"]) {
		return [SyncanoConnection class];
	}
	return nil;
}

@end
