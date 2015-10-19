//
//  NSObject+SCParseHelper.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 12/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SCParseHelper)
- (NSString *)sc_stringOrEmpty;
- (NSNumber *)sc_numberOrNil;
- (NSArray *)sc_arrayOrNil;
- (NSDictionary *)sc_dictionaryOrNil;
- (NSDate *)sc_dateOrNil;
- (id)sc_objectOrNil;
@end
