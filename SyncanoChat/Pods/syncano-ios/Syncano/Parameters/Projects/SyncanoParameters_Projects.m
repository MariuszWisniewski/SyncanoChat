//
//  SyncanoParameters_Projects.m
//  Syncano
//
//  Created by Syncano Inc. on 03/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_Projects.h"
#import "SyncanoParameters_Private.h"
#import "SyncanoResponse_Projects.h"

@implementation SyncanoParameters_Projects_New

- (SyncanoParameters_Projects_New *)initWithName:(NSString *)name {
	self = [super init];
	if (self) {
		self.name = name;
		[self validateParameters];
	}
	return self;
}

- (SyncanoParameters_Projects_New *)initWithName:(NSString *)name description:(NSString *)description {
	self = [super init];
	if (self) {
		self.name = name;
		self.projectDescription = description;
		[self validateParameters];
	}
	return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"name" : @"name",
		                          @"projectDescription" : @"description" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithName:", @"initWithName:description:"];
}

- (NSArray *)requiredParametersNames {
	return @[@"name"];
}

- (NSString *)methodName {
	return @"project.new";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Projects_New responseFromJSON:json];
}

@end

@implementation SyncanoParameters_Projects_Get

- (NSString *)methodName {
	return @"project.get";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Projects_Get responseFromJSON:json];
}

@end

@implementation SyncanoParameters_Projects_GetOne

- (SyncanoParameters_Projects_GetOne *)initWithProjectId:(NSString *)projectId {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		[self validateParameters];
	}
	return self;
}

- (SEL)initalizeSelector {
	return @selector(initWithProjectId:);
}

- (NSArray *)requiredParametersNames {
	return @[@"projectId"];
}

- (NSString *)methodName {
	return @"project.get_one";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Projects_GetOne responseFromJSON:json];
}

@end

@implementation SyncanoParameters_Projects_Update

- (SyncanoParameters_Projects_Update *)initWithProjectId:(NSString *)projectId {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		[self validateParameters];
	}
	return self;
}

- (SEL)initalizeSelector {
	return @selector(initWithProjectId:);
}

- (NSArray *)requiredParametersNames {
	return @[@"projectId"];
}

- (NSString *)methodName {
	return @"project.update";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
		                          @"name" : @"name",
		                          @"projectDescription" : @"description" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Projects_Update responseFromJSON:json];
}

@end

@implementation SyncanoParameters_Projects_Authorize

- (SyncanoParameters_Projects_Authorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId {
	self = [super init];
	if (self) {
		self.apiClientId = apiClientId;
		self.permission = permission;
		self.projectId = projectId;
		[self validateParameters];
	}
	return self;
}

- (SEL)initalizeSelector {
	return @selector(initWithApiClientId:permission:projectId:);
}

- (NSArray *)requiredParametersNames {
	return @[@"apiClientId", @"permission", @"projectId"];
}

- (NSString *)methodName {
	return @"project.authorize";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"apiClientId" : @"api_client_id",
		                          @"permission" : @"permission",
		                          @"projectId" : @"project_id" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse responseFromJSON:json];
}

@end

@implementation SyncanoParameters_Projects_Deauthorize

- (SyncanoParameters_Projects_Deauthorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId {
	self = [super init];
	if (self) {
		self.apiClientId = apiClientId;
		self.permission = permission;
		self.projectId = projectId;
		[self validateParameters];
	}
	return self;
}

- (SEL)initalizeSelector {
	return @selector(initWithApiClientId:permission:projectId:);
}

- (NSArray *)requiredParametersNames {
	return @[@"apiClientId", @"permission", @"projectId"];
}

- (NSString *)methodName {
	return @"project.deauthorize";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"apiClientId" : @"api_client_id",
		                          @"permission" : @"permission",
		                          @"projectId" : @"project_id" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse responseFromJSON:json];
}

@end

@implementation SyncanoParameters_Projects_Delete

- (SyncanoParameters_Projects_Delete *)initWithProjectId:(NSString *)projectId {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		[self validateParameters];
	}
	return self;
}

- (SEL)initalizeSelector {
	return @selector(initWithProjectId:);
}

- (NSArray *)requiredParametersNames {
	return @[@"projectId"];
}

- (NSString *)methodName {
	return @"project.delete";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end
