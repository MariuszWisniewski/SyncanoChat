//
//  SyncanoResponse_DataObjects.m
//  Syncano
//
//  Created by Syncano Inc. on 09/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse_DataObjects.h"

@implementation SyncanoResponse_DataObjects_New : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"data"]) {
		return [SyncanoData class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_DataObjects_Get : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"data"]) {
		return [SyncanoData class];
	}
	return nil;
}

- (BOOL)isKeyArray:(NSString *)key {
	if ([key isEqualToString:@"data"]) {
		return YES;
	}
	return NO;
}

@end

@implementation SyncanoResponse_DataObjects_GetOne : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"data"]) {
		return [SyncanoData class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_DataObjects_Update : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"data"]) {
		return [SyncanoData class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_DataObjects_Copy : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"data"]) {
		return [SyncanoData class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_DataObjects_Count : SyncanoResponse

@end
