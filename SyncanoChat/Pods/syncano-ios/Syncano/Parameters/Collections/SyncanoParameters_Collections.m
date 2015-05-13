//
//  SyncanoParameters_Collections.m
//  Syncano
//
//  Created by Syncano Inc. on 03/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_Collections.h"
#import "SyncanoParameters_Private.h"
#import "SyncanoResponse_Collections.h"

NSString *const kSyncanoParametersCollectionStatusActive = @"active";
NSString *const kSyncanoParametersCollectionStatusInactive = @"inactive";
NSString *const kSyncanoParametersCollectionStatusAll = @"all";

@implementation SyncanoParameters_Collections_New

- (SyncanoParameters_Collections_New *)initWithProjectId:(NSString *)projectId name:(NSString *)name {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.name = name;
		[self validateParameters];
	}
	return self;
}

- (SEL)initalizeSelector {
	return @selector(initWithProjectId:name:);
}

- (NSArray *)requiredParametersNames {
	return @[@"name", @"projectId"];
}

- (NSString *)methodName {
	return @"collection.new";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Collections_New responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
		                          @"name" : @"name",
		                          @"key" : @"key",
		                          @"collectionDescription" : @"description" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_Collections_Get

- (SyncanoParameters_Collections_Get *)initWithProjectId:(NSString *)projectId {
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

- (void)setStatus:(NSString *)status {
	NSArray *acceptedValues = [self acceptedValues];
	if ([acceptedValues containsObject:status]) {
		_status = status;
	}
	else {
		[NSException raise:@"Wrong parameter value" format:@"Allowed values for status parameter: %@ (use kSyncanoParametersCollectionStatus constans)", acceptedValues];
	}
}

- (NSArray *)acceptedValues {
	return @[kSyncanoParametersCollectionStatusActive, kSyncanoParametersCollectionStatusInactive, kSyncanoParametersCollectionStatusAll];
}

- (NSString *)methodName {
	return @"collection.get";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Collections_Get responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
		                          @"status" : @"status",
		                          @"withTags" : @"with_tags" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_Collections_GetOne

- (NSString *)methodName {
	return @"collection.get_one";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Collections_GetOne responseFromJSON:json];
}

@end

@implementation SyncanoParameters_Collections_Activate

- (SyncanoParameters_Collections_Activate *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionId = collectionId;
		[self validateParameters];
	}
	return self;
}

- (SEL)initalizeSelector {
	return @selector(initWithProjectId:collectionId:);
}

- (NSArray *)requiredParametersNames {
	return @[@"projectId", @"collectionId"];
}

- (NSString *)methodName {
	return @"collection.activate";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
		                          @"collectionId" : @"collection_id",
		                          @"force" : @"force" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_Collections_Deactivate

- (NSString *)methodName {
	return @"collection.deactivate";
}

@end

@implementation SyncanoParameters_Collections_Update

- (NSString *)methodName {
	return @"collection.update";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Collections_Update responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"name" : @"name",
		                          @"collectionDescription" : @"description" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_Collections_Authorize

- (SyncanoParameters_Collections_Authorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId collectionId:(NSString *)collectionId {
	self = [super init];
	if (self) {
		self.apiClientId = apiClientId;
		self.permission = permission;
		self.projectId = projectId;
		self.collectionId = collectionId;
		[self validateSpecialParameters:@[@"apiClientId", @"permission", @"projectId", @"collectionId"]];
	}
	return self;
}

- (SyncanoParameters_Collections_Authorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId collectionKey:(NSString *)collectionKey {
	self = [super init];
	if (self) {
		self.apiClientId = apiClientId;
		self.permission = permission;
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		[self validateSpecialParameters:@[@"apiClientId", @"permission", @"projectId", @"collectionKey"]];
	}
	return self;
}

- (NSString *)methodName {
	return @"collection.authorize";
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithApiClientId:permission:projectId:collectionId:",
	         @"initWithApiClientId:permission:projectId:collectionKey:"];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"apiClientId" : @"api_client_id",
		                          @"permission" : @"permission",
		                          @"projectId" : @"project_id",
		                          @"collectionId" : @"collection_id",
		                          @"collectionKey" : @"collection_key" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_Collections_Deauthorize

- (SyncanoParameters_Collections_Deauthorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId collectionId:(NSString *)collectionId {
	self = [super init];
	if (self) {
		self.apiClientId = apiClientId;
		self.permission = permission;
		self.projectId = projectId;
		self.collectionId = collectionId;
		[self validateSpecialParameters:@[@"apiClientId", @"permission", @"projectId", @"collectionId"]];
	}
	return self;
}

- (SyncanoParameters_Collections_Deauthorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission projectId:(NSString *)projectId collectionKey:(NSString *)collectionKey {
	self = [super init];
	if (self) {
		self.apiClientId = apiClientId;
		self.permission = permission;
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		[self validateSpecialParameters:@[@"apiClientId", @"permission", @"projectId", @"collectionKey"]];
	}
	return self;
}

- (NSString *)methodName {
	return @"collection.deauthorize";
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithApiClientId:permission:projectId:collectionId:",
	         @"initWithApiClientId:permission:projectId:collectionKey:"];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"apiClientId" : @"api_client_id",
		                          @"permission" : @"permission",
		                          @"projectId" : @"project_id",
		                          @"collectionId" : @"collection_id",
		                          @"collectionKey" : @"collection_key" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_Collections_Delete

- (NSString *)methodName {
	return @"collection.delete";
}

@end

@implementation SyncanoParameters_Collections_AddTag

- (SyncanoParameters_Collections_AddTag *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId tags:(NSArray *)tags {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionId = collectionId;
		self.tags = tags;
		[self validateSpecialParameters:@[@"projectId", @"collectionId", @"tags"]];
	}
	return self;
}

- (SyncanoParameters_Collections_AddTag *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey tags:(NSArray *)tags {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		self.tags = tags;
		[self validateSpecialParameters:@[@"projectId", @"collectionKey", @"tags"]];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithProjectId:collectionId:tags:", @"initWithProjectId:collectionKey:tags:"];
}

- (NSString *)methodName {
	return @"collection.add_tag";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
		                          @"collectionId" : @"collection_id",
		                          @"collectionKey" : @"collection_key",
		                          @"tags" : @"tags",
		                          @"weight" : @"weight",
		                          @"removeOther" : @"remove_other" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_Collections_DeleteTag

- (SyncanoParameters_Collections_DeleteTag *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId tags:(NSArray *)tags {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionId = collectionId;
		self.tags = tags;
		[self validateSpecialParameters:@[@"projectId", @"collectionId", @"tags"]];
	}
	return self;
}

- (SyncanoParameters_Collections_DeleteTag *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey tags:(NSArray *)tags {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		self.tags = tags;
		[self validateSpecialParameters:@[@"projectId", @"collectionKey", @"tags"]];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithProjectId:collectionId:tags:", @"initWithProjectId:collectionKey:tags:"];
}

- (NSString *)methodName {
	return @"collection.delete_tag";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
		                          @"collectionId" : @"collection_id",
		                          @"collectionKey" : @"collection_key",
		                          @"tags" : @"tags" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end
