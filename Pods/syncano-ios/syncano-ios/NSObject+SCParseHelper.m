//
//  NSObject+SCParseHelper.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 12/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "NSObject+SCParseHelper.h"

@implementation NSObject (SCParseHelper)
- (NSString *)sc_stringOrEmpty {
    if ([self isKindOfClass:[NSString class]] && (self != [NSNull null])) {
        return (NSString *)self;
    } else {
        return  nil;
    }
}
- (NSNumber *)sc_numberOrNil {
    if ([self isKindOfClass:[NSNumber class]] && (self != [NSNull null])) {
        return (NSNumber *)self;
    } else {
        return  nil;
    }
}
- (NSArray *)sc_arrayOrNil {
    if ([self isKindOfClass:[NSArray class]] && (self != [NSNull null])) {
        return (NSArray *)self;
    } else {
        return  nil;
    }
}

- (NSDictionary *)sc_dictionaryOrNil {
    if ([self isKindOfClass:[NSDictionary class]] && (self != [NSNull null])) {
        return (NSDictionary *)self;
    } else {
        return  nil;
    }
}

- (NSDate *)sc_dateOrNil {
    if ([self isKindOfClass:[NSDate class]] && (self != [NSNull null])) {
        return (NSDate *)self;
    } else {
        return  nil;
    }
}

- (id)sc_objectOrNil {
    if (self != [NSNull null]) {
        return self;
    } else {
        return  nil;
    }
}
@end
