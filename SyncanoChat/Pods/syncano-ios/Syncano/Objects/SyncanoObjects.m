//
//  SyncanoObjects.m
//  Syncano
//
//  Created by Syncano Inc. on 08/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoObjects.h"
#import "SyncanoObjects_Private.h"
#import "SyncanoDateFormatter.h"
#import <Mantle/MTLValueTransformer.h>
#import <objc/runtime.h>

@implementation SyncanoObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{};
}

+ (instancetype)objectFromJSON:(NSDictionary *)json {
	return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:json error:nil];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
	// Normally that's a bad situation, but we constructed the library it can happen often and it's not an error at all.
    // We should probably still notify about it, but'll just log it internally when needed, it's not needed to notify other users about it.
    //SyncanoDebugLog(@"[%@]: Undefined key: %@, value: %@", [self class], key, value);
}

- (id)valueForUndefinedKey:(NSString *)key {
    // Normally that's a bad situation, but we constructed the library it can happen often and it's not an error at all.
    // We should probably still notify about it, but'll just log it internally when needed, it's not needed to notify other users about it.
	//SyncanoDebugLog(@"[%@]: Asked for Undefined key: %@", [self class], key);
	return nil;
}

- (NSArray *)allPropertyNames {
	unsigned count;
	objc_property_t *properties = class_copyPropertyList([self class], &count);
  
	NSMutableArray *propertyNames = [NSMutableArray array];
  
	unsigned i;
	for (i = 0; i < count; i++) {
		objc_property_t property = properties[i];
		NSString *name = [NSString stringWithUTF8String:property_getName(property)];
		[propertyNames addObject:name];
	}
  
	free(properties);
  
	return propertyNames;
}

- (NSString *)description {
	NSMutableString *description = [NSMutableString stringWithFormat:@"[%@", self.class];
	for (NSString *propertyName in[self allPropertyNames]) {
		id valueForKey = [self valueForKey:propertyName];
		[description appendFormat:@", %@: %@", propertyName, (valueForKey) ? valueForKey:@"nil"];
	}
	[description appendString:@"]"];
	return description;
}

+ (NSValueTransformer *)createdAtJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock: ^(NSString *str) {
    return [SyncanoDateFormatter dateFromTextWithConstFormatWithoutUsingFormatter:str];
	} reverseBlock: ^(NSDate *date) {
    return [[SyncanoDateFormatter sharedDateFormatter] stringFromDate:date];
	}];
}

+ (NSValueTransformer *)updatedAtJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock: ^(NSString *str) {
    return [SyncanoDateFormatter dateFromTextWithConstFormatWithoutUsingFormatter:str];
	} reverseBlock: ^(NSDate *date) {
    return [[SyncanoDateFormatter sharedDateFormatter] stringFromDate:date];
	}];
}

+ (NSValueTransformer *)sinceTimeJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock: ^(NSString *str) {
    return [SyncanoDateFormatter dateFromTextWithConstFormatWithoutUsingFormatter:str];
	} reverseBlock: ^(NSDate *date) {
    return [[SyncanoDateFormatter sharedDateFormatter] stringFromDate:date];
	}];
}

@end

@implementation SyncanoClient : SyncanoObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
	self = [super initWithDictionary:dictionaryValue error:error];
	if (self) {
		if ([dictionaryValue syncano_notNullObjectForKey:@"role"]) {
			self.role = [MTLJSONAdapter modelOfClass:[SyncanoRole class] fromJSONDictionary:[dictionaryValue syncano_notNullObjectForKey:@"role"] error:nil];
		}
	}
	return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
           @"uid" : @"id",
           @"descriptionString" : @"description",
           @"apiKey" : @"api_key",
           };
}

@end

@implementation SyncanoApiKey : SyncanoObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
	self = [super initWithDictionary:dictionaryValue error:error];
	if (self) {
		if ([dictionaryValue syncano_notNullObjectForKey:@"role"]) {
			self.role = [MTLJSONAdapter modelOfClass:[SyncanoRole class] fromJSONDictionary:[dictionaryValue syncano_notNullObjectForKey:@"role"] error:nil];
		}
	}
	return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
           @"uid" : @"id",
           @"descriptionString" : @"description",
           @"apiKey" : @"api_key",
           @"type" : @"type"
           };
}

