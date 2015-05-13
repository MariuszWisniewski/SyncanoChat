//
//  SyncanoParameters_Administrators.m
//  Syncano
//
//  Created by Syncano Inc. on 12/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_Administrators.h"
#import "SyncanoParameters_Private.h"
#import "SyncanoResponse_Administrators.h"

@implementation SyncanoParameters_Administrators_New

- (SyncanoParameters_Administrators_New *)initWithAdminEmail:(NSString *)adminEmail roleId:(NSString *)roleId message:(NSString *)message {
	self = [super init];
	if (self) {
		self.adminEmail = adminEmail;
		self.roleId = roleId;
		self.message = message;
		[self validateParameters];
	}
	return self;
}

- (SEL)initalizeSelector {
	return @selector(initWithAdminEmail:roleId:message:);
}

- (NSArray *)requiredParametersNames {
	return @[@"adminEmail", @"roleId"];
}

- (NSString *)methodName {
	return @"admin.new";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"adminEmail" : @"admin_email",
		                          @"roleId" : @"role_id",
		                          @"message" : @"message" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_Administrators_Get
- (NSString *)methodName {
	return @"admin.get";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Administrators_Get responseFromJSON:json];
}

@end

@implementation SyncanoParameters_Administrators_GetOne

- (SyncanoParameters_Administrators_GetOne *)initWithAdminId:(NSString *)adminId {
	self = [super init];
	if (self) {
		self.adminId = adminId;
		[self validateSpecialParameters:@[@"adminId"]];
	}
	return self;
}

- (SyncanoParameters_Administrators_GetOne *)initWithAdminEmail:(NSString *)adminEmail {
	self = [super init];
	if (self) {
		self.adminEmail = adminEmail;
		[self validateSpecialParameters:@[@"adminEmail"]];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithAdminId:", @"initWithAdminEmail:"];
}

- (NSString *)methodName {
	return @"admin.get_one";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Administrators_GetOne responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"adminEmail" : @"admin_email",
		                          @"adminId" : @"admin_id" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_Administrators_Update

- (SyncanoParameters_Administrators_Update *)initWithAdminId:(NSString *)adminId roleId:(NSString *)roleId {
	self = [super init];
	if (self) {
		self.adminId = adminId;
		self.roleId = roleId;
		[self validateSpecialParameters:@[@"adminId", @"roleId"]];
	}
	return self;
}

- (SyncanoParameters_Administrators_Update *)initWithAdminEmail:(NSString *)adminEmail roleId:(NSString *)roleId {
	self = [super init];
	if (self) {
		self.adminEmail = adminEmail;
		self.roleId = roleId;
		[self validateSpecialParameters:@[@"adminEmail", @"roleId"]];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithAdminId:roleId:", @"initWithAdminEmail:roleId:"];
}

- (NSString *)methodName {
	return @"admin.update";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Administrators_Update responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"adminEmail" : @"admin_email",
		                          @"adminId" : @"admin_id",
		                          @"roleId" : @"role_id" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_Administrators_Delete

- (SyncanoParameters_Administrators_Delete *)initWithAdminId:(NSString *)adminId {
	self = [super init];
	if (self) {
		self.adminId = adminId;
		[self validateSpecialParameters:@[@"adminId"]];
	}
	return self;
}

- (SyncanoParameters_Administrators_Delete *)initWithAdminEmail:(NSString *)adminEmail {
	self = [super init];
	if (self) {
		self.adminEmail = adminEmail;
		[self validateSpecialParameters:@[@"adminEmail"]];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithAdminId:", @"initWithAdminEmail:"];
}

- (NSString *)methodName {
	return @"admin.delete";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"adminEmail" : @"admin_email",
		                          @"adminId" : @"admin_id" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end
