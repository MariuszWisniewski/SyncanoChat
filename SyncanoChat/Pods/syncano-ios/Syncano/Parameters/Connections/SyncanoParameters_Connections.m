//
//  SyncanoParameters_Identities.m
//  Syncano
//
//  Created by Syncano Inc. on 13/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_Connections.h"
#import "SyncanoParameters_Private.h"
#import "SyncanoResponse_Connections.h"

@implementation SyncanoParameters_Connections_Get

- (NSString *)methodName {
	return @"connection.get";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Connections_Get responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"apiClientId" : @"api_client_id",
		                          @"name" : @"name",
		                          @"sinceId" : @"since_id",
		                          @"limit" : @"limit" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end


@implementation SyncanoParameters_Connections_Get_All

- (NSString *)methodName {
	return @"connection.get_all";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Connections_Get_All responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"name" : @"name",
		                          @"sinceId" : @"since_id",
		                          @"limit" : @"limit" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end


@implementation SyncanoParameters_Connections_Update

- (SyncanoParameters_Connections_Update *)initWithUUID:(NSString *)uuid state:(NSString *)state {
	self = [super init];
	if (self) {
		self.uuid = uuid;
		self.state = state;
		[self validateParameters];
	}
	return self;
}

- (SEL)initalizeSelector {
	return @selector(initWithUUID:state:);
}

- (NSArray *)requiredParametersNames {
	return @[@"uuid", @"state"];
}

- (NSString *)methodName {
	return @"connection.update";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Connections_Update responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"apiClientId" : @"api_client_id",
		                          @"uuid" : @"uuid",
		                          @"state" : @"state" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end
