//
//  SyncanoObject+Private.m
//  Syncano
//
//  Created by Syncano Inc. on 15/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoObjects_Private.h"

@implementation NSDictionary (SyncanoObjects)

- (id)syncano_notNullObjectForKey:(id)aKey {
    id object = [self objectForKey:aKey];
    if (object == [NSNull null]) {
        object = nil;
    }
    return object;
}

@end

@implementation SyncanoAuth
- (BOOL)isKeyDate:(NSString *)key {
	if ([key isEqualToString:@"timestamp"]) {
		return YES;
	}
	return NO;
}

- (BOOL)OK {
	return [self.result isEqualToString:@"OK"];
}

@end

@implementation SyncanoPing
- (BOOL)isKeyDate:(NSString *)key {
	if ([key isEqualToString:@"timestamp"]) {
		return YES;
	}
	return NO;
}

@end

@implementation SyncanoError
@end