@end


@implementation SyncanoConnection : SyncanoObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
           @"uid" : @"id",
           @"apiClientId" : @"api_client_id",
           @"uuid" : @"uuid",
           @"name" : @"name",
           @"state" : @"state",
           @"source" : @"source"
           };
}

@end

@implementation SyncanoProject : SyncanoObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
           @"uid" : @"id",
           @"name" : @"name",
           @"descriptionString" : @"description"
           };
}

@end

@implementation SyncanoCollection : SyncanoObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
           @"uid" : @"id",
           @"status" : @"status",
           @"name" : @"name",
           @"descriptionString" : @"description",
           @"key" : @"key",
           @"startDate" : @"start_date",
           @"endDate" : @"end_date",
           @"tags" : @"tags"
           };
}

@end

@implementation SyncanoFolder : SyncanoObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
           @"uid" : @"id",
           @"isCustom" : @"is_custom",
           @"name" : @"name",
           @"sourceId" : @"source_id"
           };
}

@end

@implementation SyncanoAvatar : SyncanoObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
           @"image" : @"image",
           @"imageWidth" : @"image_width",
           @"imageHeight" : @"image_height",
           @"thumbnail" : @"thumbnail",
           @"thumbnailWidth" : @"thumbnail_width",
           @"thumbnailHeight" : @"thumbnail_height"
           };
}

@end

@implementation SyncanoImage : SyncanoObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
           @"image" : @"image",
           @"imageWidth" : @"image_width",
           @"imageHeight" : @"image_height",
           @"thumbnail" : @"thumbnail",
           @"thumbnailWidth" : @"thumbnail_width",
           @"thumbnailHeight" : @"thumbnail_height",
           @"sourceUrl" : @"source_url"
           };
}

@end

@implementation SyncanoUser : SyncanoObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
	self = [super initWithDictionary:dictionaryValue error:error];
	if (self) {
		if ([dictionaryValue syncano_notNullObjectForKey:@"avatar"]) {
			self.avatar = [MTLJSONAdapter modelOfClass:[SyncanoAvatar class] fromJSONDictionary:[dictionaryValue syncano_notNullObjectForKey:@"avatar"] error:nil];
		}
	}
	return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
           @"uid" : @"id",
           @"name" : @"name",
           @"nick" : @"nick"
           };
}

- (NSString *)displayedName {
	return self.nick ? self.nick : self.name;
}

@end

@implementation SyncanoData : SyncanoObject


- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
	self = [super initWithDictionary:dictionaryValue error:error];
	if (self) {
		if ([dictionaryValue syncano_notNullObjectForKey:@"user"]) {
			self.user = [MTLJSONAdapter modelOfClass:[SyncanoUser class] fromJSONDictionary:[dictionaryValue syncano_notNullObjectForKey:@"user"] error:nil];
		}
    
		if ([dictionaryValue syncano_notNullObjectForKey:@"image"]) {
			self.image = [MTLJSONAdapter modelOfClass:[SyncanoImage class] fromJSONDictionary:[dictionaryValue syncano_notNullObjectForKey:@"image"] error:nil];
		}
    
		if ([dictionaryValue syncano_notNullObjectForKey:@"children"]) {
			NSMutableArray *children = [[NSMutableArray alloc] init];
      
			for (NSDictionary *child in[dictionaryValue syncano_notNullObjectForKey:@"children"]) {
				[children addObject:[MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:child error:nil]];
			}
			self.children = children;
		}
	}
	return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
           @"uid" : @"id",
           @"parentId" : @"parent_id",
           @"childId" : @"child_id",
           @"createdAt" : @"created_at",
           @"updatedAt" : @"updated_at",
           @"folder" : @"folder",
           @"state" : @"state",
           @"key" : @"key",
           @"title" : @"title",
           @"text" : @"text",
           @"link" : @"link",
           @"sourceUrl" : @"source_url",
           @"additional" : @"additional",
           @"childrenCount" : @"children_count",
           @"data1" : @"data1",
           @"data2" : @"data2",
           @"data3" : @"data3"
           };
}

@end

