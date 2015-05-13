//
//  SyncanoResponse_Users.m
//  Syncano
//
//  Created by Syncano Inc. on 09/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse_Users.h"

@implementation SyncanoResponse_Users_Login
- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"auth_key"]) {
		self.authKey = value;
	}
	else {
		[super setValue:value forKey:key];
	}
}

@end

@implementation SyncanoResponse_Users_New : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"user"]) {
		return [SyncanoUser class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_Users_GetAll : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"user"]) {
		return [SyncanoUser class];
	}
	return nil;
}

- (BOOL)isKeyArray:(NSString *)key {
	if ([key isEqualToString:@"user"]) {
		return YES;
	}
	return NO;
}

@end

@implementation SyncanoResponse_Users_Get : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"user"]) {
		return [SyncanoUser class];
	}
	return nil;
}

- (BOOL)isKeyArray:(NSString *)key {
	if ([key isEqualToString:@"user"]) {
		return YES;
	}
	return NO;
}

@end

@implementation SyncanoResponse_Users_GetOne : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"user"]) {
		return [SyncanoUser class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_Users_Update : SyncanoResponse
- (Class)classForKey:(NSString *)key {
	if ([key isEqualToString:@"user"]) {
		return [SyncanoUser class];
	}
	return nil;
}

@end

@implementation SyncanoResponse_Users_Count : SyncanoResponse

@end
