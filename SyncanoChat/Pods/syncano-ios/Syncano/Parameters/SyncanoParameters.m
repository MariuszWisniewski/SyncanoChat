//
//  SyncanoParameters.m
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters.h"
#import "SyncanoParameters_Private.h"

#import "SyncanoResponse.h"

#import "SyncanoDateFormatter.h"

#import <objc/runtime.h>

NSString *const SYNCANO_PARAMETERS_KEY_METHOD_NAME = @"method";

NSString *const kSyncanoParametersOrderAsc = @"asc";
NSString *const kSyncanoParametersOrderDesc = @"desc";

NSString *const kSyncanoParametersOrderByCreatedAt = @"created_at";
NSString *const kSyncanoParametersOrderByUpdatedAt = @"updated_at";

NSString *const kSyncanoParametersFilterText = @"text";
NSString *const kSyncanoParametersFilterImage = @"image";

@interface SyncanoParameters ()

@end

@implementation SyncanoParameters

- (NSMutableDictionary *)parameters {
	if (_parameters == nil) {
		_parameters = [NSMutableDictionary dictionaryWithCapacity:32];
	}
	return _parameters;
}

- (id)init {
	self = [super init];
	if (self) {
		_timezone = @"UTC";
    
#ifdef DEBUG
		NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
		NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
		NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString componentsSeparatedByCharactersInSet:separatorSet]];
		[array removeObject:@""];
    
		// get index containing memory address, i.e. hex number with at least 8 digits
		static NSRegularExpression *regex = nil;
		if (!regex) {
			regex = [NSRegularExpression regularExpressionWithPattern:@"0x\\p{Hex_Digit}{8}+" options:0 error:nil];
		}
		NSUInteger addressIndex = [array indexOfObjectPassingTest: ^BOOL (NSString *string, NSUInteger idx, BOOL *stop) {
      NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
      return !!matches.count;
		}];
    
		// two indexes "further", theres selector string
		NSString *selectorString = [array objectAtIndex:addressIndex + 2];
		NSArray *initalizeSelectorNames = [[self initializeSelectorNamesArray] arrayByAddingObjectsFromArray:[self baseInitializeSelectorNamesArray]];
		SEL initalizeSelector = NSSelectorFromString(selectorString);
    
		if (self.initalizeSelector) {
			if (initalizeSelector != self.initalizeSelector) {
				[NSException raise:@"Invaild initalization" format:@"Use: %@ for initalization", NSStringFromSelector(self.initalizeSelector)];
			}
      
			if (!self.requiredParametersNames) {
				[NSException raise:@"Bad implementation" format:@"%@ has unique init method (%@) and 0 required parameters, implemement requiredParametersNames method", NSStringFromClass(self.class), NSStringFromSelector(self.initalizeSelector)];
			}
		}
		else if (initalizeSelectorNames && [initalizeSelectorNames count] > 0) {
			if (![initalizeSelectorNames containsObject:selectorString]) {
				NSString *allowedSelectors = [initalizeSelectorNames componentsJoinedByString:@" or "];
				[NSException raise:@"Invaild initalization" format:@"Use: %@ for initalization %@ class", allowedSelectors, NSStringFromClass(self.class)];
			}
		}
#endif
	}
	return self;
}

- (void)validateParameters {
	[self validateSpecialParameters:self.requiredParametersNames];
}

- (void)validateSpecialParameters:(NSArray *)parameters {
	if (parameters) {
		[parameters enumerateObjectsUsingBlock: ^(NSString *selectorString, NSUInteger idx, BOOL *stop) {
      SEL selector  = NSSelectorFromString(selectorString);
      
      // selector not existing is an exceptional situation (NSException-exceptional, in fact)
      // considering that exception gets raised anyway, we can care less about possible leak
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
      if ([self respondsToSelector:selector]) {
        if (![self performSelector:selector]) {
          [NSException raise:@"Wrong value" format:@"parameter %@ in %@ class cannot be nil", selectorString, NSStringFromClass(self.class)];
				}
			}
      else {
        [NSException raise:@"Wrong validate parameter" format:@"%@ does not respond to %@, check implementation", NSStringFromClass(self.class), selectorString];
			}
#pragma clang diagnostic pop
		}];
	}
}

- (NSArray *)requiredParametersNames {
	return nil;
}

- (SEL)initalizeSelector {
	return nil;
}

- (NSArray *)baseInitializeSelectorNamesArray {
  return @[
           NSStringFromSelector(@selector(copyWithZone:))
           ];
}

- (NSArray *)initializeSelectorNamesArray {
  return nil;
}

- (NSString *)methodName {
	return nil;
}

- (NSDictionary *)jsonRPCPostDictionaryForJsonRPCId:(NSNumber *)jsonrpcId {
	NSMutableDictionary *params = [self removeNullValuesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:self]];
	params = [self checkImageDataForDictionary:params];
  
	NSMutableDictionary *postParameters = [NSMutableDictionary dictionaryWithCapacity:3];
	[postParameters setObject:jsonrpcId forKey:@"id"];
	[postParameters setObject:@"2.0" forKey:@"jsonrpc"];
	[postParameters setObject:params forKey:@"params"];
	if ([self methodName]) {
		[postParameters setObject:[self methodName] forKey:SYNCANO_PARAMETERS_KEY_METHOD_NAME];
	}
	return postParameters;
}