@implementation SyncanoDataRelation
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"parentId" : @"parent_id",
             @"childId" : @"child_id",
             };
}
@end

@interface SyncanoDataChanges () <NSCopying>
@property (strong)    NSArray *replacedKeys;
@property (strong)    NSArray *deletedKeys;
@property (strong)    NSArray *addedKeys;
@property (strong)    NSArray *replacedProperties;
@property (strong)    NSArray *deletedProperties;
@property (strong)    NSArray *addedProperties;
@end
@implementation SyncanoDataChanges
+ (void)fillObject:(id)object withJSON:(NSDictionary *)json {
	for (id key in[json allKeys]) {
		[object setValue:[json objectForKey:key] forKey:key];
	}
}

+ (void)fillObject:(id)object usingMantleKeyValuePairsWithJSON:(NSDictionary *)json {
	NSDictionary *mantleDictionary = [self JSONKeyPathsByPropertyKey];
	[mantleDictionary enumerateKeysAndObjectsWithOptions:0 usingBlock: ^(id objectKey, id jsonKey, BOOL *stop) {
    id value = [json objectForKey:jsonKey];
    if (value) {
      [object setValue:value forKey:objectKey];
		}
	}];
}

+ (NSArray *)valuesForKeys:(NSArray *)keys forObject:(id)object {
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:keys.count];
	for (NSString *key in keys) {
		id objectForKey = [object valueForKey:key];
		if (objectForKey) {
			[values addObject:objectForKey];
		}
	}
	return values;
}

+ (NSArray *)properObjectKeysUsingMantleKeyValuePairsFromJSONKeys:(NSArray *)jsonKeys {
	NSMutableArray *objectKeys = [NSMutableArray arrayWithCapacity:jsonKeys.count];
	NSDictionary *mantleDictionary = [self JSONKeyPathsByPropertyKey];
	[mantleDictionary enumerateKeysAndObjectsWithOptions:0 usingBlock: ^(id objectKey, id jsonKey, BOOL *stop) {
    if ([jsonKeys containsObject:jsonKey]) {
      [objectKeys addObject:objectKey];
		}
	}];
	return [objectKeys copy];
}

+ (instancetype)objectFromJSON:(NSDictionary *)json {
	SyncanoDataChanges *object = [[self alloc] init];
	NSDictionary *dataJSON = json[@"data"];
	NSDictionary *addedJSON = json[@"add"];
	NSDictionary *replacedJSON = json[@"replace"];
	[self fillObject:object usingMantleKeyValuePairsWithJSON:dataJSON];
	[self fillObject:object usingMantleKeyValuePairsWithJSON:addedJSON];
	[self fillObject:object usingMantleKeyValuePairsWithJSON:replacedJSON];
	NSMutableArray *replacedKeys = [[self properObjectKeysUsingMantleKeyValuePairsFromJSONKeys:[replacedJSON allKeys]] mutableCopy];
	NSMutableArray *deletedKeys = [[self properObjectKeysUsingMantleKeyValuePairsFromJSONKeys:json[@"delete"]] mutableCopy];
	NSMutableArray *addedKeys = [[self properObjectKeysUsingMantleKeyValuePairsFromJSONKeys:[addedJSON allKeys]] mutableCopy];
	NSMutableArray *replacedProperties = [[self valuesForKeys:replacedKeys forObject:object] mutableCopy];
	NSMutableArray *deletedProperties = [[self valuesForKeys:deletedKeys forObject:object] mutableCopy];
	NSMutableArray *addedProperties = [[self valuesForKeys:addedKeys forObject:object] mutableCopy];
	NSDictionary *additionalAdded = json[@"additional"][@"add"];
	NSArray *additionalDeleted = json[@"additional"][@"delete"];
	NSDictionary *additionalReplaced = json[@"additional"][@"replace"];
	NSMutableDictionary *allAdditionals = [NSMutableDictionary dictionaryWithCapacity:(additionalAdded.count + additionalReplaced.count + additionalDeleted.count)];
	for (id key in[additionalAdded allKeys]) {
		id object = additionalAdded[key];
		[allAdditionals setObject:object forKey:key];
		[addedKeys addObject:key];
		[addedProperties addObject:object];
	}
	for (id key in[additionalReplaced allKeys]) {
		id object = additionalReplaced[key];
		[allAdditionals setObject:object forKey:key];
		[replacedKeys addObject:key];
		[replacedProperties addObject:object];
	}
	for (id key in additionalDeleted) {
		[allAdditionals setObject:[NSNull null] forKey:key];
		[deletedKeys addObject:key];
		[deletedProperties addObject:[NSNull null]];
	}
	for (id key in deletedKeys) {
        if ([key isEqualToString:@"data1"] || [key isEqualToString:@"data2"] || [key isEqualToString:@"data3"]) {
            [object setValue:@(NSNotFound) forKey:key];
        } else {
            [object setValue:[NSNull null] forKey:key];
        }
		[deletedProperties addObject:[NSNull null]];
	}
	object.additional = allAdditionals;
	object.addedKeys = addedKeys;
	object.replacedKeys = replacedKeys;
	object.deletedKeys = deletedKeys;
	object.addedProperties = addedProperties;
	object.replacedProperties = replacedProperties;
	object.deletedProperties = deletedProperties;
  
	return object;
}

