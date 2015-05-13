//
//  SyncanoResponse_Collections.m
//  Syncano
//
//  Created by Syncano Inc. on 09/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse_Collections.h"

@implementation SyncanoResponse_Collections_New : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"collection"]) {
		return [SyncanoCollection class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_Collections_Get : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"collection"]) {
		return [SyncanoCollection class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_Collections_GetOne : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"collection"]) {
		return [SyncanoCollection class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_Collections_Update : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"collection"]) {
		return [SyncanoCollection class];
	}
	return nil;
}

@end
