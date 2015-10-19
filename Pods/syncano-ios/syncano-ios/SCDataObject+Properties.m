//
//  SCDataObject+Properties.m
//  syncano-ios
//
//  Created by Jan Lipmann on 11/09/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCDataObject+Properties.h"
#import <objc/runtime.h>

@implementation SCDataObject (Properties)

+ (NSArray *)propertiesNamesOfFileClass {
    NSMutableArray *result = [NSMutableArray new];
    NSDictionary *classesOfProperties = [self classesOfProperties];
    for (NSString *property in classesOfProperties.allKeys) {
        NSString *className = classesOfProperties[property];
        if ([className isEqualToString:@"SCFile"]) {
            [result addObject:property];
        }
    }
    return result;
}

+ (NSDictionary *)classesOfProperties {
    NSMutableDictionary *results = [NSMutableDictionary new];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            NSString* propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
            NSArray* splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@"\""];
            if ([splitPropertyAttributes count] >= 2)
            {
                NSString *className = [splitPropertyAttributes objectAtIndex:1];
                results[propertyName] = className;
            }
        }
    }
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:results];
}

@end
