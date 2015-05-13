//
//  SyncanoResponse.m
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse.h"
#import "SyncanoResponse_Private.h"

#import <objc/runtime.h>

#import "SyncanoDateFormatter.h"
#import "SyncanoObjects.h"

NSString *const SYNCANO_RESPONSE_ERROR_DOMAIN = @"SYNCANO_RESPONSE_ERROR_DOMAIN";
NSString *const SYNCANO_UNDEFINED_ERROR = @"SYNCANO_UNDEFINED_ERROR: NOK";

@implementation SyncanoResponse

- (id)init {
  self = [super init];
  if (self) {
    self.error = nil;
    self.responseOK = NO;
  }
  return self;
}

- (void)checkAndSetError {
  NSDictionary *result = self.json[@"result"];
  if (result && [result isKindOfClass:[NSDictionary class]] == NO) {
    result = @{ @"result":result };
  }
  NSString *resultCode = result[@"result"];
  NSString *errorText = nil;
  BOOL isStatusOK = [resultCode isEqualToString:@"OK"];
  self.responseOK = isStatusOK;
  if (isStatusOK) {
    errorText = nil;
  }
  else {
    errorText = result[@"error"];
    if (errorText == nil) {
      errorText = result[@"data"][@"error"];
    }
    errorText = (errorText.length > 0) ? errorText : SYNCANO_UNDEFINED_ERROR;
    self.error = [NSError errorWithDomain:SYNCANO_RESPONSE_ERROR_DOMAIN code:0 userInfo:@{ NSLocalizedDescriptionKey:errorText }];
  }
}

+ (instancetype)responseFromJSON:(NSDictionary *)json {
  SyncanoResponse *response = [[self alloc] init];
  response.json = json;
  [response checkAndSetError];
  NSDictionary *jsonContent = json;
  if (json[@"result"] != nil) {
    jsonContent = json[@"result"];
  }
  if ([jsonContent isKindOfClass:[NSArray class]] == NO
      && [jsonContent isKindOfClass:[NSDictionary class]] == NO
      && json[@"data"] != nil) {
    jsonContent = json[@"data"];
  }
  for (NSString *key in [jsonContent allKeys]) {
    if (![key isEqualToString:@"error"])
      [response setValue:jsonContent[key] forKey:key];
  }
  return response;
}

- (BOOL)isKeyDate:(NSString *)key {
  return NO;
}

- (BOOL)isKeyArray:(NSString *)key {
  return NO;
}

- (Class)classForKey:(NSString *)key {
  return nil;
}

- (void)setValueAsDate:(id)value forKey:(NSString *)key {
  [self setValue:[SyncanoDateFormatter dateFromTextWithConstFormatWithoutUsingFormatter:value] forKey:key];
}

- (void)setValueAsClassForDictionary:(id)value forKey:(NSString *)key {
  Class class = [self classForKey:key];
  SyncanoObject *obj = nil;
  if ([class respondsToSelector:@selector(objectFromJSON:)]) {
    obj = [class performSelector:@selector(objectFromJSON:) withObject:value];
  }
  [self setValue:obj forKey:key];
}

- (void)setValueAsArray:(id)value forKey:(NSString *)key {
  NSArray *jsonArray = (NSArray *)value;
  if (jsonArray == nil || jsonArray.count == 0) {
    [super setValue:@[] forKey:key];
    return;
  }
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:jsonArray.count];
  for (id objectInArray in jsonArray) {
    Class class = [self classForKey:key];
    SyncanoObject *syncanoObject = nil;
    if ([class respondsToSelector:@selector(objectFromJSON:)]) {
      syncanoObject = [class performSelector:@selector(objectFromJSON:) withObject:objectInArray];
    }
    if (syncanoObject) {
      [array addObject:syncanoObject];
    }
  }
  [self setValue:[array copy] forKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key {
  BOOL isKeyDate = [self isKeyDate:key];
  BOOL isKeyArray = [self isKeyArray:key];
  BOOL isValueNULL = (value == [NSNull null]);
  BOOL isValueDictionary = ([value isKindOfClass:[NSDictionary class]]);
  BOOL isValueArray = ([value isKindOfClass:[NSArray class]]);
  Class classForKey = [self classForKey:key];
  
  if (isValueNULL) {
    [self setValue:nil forKey:key];
  }
  else if (isKeyDate && value && [value isKindOfClass:[NSDate class]] == NO) {
    [self setValueAsDate:value forKey:key];
  }
  else if (isValueDictionary && value && classForKey != nil) {
    [self setValueAsClassForDictionary:value forKey:key];
  }
  else if (isValueArray && value && classForKey != nil && [[((NSArray *)value)lastObject] isKindOfClass:[SyncanoObject class]] == NO) {
    [self setValueAsArray:value forKey:key];
  }
  else if (isKeyArray && value && isValueArray == NO) {
    [self setValue:@[value] forKey:key];
  }
  else {
    [super setValue:value forKey:key];
  }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  // Normally that's a bad situation, but we constructed the library it can happen often and it's not an error at all.
  // We should probably still notify about it, but'll just log it internally when needed, it's not needed to notify other users about it.
  //	SyncanoDebugLog(@"[%@]: Undefined key: %@, value: %@", [self class], key, value);
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
  NSMutableString *description = [NSMutableString stringWithFormat:@"[%@: %@, Error: %@", self.class, (self.responseOK) ? @"OK":@"NOK", self.error];
  for (NSString *propertyName in[self allPropertyNames]) {
    id valueForKey = [self valueForKey:propertyName];
    [description appendFormat:@", %@: %@", propertyName, (valueForKey) ? valueForKey:@"nil"];
  }
  [description appendString:@"]"];
  return description;
}

//- (NSString *)description {
//    return [NSString stringWithFormat:@"[SyncanoResponse: %@, Error: %@, JSON:%@]",(self.responseOK)?@"OK":@"NOK",self.error,self.json];
//}

@end
