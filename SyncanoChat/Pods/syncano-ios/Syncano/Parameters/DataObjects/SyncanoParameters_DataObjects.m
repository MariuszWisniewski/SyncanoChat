//
//  SyncanoParameters_DataObjects.m
//  Syncano
//
//  Created by Syncano Inc. on 07/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_DataObjects.h"
#import "SyncanoParameters_Private.h"
#import "SyncanoResponse_DataObjects.h"

NSString *const kSyncanoParametersDataObjectsStatePending = @"pending";
NSString *const kSyncanoParametersDataObjectsStateModerated = @"moderated";
NSString *const kSyncanoParametersDataObjectsStateRejected = @"rejected";

NSString *const kSyncanoParametersDataObjectsOrderById = @"id";
NSString *const kSyncanoParametersDataObjectsOrderByCreatedAt = @"created_at";
NSString *const kSyncanoParametersDataObjectsOrderByUpdatedAt = @"updated_at";
NSString *const kSyncanoParametersDataObjectsOrderByData1 = @"data1";
NSString *const kSyncanoParametersDataObjectsOrderByData2 = @"data2";
NSString *const kSyncanoParametersDataObjectsOrderByData3 = @"data3";

NSString *fieldNameForField(FilterableDataField field) {
	NSString *fieldName = nil;
	switch (field) {
		case FilterableDataField_Data1:
			fieldName = @"data1";
			break;
      
		case FilterableDataField_Data2:
			fieldName = @"data2";
			break;
      
		case FilterableDataField_Data3:
			fieldName = @"data3";
			break;
      
		default:
			break;
	}
	return fieldName;
}

NSString *filterNameForFilter(DataFieldFilter filter) {
	NSString *filterName = nil;
	switch (filter) {
		case DataFieldFilter_EQUAL:
			filterName = @"eq";
			break;
      
		case DataFieldFilter_NOT_EQUAL:
			filterName = @"neq";
			break;
      
		case DataFieldFilter_LESS:
			filterName = @"le";
			break;
      
		case DataFieldFilter_LESS_EQUAL:
			filterName = @"lte";
			break;
      
		case DataFieldFilter_GREATER:
			filterName = @"gt";
			break;
      
		case DataFieldFilter_GREATER_EQUAL:
			filterName = @"gte";
			break;
      
		default:
			break;
	}
	return filterName;
}

@implementation SyncanoParameters_DataObjects_State_Validate

- (void)setState:(NSString *)state {
	NSArray *acceptedValues = [self acceptedStateValues];
	if ([acceptedValues containsObject:[state lowercaseString]]) {
		_state = state;
	}
	else {
		[NSException raise:@"Wrong parameter value" format:@"Allowed values for state parameter: %@ (use kSyncanoParametersDataObjectsState constans)", acceptedValues];
	}
}

