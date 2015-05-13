//
//  SyncanoResponse_Notifications.m
//  Syncano
//
//  Created by Syncano Inc. on 09/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse_Notifications.h"

@implementation SyncanoResponse_Notifications_GetHistory
- (BOOL)isKeyArray:(NSString *)key {
	if ([key isEqualToString:@"history"]) {
		return YES;
	}
	return NO;
}

@end