- (NSArray *)getReplaced {
	return self.replacedKeys;
}

- (NSArray *)getDeleted {
	return self.deletedKeys;
}

- (NSArray *)getAdded {
	return self.addedKeys;
}

- (SyncanoChange)getChange:(id)property {
	SyncanoChange change = SyncanoChange_NO_CHANGE;
	if ([self.replacedProperties containsObject:property]) {
		change = SyncanoChange_REPLACE;
	}
	else if ([self.addedProperties containsObject:property]) {
		change = SyncanoChange_ADDED;
	}
	else if ([self.deletedProperties containsObject:property]) {
		change = SyncanoChange_DELETED;
	}
	return change;
}

- (id)copyWithZone:(NSZone *)zone {
	SyncanoDataChanges *aCopy = [super copyWithZone:zone];
	aCopy.replacedKeys = [self.replacedKeys copy];
	aCopy.deletedKeys = [self.deletedKeys copy];
	aCopy.addedKeys = [self.addedKeys copy];
	aCopy.replacedProperties = [[self class] valuesForKeys:aCopy.replacedKeys forObject:aCopy];
	aCopy.replacedProperties = [aCopy.replacedProperties arrayByAddingObjectsFromArray:[[self class] valuesForKeys:aCopy.replacedKeys forObject:aCopy.additional]];
	aCopy.deletedProperties = [[self class] valuesForKeys:aCopy.deletedKeys forObject:aCopy];
	aCopy.deletedProperties = [aCopy.deletedProperties arrayByAddingObjectsFromArray:[[self class] valuesForKeys:aCopy.deletedKeys forObject:aCopy.additional]];
	aCopy.addedProperties = [[self class] valuesForKeys:aCopy.addedKeys forObject:aCopy];
	aCopy.addedProperties = [aCopy.addedProperties arrayByAddingObjectsFromArray:[[self class] valuesForKeys:aCopy.addedKeys forObject:aCopy.additional]];
	return aCopy;
}

@end

@implementation SyncanoSubscription

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
           @"uid" : @"id",
           @"type" : @"type",
           @"context" : @"context"
           };
}

@end

@implementation SyncanoRole

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
           @"uid" : @"id",
           @"name" : @"name"
           };
}

@end

@implementation SyncanoAdmin

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
	self = [super initWithDictionary:dictionaryValue error:error];
	if (self) {
		if ([dictionaryValue syncano_notNullObjectForKey:@"role"]) {
			self.role = [MTLJSONAdapter modelOfClass:[SyncanoRole class] fromJSONDictionary:[dictionaryValue syncano_notNullObjectForKey:@"role"] error:nil];
		}
	}
	return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
           @"uid" : @"id",
           @"email" : @"email",
           @"firstName" : @"first_name",
           @"lastName" : @"last_name",
           @"lastLogin" : @"last_login",
           };
}

@end

@implementation SyncanoChannel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
           @"projectId" : @"project_id",
           @"collectionId" : @"collection_id",
           @"folder" : @"folder",
           @"parentFolder" : @"parent_folder",
           @"childFolder" : @"child_folder"
           };
}

@end
