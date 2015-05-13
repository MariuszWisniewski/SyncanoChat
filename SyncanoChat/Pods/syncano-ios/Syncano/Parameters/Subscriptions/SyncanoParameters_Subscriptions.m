//
//  SyncanoParameters_Subscriptions.m
//  Syncano
//
//  Created by Syncano Inc. on 07/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_Subscriptions.h"
#import "SyncanoParameters_Private.h"
#import "SyncanoResponse_Subscriptions.h"

@implementation SyncanoParameters_Subscriptions_SubscribeProject : SyncanoParameters

- (SyncanoParameters_Subscriptions_SubscribeProject *)initWithProjectId:(NSString *)projectId context:(NSString *)context {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.context = context;
		[self validateParameters];
	}
	return self;
}

- (SEL)initalizeSelector {
	return @selector(initWithProjectId:context:);
}

- (NSArray *)requiredParametersNames {
	return @[@"projectId", @"context"];
}

- (NSString *)methodName {
	return @"subscription.subscribe_project";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
		                          @"context" : @"context" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_Subscriptions_UnsubscribeProject : SyncanoParameters

- (SyncanoParameters_Subscriptions_UnsubscribeProject *)initWithProjectId:(NSString *)projectId {
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
	return @"subscription.unsubscribe_project";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_Subscriptions_SubscribeCollection : SyncanoParameters

- (SyncanoParameters_Subscriptions_SubscribeCollection *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId context:(NSString *)context {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionId = collectionId;
		self.context = context;
		[self validateSpecialParameters:@[@"projectId", @"collectionId", @"context"]];
	}
	return self;
}

- (SyncanoParameters_Subscriptions_SubscribeCollection *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey context:(NSString *)context {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		self.context = context;
		[self validateSpecialParameters:@[@"projectId", @"collectionKey", @"context"]];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithProjectId:collectionId:context:",
	         @"initWithProjectId:collectionKey:context:"];
}

- (NSString *)methodName {
	return @"subscription.subscribe_collection";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
		                          @"collectionId" : @"collection_id",
		                          @"collectionKey" : @"collection_key",
		                          @"context" : @"context" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_Subscriptions_UnsubscribeCollection

- (NSString *)methodName {
	return @"subscription.unsubscribe_collection";
}

@end

@implementation SyncanoParameters_Subscriptions_Get : SyncanoParameters

@dynamic sessionId;

- (NSString *)methodName {
	return @"subscription.get";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Subscriptions_Get responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"apiClientId" : @"api_client_id",
		                          @"sessionId" : @"session_id",
		                          @"uuid" : @"uuid" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end
