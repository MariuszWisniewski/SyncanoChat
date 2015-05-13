//
//  SyncanoResponse_Subscriptions.m
//  Syncano
//
//  Created by Syncano Inc. on 09/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse_Subscriptions.h"
#import "SyncanoResponse_Private.h"

@implementation SyncanoResponse_Subscriptions_Get
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"subscription"]) {
		return [SyncanoSubscription class];
	}
	return nil;
}

- (BOOL)isKeyArray:(NSString *)key {
	if ([key isEqualToString:@"subscription"]) {
		return YES;
	}
	return NO;
}

@end
