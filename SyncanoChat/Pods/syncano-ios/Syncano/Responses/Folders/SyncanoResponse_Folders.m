//
//  SyncanoResponse_Folders.m
//  Syncano
//
//  Created by Syncano Inc. on 09/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse_Folders.h"

@implementation SyncanoResponse_Folders_New : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"folder"]) {
		return [SyncanoFolder class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_Folders_Get : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"folder"]) {
		return [SyncanoFolder class];
	}
	return nil;
}

- (BOOL)isKeyArray:(NSString *)key {
	if ([key isEqualToString:@"folder"]) {
		return YES;
	}
	return NO;
}

@end

@implementation SyncanoResponse_Folders_GetOne : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"folder"]) {
		return [SyncanoFolder class];
	}
	return nil;
}

@end
