//
//  SyncanoDateFormatter.h
//  Syncano
//
//  Created by Syncano Inc. on 03/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SyncanoDateFormatter_DEFAULT_SYNCANO_DATE_FORMAT;

/**
 Used in SyncanoObject (and its derived classes) internals to convert dates sent from Syncano servers to NSDate
 */
@interface SyncanoDateFormatter : NSObject

/**
 Shared instance of SyncanoDateFormatter reused in library classes.
 
 @return Shared instance of SyncanoDateFormatter.
 */
+ (NSDateFormatter *)sharedDateFormatter;

/**
 @return Calendar to be used in conversion
 */
+ (NSCalendar *)currentCalendar;

/**
 Used to convert date in format used by Synano servers to NSDate
 
 @param dateText Date string
 
 @return date
 */
+ (NSDate *)dateFromTextWithConstFormatWithoutUsingFormatter:(NSString *)dateText;

@end