- (NSArray *)acceptedStateValues {
	return @[kSyncanoParametersDataObjectsStateModerated, kSyncanoParametersDataObjectsStatePending, kSyncanoParametersDataObjectsStateRejected];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"state" : @"state" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_ProjectId_CollectionId_CollectionKey_State_Validate

- (void)setState:(NSString *)state {
	NSArray *acceptedValues = [self acceptedStateValues];
	if ([acceptedValues containsObject:[state lowercaseString]]) {
		_state = state;
	}
	else {
		[NSException raise:@"Wrong parameter value" format:@"Allowed values for state parameter: %@ (use kSyncanoParametersDataObjectsState constans)", acceptedValues];
	}
}

- (NSArray *)acceptedStateValues {
	return @[kSyncanoParametersDataObjectsStateModerated, kSyncanoParametersDataObjectsStatePending, kSyncanoParametersDataObjectsStateRejected];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"state" : @"state" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_DataObjects_CollectionId_CollectionKey_DataId_DataKey_State

- (SyncanoParameters_DataObjects_CollectionId_CollectionKey_DataId_DataKey_State *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataId:(NSString *)dataId state:(NSString *)state {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionId = collectionId;
		self.dataId = dataId;
		self.state = state;
		[self validateSpecialParameters:@[@"projectId", @"collectionId", @"dataId", @"state"]];
	}
	return self;
}

- (SyncanoParameters_DataObjects_CollectionId_CollectionKey_DataId_DataKey_State *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataKey:(NSString *)dataKey state:(NSString *)state {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionId = collectionId;
		self.dataKey = dataKey;
		self.state = state;
		[self validateSpecialParameters:@[@"projectId", @"collectionId", @"dataKey", @"state"]];
	}
	return self;
}

- (SyncanoParameters_DataObjects_CollectionId_CollectionKey_DataId_DataKey_State *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataId:(NSString *)dataId state:(NSString *)state {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		self.dataId = dataId;
		self.state = state;
		[self validateSpecialParameters:@[@"projectId", @"collectionKey", @"dataId", @"state"]];
	}
	return self;
}

- (SyncanoParameters_DataObjects_CollectionId_CollectionKey_DataId_DataKey_State *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataKey:(NSString *)dataKey state:(NSString *)state {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		self.dataKey = dataKey;
		self.state = state;
		[self validateSpecialParameters:@[@"projectId", @"collectionKey", @"dataKey", @"state"]];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithProjectId:collectionId:dataId:state:", @"initWithProjectId:collectionId:dataKey:state:",
	         @"initWithProjectId:collectionKey:dataId:state:", @"initWithProjectId:collectionKey:dataKey:state:"];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
                                @"collectionId" : @"collection_id",
                                @"collectionKey" : @"collection_key",
                                @"dataId" : @"data_id",
                                @"dataKey" : @"data_key" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_DataObjects_New

- (SyncanoParameters_DataObjects_New *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId state:(NSString *)state {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionId = collectionId;
		self.state = state;
		[self validateSpecialParameters:@[@"projectId", @"collectionId", @"state"]];
	}
	return self;
}

- (SyncanoParameters_DataObjects_New *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey state:(NSString *)state {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		self.state = state;
		[self validateSpecialParameters:@[@"projectId", @"collectionKey", @"state"]];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithProjectId:collectionId:state:", @"initWithProjectId:collectionKey:state:"];
}

- (NSString *)methodName {
	return @"data.new";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_DataObjects_New responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
                                @"collectionId" : @"collection_id",
                                @"collectionKey" : @"collection_key",
                                @"dataId" : @"data_id",
                                @"dataKey" : @"data_key",
                                @"userName" : @"user_name",
                                @"sourceUrl" : @"source_url",
                                @"title" : @"title",
                                @"text" : @"text",
                                @"link" : @"link",
                                @"imageUrl" : @"image_url",
                                @"folder" : @"folder",
                                @"parentId" : @"parent_id",
                                @"data1" : @"data1",
                                @"data2" : @"data2",
                                @"data3" : @"data3" };
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

@interface SyncanoParameters_DataObjects_Get ()
@property (strong, nonatomic) NSMutableDictionary *additional;
@end

@implementation SyncanoParameters_DataObjects_Get

- (NSMutableDictionary *)additional {
	if (_additional == nil) {
		_additional = [NSMutableDictionary dictionary];
	}
	return _additional;
}

- (NSString *)methodName {
	return @"data.get";
}

- (NSString *)combineDataField:(FilterableDataField)field andFilter:(DataFieldFilter)filter {
	NSString *fieldName = fieldNameForField(field);
	NSString *filterName = filterNameForFilter(filter);
	NSString *combined = nil;
	if (fieldName && filterName) {
		combined = [NSString stringWithFormat:@"%@__%@", fieldName, filterName];
	}
	return combined;
}

- (void)addFilter:(DataFieldFilter)filter forField:(FilterableDataField)field value:(NSInteger)value {
	NSString *combined = [self combineDataField:field andFilter:filter];
	if (combined) {
		[self.additional setObject:@(value) forKey:combined];
	}
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"dataIds" : @"data_ids",
                                @"dataKeys" : @"data_keys",
                                @"state" : @"state",
                                @"folders" : @"folders",
                                @"sinceId" : @"since_id",
                                @"sinceTime" : @"since_time",
                                @"maxId" : @"max_id",
                                @"includeChildren" : @"include_children",
                                @"depth" : @"depth",
                                @"childrenLimit" : @"children_limit",
                                @"parentIds" : @"parent_ids",
                                @"byUser" : @"by_user",
                                @"order" : @"order",
                                @"orderBy" : @"order_by",
                                @"filter" : @"filter",
                                @"childIds" : @"child_ids" };
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

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_DataObjects_Get responseFromJSON:json];
}

- (void)setOrder:(NSString *)order {
	NSArray *acceptedValues = [self acceptedOrderValues];
	if ([acceptedValues containsObject:[order lowercaseString]]) {
		_order = order;
	}
	else if (order != nil) {
		[NSException raise:@"Wrong parameter value" format:@"Allowed values for order parameter: %@ (use kSyncanoParametersOrder constans)", acceptedValues];
	}
}

- (void)setOrderBy:(NSString *)orderBy {
	NSArray *acceptedValues = [self acceptedOrderByValues];
	if ([acceptedValues containsObject:[orderBy lowercaseString]]) {
		_orderBy = orderBy;
	}
	else if (orderBy != nil) {
		[NSException raise:@"Wrong parameter value" format:@"Allowed values for order_by parameter: %@ (use kSyncanoParametersOrderBy constans)", acceptedValues];
	}
}

- (void)setFilter:(NSString *)filter {
	NSArray *acceptedValues = [self acceptedFilterValues];
	if ([acceptedValues containsObject:[filter lowercaseString]]) {
		_filter = filter;
	}
	else if (filter != nil) {
		[NSException raise:@"Wrong parameter value" format:@"Allowed values for filter parameter: %@ (use kSyncanoParametersFilter constans)", acceptedValues];
	}
}

- (void)setState:(NSString *)state {
	NSArray *acceptedValues = [self acceptedStateValues];
	if ([acceptedValues containsObject:[state lowercaseString]]) {
		_state = state;
	}
	else if (state != nil) {
		[NSException raise:@"Wrong parameter value" format:@"Allowed values for state parameter: %@ (use kSyncanoParametersDataObjectsState constans)", acceptedValues];
	}
}

- (NSArray *)acceptedStateValues {
	return @[kSyncanoParametersDataObjectsStateModerated, kSyncanoParametersDataObjectsStatePending, kSyncanoParametersDataObjectsStateRejected];
}

- (NSArray *)acceptedOrderValues {
	return @[kSyncanoParametersOrderAsc, kSyncanoParametersOrderDesc];
}

- (NSArray *)acceptedOrderByValues {
	return @[kSyncanoParametersOrderByUpdatedAt, kSyncanoParametersOrderByCreatedAt, kSyncanoParametersDataObjectsOrderByCreatedAt, kSyncanoParametersDataObjectsOrderByData1, kSyncanoParametersDataObjectsOrderByData2, kSyncanoParametersDataObjectsOrderByData3, kSyncanoParametersDataObjectsOrderById, kSyncanoParametersDataObjectsOrderByUpdatedAt];
}

- (NSArray *)acceptedFilterValues {
	return @[kSyncanoParametersFilterImage, kSyncanoParametersFilterText];
}

@end

@implementation SyncanoParameters_DataObjects_GetOne

- (SyncanoParameters_DataObjects_GetOne *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataId:(NSString *)dataId {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionId = collectionId;
		self.dataId = dataId;
		[self validateSpecialParameters:@[@"projectId", @"collectionId", @"dataId"]];
	}
	return self;
}

- (SyncanoParameters_DataObjects_GetOne *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataKey:(NSString *)dataKey {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionId = collectionId;
		self.dataKey = dataKey;
		[self validateSpecialParameters:@[@"projectId", @"collectionId", @"dataKey"]];
	}
	return self;
}

- (SyncanoParameters_DataObjects_GetOne *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataId:(NSString *)dataId {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		self.dataId = dataId;
		[self validateSpecialParameters:@[@"projectId", @"collectionKey", @"dataId"]];
	}
	return self;
}

- (SyncanoParameters_DataObjects_GetOne *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataKey:(NSString *)dataKey {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		self.dataKey = dataKey;
		[self validateSpecialParameters:@[@"projectId", @"collectionKey", @"dataKey"]];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithProjectId:collectionId:dataId:",
	         @"initWithProjectId:collectionId:dataKey:",
	         @"initWithProjectId:collectionKey:dataId:",
	         @"initWithProjectId:collectionKey:dataKey:"];
}

- (NSString *)methodName {
	return @"data.get_one";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_DataObjects_GetOne responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
                                @"collectionId" : @"collection_id",
                                @"collectionKey" : @"collection_key",
                                @"dataId" : @"data_id",
                                @"dataKey" : @"data_key",
                                @"includeChildren" : @"include_children",
                                @"depth" : @"depth",
                                @"childrenLimit" : @"children_limit" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@interface SyncanoParameters_DataObjects_Update ()
@property (strong, nonatomic)   NSMutableDictionary *privateAdditional;
@end

@implementation SyncanoParameters_DataObjects_Update

- (NSMutableDictionary *)privateAdditional {
	if (_privateAdditional == nil) {
		_privateAdditional = [NSMutableDictionary dictionary];
	}
	return _privateAdditional;
}

- (NSString *)methodName {
	return @"data.update";
}

- (void)incrementDataField:(FilterableDataField)field byValue:(NSInteger)value {
	NSString *fieldName = fieldNameForField(field);
	if (fieldName) {
		NSString *key = [NSString stringWithFormat:@"%@__inc", fieldName];
		[self.privateAdditional setObject:@(value) forKey:key];
	}
}

- (void)decrementDataField:(FilterableDataField)field byValue:(NSInteger)value {
	NSString *fieldName = fieldNameForField(field);
	if (fieldName) {
		NSString *key = [NSString stringWithFormat:@"%@__dec", fieldName];
		[self.privateAdditional setObject:@(value) forKey:key];
	}
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_DataObjects_Update responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"updateMethod" : @"update_method",
                                @"userName" : @"user_name",
                                @"sourceUrl" : @"source_url",
                                @"title" : @"title",
                                @"text" : @"text",
                                @"link" : @"link",
                                @"imageUrl" : @"image_url",
                                @"folder" : @"folder",
                                @"parentId" : @"parent_id" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

- (NSDictionary *)dictionaryValue {
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:[super dictionaryValue]];
	if ([self.additional isKindOfClass:[NSDictionary class]]) {
		[dictionary removeObjectForKey:@"additional"];
		[dictionary addEntriesFromDictionary:self.additional];
	}
	if ([self.privateAdditional isKindOfClass:[NSDictionary class]]) {
		[dictionary removeObjectForKey:@"privateAdditional"];
		[dictionary addEntriesFromDictionary:self.privateAdditional];
	}
	return dictionary;
}

@end

@implementation SyncanoParameters_DataObjects_Move

- (NSString *)methodName {
	return @"data.move";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"dataIds" : @"data_ids",
                                @"folders" : @"folders",
                                @"byUser" : @"by_user",
                                @"limit" : @"limit",
                                @"filter" : @"filter",
                                @"folderNew" : @"new_folder",
                                @"stateNew" : @"new_state" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

- (void)setFilter:(NSString *)filter {
	NSArray *acceptedValues = [self acceptedFilterValues];
	if ([acceptedValues containsObject:[filter lowercaseString]]) {
		_filter = filter;
	}
	else {
		[NSException raise:@"Wrong parameter value" format:@"Allowed values for filter parameter: %@ (use kSyncanoParametersFilter constans)", acceptedValues];
	}
}

- (NSArray *)acceptedFilterValues {
	return @[kSyncanoParametersFilterImage, kSyncanoParametersFilterText];
}

- (void)setStateNew:(NSString *)stateNew {
	NSArray *acceptedValues = [self acceptedStateValues];
	if ([acceptedValues containsObject:[stateNew lowercaseString]]) {
		_stateNew = stateNew;
	}
	else {
		[NSException raise:@"Wrong parameter value" format:@"Allowed values for new state parameter: %@ (use kSyncanoParametersDataObjectsState constans)", acceptedValues];
	}
}

- (NSArray *)acceptedStateValues {
	return @[kSyncanoParametersDataObjectsStateModerated, kSyncanoParametersDataObjectsStatePending, kSyncanoParametersDataObjectsStateRejected];
}

@end

@implementation SyncanoParameters_DataObjects_Copy : SyncanoParameters

- (SyncanoParameters_DataObjects_Copy *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataIds:(NSArray *)dataIds {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionId = collectionId;
		self.dataIds = dataIds;
		[self validateSpecialParameters:@[@"projectId", @"collectionId", @"dataIds"]];
	}
	return self;
}

- (SyncanoParameters_DataObjects_Copy *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataIds:(NSArray *)dataIds {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		[self validateSpecialParameters:@[@"projectId", @"collectionKey", @"dataIds"]];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithProjectId:collectionId:dataIds:",
	         @"initWithProjectId:collectionKey:dataIds:"];
}

- (NSString *)methodName {
	return @"data.copy";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_DataObjects_Copy responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
                                @"collectionId" : @"collection_id",
                                @"collectionKey" : @"collection_key",
                                @"dataIds" : @"data_ids" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_DataObjects_AddParent : SyncanoParameters

- (SyncanoParameters_DataObjects_AddParent *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataId:(NSString *)dataId parentId:(NSString *)parentId {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionId = collectionId;
		self.dataId = dataId;
		self.parentId = parentId;
		[self validateSpecialParameters:@[@"projectId", @"collectionId", @"dataId", @"parentId"]];
	}
	return self;
}

- (SyncanoParameters_DataObjects_AddParent *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataId:(NSString *)dataId parentId:(NSString *)parentId {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		self.dataId = dataId;
		self.parentId = parentId;
		[self validateSpecialParameters:@[@"projectId", @"collectionKey", @"dataId", @"parentId"]];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithProjectId:collectionId:dataId:parentId:",
	         @"initWithProjectId:collectionKey:dataId:parentId:"];
}

- (NSString *)methodName {
	return @"data.add_parent";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
                                @"collectionId" : @"collection_id",
                                @"collectionKey" : @"collection_key",
                                @"dataId" : @"data_id",
                                @"parentId" : @"parent_id",
                                @"removeOther" : @"remove_other" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_DataObjects_RemoveParent : SyncanoParameters

- (SyncanoParameters_DataObjects_RemoveParent *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataId:(NSString *)dataId  {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionId = collectionId;
		self.dataId = dataId;
		[self validateSpecialParameters:@[@"projectId", @"collectionId", @"dataId"]];
	}
	return self;
}

- (SyncanoParameters_DataObjects_RemoveParent *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataId:(NSString *)dataId {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		self.dataId = dataId;
		[self validateSpecialParameters:@[@"projectId", @"collectionKey", @"dataId"]];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithProjectId:collectionId:dataId:",
	         @"initWithProjectId:collectionKey:dataId:"];
}

- (NSString *)methodName {
	return @"data.remove_parent";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
                                @"collectionId" : @"collection_id",
                                @"collectionKey" : @"collection_key",
                                @"dataId" : @"data_id",
                                @"parentId" : @"parent_id" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_DataObjects_AddChild : SyncanoParameters

- (SyncanoParameters_DataObjects_AddChild *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataId:(NSString *)dataId childId:(NSString *)childId {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionId = collectionId;
		self.dataId = dataId;
		self.childId = childId;
		[self validateSpecialParameters:@[@"projectId", @"collectionId", @"dataId", @"childId"]];
	}
	return self;
}

- (SyncanoParameters_DataObjects_AddChild *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataId:(NSString *)dataId childId:(NSString *)childId {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		self.dataId = dataId;
		self.childId = childId;
		[self validateSpecialParameters:@[@"projectId", @"collectionKey", @"dataId", @"childId"]];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithProjectId:collectionId:dataId:childId:",
	         @"initWithProjectId:collectionKey:dataId:childId:"];
}

- (NSString *)methodName {
	return @"data.add_child";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
                                @"collectionId" : @"collection_id",
                                @"collectionKey" : @"collection_key",
                                @"dataId" : @"data_id",
                                @"childId" : @"child_id",
                                @"removeOther" : @"remove_other" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_DataObjects_RemoveChild : SyncanoParameters

- (SyncanoParameters_DataObjects_RemoveChild *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataId:(NSString *)dataId  {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionId = collectionId;
		self.dataId = dataId;
		[self validateSpecialParameters:@[@"projectId", @"collectionId", @"dataId"]];
	}
	return self;
}

- (SyncanoParameters_DataObjects_RemoveChild *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataId:(NSString *)dataId {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		self.dataId = dataId;
		[self validateSpecialParameters:@[@"projectId", @"collectionKey", @"dataId"]];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithProjectId:collectionId:dataId:",
	         @"initWithProjectId:collectionKey:dataId:"];
}

- (NSString *)methodName {
	return @"data.remove_child";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
                                @"collectionId" : @"collection_id",
                                @"collectionKey" : @"collection_key",
                                @"dataId" : @"data_id",
                                @"childId" : @"child_id" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_DataObjects_Delete

- (NSString *)methodName {
	return @"data.delete";
}

- (void)setFilter:(NSString *)filter {
	NSArray *acceptedValues = [self acceptedFilterValues];
	if ([acceptedValues containsObject:[filter lowercaseString]]) {
		_filter = filter;
	}
	else {
		[NSException raise:@"Wrong parameter value" format:@"Allowed values for filter parameter: %@ (use kSyncanoParametersFilter constans)", acceptedValues];
	}
}

- (NSArray *)acceptedFilterValues {
	return @[kSyncanoParametersFilterImage, kSyncanoParametersFilterText];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"dataIds" : @"data_ids",
                                @"folders" : @"folders",
                                @"byUser" : @"by_user",
                                @"limit" : @"limit",
                                @"filter" : @"filter" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_DataObjects_Count

- (NSString *)methodName {
	return @"data.count";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_DataObjects_Count responseFromJSON:json];
}

- (void)setFilter:(NSString *)filter {
	NSArray *acceptedValues = [self acceptedFilterValues];
	if ([acceptedValues containsObject:[filter lowercaseString]]) {
		_filter = filter;
	}
	else {
		[NSException raise:@"Wrong parameter value" format:@"Allowed values for filter parameter: %@ (use kSyncanoParametersFilter constans)", acceptedValues];
	}
}

- (NSArray *)acceptedFilterValues {
	return @[kSyncanoParametersFilterImage, kSyncanoParametersFilterText];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"folders" : @"folders",
                                @"byUser" : @"by_user" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end
