//
//  SyncanoResponse.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SYNCANO_RESPONSE_ERROR_DOMAIN;

/**
 Base class for responses from Syncano API
 */
@interface SyncanoResponse : NSObject

/**
 Error information
 */
@property (strong)    NSError *error;
/**
 Information whether request succeeded
 */
@property (assign, readonly, getter = isResponseOK)    BOOL responseOK;

/**
 Parse JSON dictionary received from API to library objects
 
 @param json JSON dictionary
 
 @return SyncanoResponse object
 */
+ (instancetype)responseFromJSON:(NSDictionary *)json;

@end
