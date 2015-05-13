//
//  SyncanoResponse_Projects.m
//  Syncano
//
//  Created by Syncano Inc. on 09/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse_Projects.h"
#import "SyncanoResponse_Private.h"

@implementation SyncanoResponse_Projects_New : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"project"]) {
		return [SyncanoProject class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_Projects_Get : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"project"]) {
		return [SyncanoProject class];
	}
	return nil;
}

- (BOOL)isKeyArray:(NSString *)key {
	if ([key isEqualToString:@"project"]) {
		return YES;
	}
	return NO;
}

@end

@implementation SyncanoResponse_Projects_GetOne : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"project"]) {
		return [SyncanoProject class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_Projects_Update : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"project"]) {
		return [SyncanoProject class];
	}
	return nil;
}

@end
