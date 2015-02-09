//
//  SyncanoResponse_APIKeys.m
//  Syncano
//
//  Created by Syncano Inc. on 12/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse_APIKeys.h"

@implementation SyncanoResponse_APIKeys_StartSession
@end

@implementation SyncanoResponse_APIKeys_New
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"api_key"]) {
		return [SyncanoApiKey class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_APIKeys_Get
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"api_key"]) {
		return [SyncanoApiKey class];
	}
	return nil;
}

- (BOOL)isKeyArray:(NSString *)key {
	if ([key isEqualToString:@"api_key"]) {
		return YES;
	}
	return NO;
}

@end

@implementation SyncanoResponse_APIKeys_GetOne
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"api_key"]) {
		return [SyncanoApiKey class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_APIKeys_UpdateDescription
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"api_key"]) {
		return [SyncanoApiKey class];
	}
	return nil;
}

@end
