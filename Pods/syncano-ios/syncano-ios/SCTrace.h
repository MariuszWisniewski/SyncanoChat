//
//  SCTrace.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 25/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

@class Syncano;

@interface SCTrace : NSObject
@property (nonatomic,copy) NSNumber *identifier;
@property (nonatomic,copy) NSString *status; //TODO: use enum
@property (nonatomic,copy) NSDictionary *links;
@property (nonatomic,copy) NSDate *executedAt;
@property (nonatomic,copy) id result;
@property (nonatomic,copy) NSNumber *duration;

@property (nonatomic,copy) NSNumber *codeboxIdentifier;

- (instancetype)initWithJSONObject:(id)JSONObject andCodeboxIdentifier:(NSNumber *)codeboxIdentifier;


/**
 *  Call trace
 *
 *  @param completion completion block
 */
- (void)fetchWithCompletion:(SCTraceCompletionBlock)completion;

/**
 *  Call trace on provided Synano instance
 *
 *  @param syncano    syncano instance
 *  @param completion completion block
 */
- (void)fetchFromSyncano:(Syncano *)syncano withCompletion:(SCTraceCompletionBlock)completion;
@end
