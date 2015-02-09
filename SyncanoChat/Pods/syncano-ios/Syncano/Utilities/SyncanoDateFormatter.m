//
//  SyncanoDateFormatter.m
//  Syncano
//
//  Created by Syncano Inc. on 03/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoDateFormatter.h"

NSString *const SyncanoDateFormatter_DEFAULT_SYNCANO_DATE_FORMAT = @"yyyy-MM-dd'T'HH:mm";

@implementation SyncanoDateFormatter

- (id)init {
	return nil;
}

+ (NSCalendar *)currentCalendar {
	static NSCalendar *currentCalendar = nil;

	@synchronized(self)
	{
		if (currentCalendar == nil) {
			currentCalendar = [NSCalendar currentCalendar];
			[currentCalendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
			[currentCalendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
		}
	}
	return currentCalendar;
}

+ (NSDateFormatter *)sharedDateFormatter {
	static NSDateFormatter *dateFormatter = nil;

	@synchronized(self)
	{
		if (dateFormatter == nil) {
			dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
			[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
			[dateFormatter setDateFormat:SyncanoDateFormatter_DEFAULT_SYNCANO_DATE_FORMAT];
		}
	}

	return dateFormatter;
}

+ (NSDate *)dateFromTextWithConstFormatWithoutUsingFormatter:(NSString *)dateText {
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	NSCalendar *calendar = [self currentCalendar];

	static NSRange yearRange = { 0, 4 }; //NSMakeRange(0, 4);
	static NSRange monthRange = { 5, 2 }; //NSMakeRange(5, 2);
	static NSRange dayRange = { 8, 2 }; //NSMakeRange(8, 2);
	static NSRange hourRange = { 11, 2 }; //NSMakeRange(11, 2);
	static NSRange minuteRange = { 14, 2 }; //NSMakeRange(14, 2);
	static NSRange secondRange = { 17, 2 }; //NSMakeRange(17, 2);

	NSDate *date = nil;

	if (dateText && (id)dateText != [NSNull null]) {
		@try {
			dateComponents.year = [[dateText substringWithRange:yearRange] integerValue];
			dateComponents.month = [[dateText substringWithRange:monthRange] integerValue];
			dateComponents.day = [[dateText substringWithRange:dayRange] integerValue];
			dateComponents.hour = [[dateText substringWithRange:hourRange] integerValue];
			dateComponents.minute = [[dateText substringWithRange:minuteRange] integerValue];
			dateComponents.second = [[dateText substringWithRange:secondRange] integerValue];
		}
		@catch (NSException *exception)
		{
			SyncanoDebugLog(@"Exception while parsing date text:[%@], exception: [%@]", dateText, exception);
		}
		@finally
		{
			date = [calendar dateFromComponents:dateComponents];
		}
	}

	return date;
}

@end
