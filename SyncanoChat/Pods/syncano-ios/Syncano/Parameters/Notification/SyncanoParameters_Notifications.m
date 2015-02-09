//
//  SyncanoParameters_Notifications.m
//  Syncano
//
//  Created by Syncano Inc. on 07/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_Notifications.h"
#import "SyncanoParameters_Private.h"
#import "SyncanoResponse_Notifications.h"

@implementation SyncanoParameters_Notifications_Send : SyncanoParameters

- (NSString *)methodName {
	return @"notification.send";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"apiClientId" : @"api_client_id",
		                          @"uuid" : @"uuid" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

- (NSDictionary *)dictionaryValue {
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:[super dictionaryValue]];
	if ([self.additional isKindOfClass:[NSDictionary class]]) {
        [dictionary removeObjectForKey:@"additional"];
		[dictionary addEntriesFromDictionary:self.additional];
	}
	return dictionary;
}

@end

@implementation SyncanoParameters_Notifications_GetHistory : SyncanoParameters

- (NSString *)methodName {
	return @"notification.get_history";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Notifications_GetHistory responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"sinceId" : @"since_id",
		                          @"sinceTime" : @"since_time",
		                          @"limit" : @"limit",
		                          @"order" : @"order" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

- (void)setOrder:(NSString *)order {
	NSArray *acceptedValues = [self acceptedOrderValues];
	if ([acceptedValues containsObject:[order lowercaseString]]) {
		_order = order;
	}
	else {
		[NSException raise:@"Wrong parameter value" format:@"Allowed values for order parameter: %@ (use kSyncanoParametersOrder constans)", acceptedValues];
	}
}

- (NSArray *)acceptedOrderValues {
	return @[kSyncanoParametersOrderAsc, kSyncanoParametersOrderDesc];
}

@end