- (NSMutableDictionary *)removeNullValuesFromDictionary:(NSDictionary *)dictionary {
	NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] init];
  
	[[dictionary allKeys] enumerateObjectsUsingBlock: ^(NSString *key, NSUInteger idx, BOOL *stop) {
    id value = [dictionary objectForKey:key];
    
    if ([value isKindOfClass:[NSNull class]]) {
      return;
		}
    
    if ([value isKindOfClass:[NSArray class]]) {
      if ([value count] == 0) return;
		}
    
    if ([value isKindOfClass:[NSDictionary class]]) {
      if ([[value allKeys] count] == 0) return;
		}
    
    [newDictionary setObject:[dictionary objectForKey:key] forKey:key];
	}];
  
	return newDictionary;
}

- (NSMutableDictionary *)checkImageDataForDictionary:(NSMutableDictionary *)dictionary {
	
  [[dictionary copy] enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL *stop) {
    if ([obj isKindOfClass:[UIImage class]]) {
      UIImage *image = (UIImage *)obj;
      NSString *data = [self base64EncodedData:[self imageData:image]];
			[dictionary setObject:data forKey:key];
    }
  }];
  
	return dictionary;
}

- (NSMutableDictionary *)jsonRPCMutablePostDictionaryForJsonRPCId:(NSNumber *)jsonrpcId {
	return [[self jsonRPCPostDictionaryForJsonRPCId:jsonrpcId] mutableCopy];
}

- (NSDictionary *)syncServerDictionaryForMessageId:(NSNumber *)messageId {
	NSMutableDictionary *params = [self removeNullValuesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:self]];
	params = [self checkImageDataForDictionary:params];
  
	NSMutableDictionary *postParameters = [NSMutableDictionary dictionaryWithCapacity:4];
	[postParameters setObject:messageId forKey:@"message_id"];
	[postParameters setObject:params forKey:@"params"];
	[postParameters setObject:@"call" forKey:@"type"];
	if ([self methodName]) {
		[postParameters setObject:[self methodName] forKey:SYNCANO_PARAMETERS_KEY_METHOD_NAME];
	}
	return postParameters;
}

- (NSMutableDictionary *)syncServerMutableDictionaryForMessageId:(NSNumber *)messageId {
	return [[self syncServerDictionaryForMessageId:messageId] mutableCopy];
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{ @"apiKey" : @"api_key",
            @"timezone" : @"timezone",
            @"sessionId" : @"sessionId",
            @"authKey" : @"auth_key" };
}

#pragma mark - Private Methods
/*
 Private Methods
 */

- (NSData *)imageJPEGData:(UIImage *)image compression:(CGFloat)compression {
	return UIImageJPEGRepresentation(image, compression);
}

- (NSData *)imagePNGData:(UIImage *)image {
	return UIImagePNGRepresentation(image);
}

- (NSData *)imageData:(UIImage *)image {
	return [self imageJPEGData:image compression:0.8f];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (NSString *)base64EncodedData:(NSData *)data {
	NSString *base64EncodedString = nil;
	if ([data respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
		base64EncodedString = [data base64EncodedStringWithOptions:0];
	}
	else {
		base64EncodedString = [data base64Encoding];
	}
	return base64EncodedString;
}

#pragma clang diagnostic pop

- (NSArray *)allPropertyNames {
	NSMutableArray *propertyNames = [NSMutableArray array];
  
	Class currentClass = [self class];
  
	while (![NSStringFromClass(currentClass) isEqualToString:@"NSObject"]) {
		[propertyNames addObjectsFromArray:[self propertiesForClass:currentClass]];
		currentClass = [currentClass superclass];
	}
  
	[propertyNames removeObject:@"parameters"];
  
	return propertyNames;
}

- (NSArray *)propertiesForClass:(Class)class {
	unsigned count;
  
	NSMutableArray *propertyNames = [NSMutableArray array];
  
	objc_property_t *properties = class_copyPropertyList(class, &count);
  
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
	NSMutableDictionary *params = [self removeNullValuesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:self]];
	params = [self checkImageDataForDictionary:params];
  
	NSMutableString *description = [NSMutableString stringWithFormat:@"[%@", self.class];
	[description appendString:[params description]];
	[description appendString:@"]"];
	return description;
}

+ (NSMutableDictionary *)mergeSuperParameters:(NSDictionary *)superParameters parameters:(NSDictionary *)parameters {
	NSMutableDictionary *newSuperParameters = [NSMutableDictionary dictionaryWithDictionary:superParameters];
	[newSuperParameters addEntriesFromDictionary:parameters];
	return newSuperParameters;
}

#pragma mark - protocol NSCopying

- (id)copyWithZone:(NSZone *)zone {
	id copiedParams = [[[self class] alloc] init];
	NSArray *allPropertyNames = [self allPropertyNames];
  for (NSString *propertyName in allPropertyNames) {
    id selfValue = [self valueForKey:propertyName];
    [copiedParams setValue:selfValue forKey:propertyName];
	}
	return copiedParams;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  
}

@end


@implementation SyncanoParameters_ProjectId_CollectionId_CollectionKey

- (SyncanoParameters_ProjectId_CollectionId_CollectionKey *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionId = collectionId;
		[self validateSpecialParameters:@[@"projectId", @"collectionId"]];
	}
	return self;
}

- (SyncanoParameters_ProjectId_CollectionId_CollectionKey *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey {
	self = [super init];
	if (self) {
		self.projectId = projectId;
		self.collectionKey = collectionKey;
		[self validateSpecialParameters:@[@"projectId", @"collectionKey"]];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithProjectId:collectionId:",
	         @"initWithProjectId:collectionKey:"];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"projectId" : @"project_id",
                                @"collectionId" : @"collection_id",
                                @"collectionKey" : @"collection_key" };
  
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end
