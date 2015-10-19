//
//  SCParseManager.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 30/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCParseManager.h"
#import "Mantle/Mantle.h"
#import <objc/runtime.h>
#import "SCDataObject.h"


@interface SCParseManager ()

@end

@implementation SCParseManager

SINGLETON_IMPL_FOR_CLASS(SCParseManager)

- (NSString *) typeOfPropertyNamed: (NSString *) name fromClass:(__unsafe_unretained Class)class
{
    objc_property_t property = class_getProperty( class, [name UTF8String] );
    if ( property == NULL )
        return ( NULL );
    NSString *typeName = [NSString stringWithUTF8String:property_getTypeString(property)];
    typeName = [typeName stringByReplacingOccurrencesOfString:@"T@\"" withString:@""];
    typeName = [typeName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return typeName;
}

/**
 *  Converts objc_property_t to const char *
 *
 *  @param property objc_property_t to convert
 *
 *  @return converted const char *
 */
const char * property_getTypeString( objc_property_t property )
{
    const char * attrs = property_getAttributes( property );
    if ( attrs == NULL )
        return ( NULL );
    
    static char buffer[256];
    const char * e = strchr( attrs, ',' );
    if ( e == NULL )
        return ( NULL );
    
    int len = (int)(e - attrs);
    memcpy( buffer, attrs, len );
    buffer[len] = '\0';
    
    return ( buffer );
}

@end
