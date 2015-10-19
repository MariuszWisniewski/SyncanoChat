//
//  SCQuery.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 27/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

@class Syncano;
@protocol SCPredicateProtocol;

/**
 *  Parameter keys for constructing query TODO:Comments for all keys
 */
extern NSString *const SCPleaseParameterFields;
extern NSString *const SCPleaseParameterExcludedFields;
extern NSString *const SCPleaseParameterPageSize;
extern NSString *const SCPleaseParameterOrderBy;
extern NSString *const SCPleaseParameterIncludeKeys;


/**
 *  Class to make queries on Syncano API
 */
@interface SCPlease : NSObject

/**
 *  Syncano instance on which queries are made
 */
@property (nonatomic,assign) Syncano *syncano;

/**
 *  Initializes new empty SCPlease object for provided SCDataObject class
 *
 *  @param dataObjectClass SCDataObject scope class
 *
 *  @return SCPlease object
 */
- (instancetype)initWithDataObjectClass:(Class)dataObjectClass;

/**
 *  Creates a new SCPlease object for provided class for singleton Syncano instance.
 *
 *  @param dataObjectClass SCDataObject scope class
 *
 *  @return SCPlease object
 */
+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass;

/**
 *  Creates a new SCPlease object for provided class for provided Syncano instance
 *
 *  @param dataObjectClass SCDataObject scope class
 *  @param syncano         Syncano instance
 *
 *  @return SCPlease object
 */
+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forSyncano:(Syncano *)syncano;

/**
 *  Creates a new SCPlease object for User class.
 *
 *  @param dataObjectClass SCDataObject scope class
 *
 *  @return SCPlease object
 */
+ (SCPlease *)pleaseInstanceForUserClass;

/**
 *  Creates a new SCPlease object for User class for provided Syncano instance
 *
 *  @param dataObjectClass SCDataObject scope class
 *  @param syncano         Syncano instance
 *
 *  @return SCPlease object
 */
+ (SCPlease *)pleaseInstanceForUserClassForSyncano:(Syncano *)syncano;


/**
 *  Create and run simple request without any query parameters or statements
 *
 *  @param completion completion block
 */
- (void)giveMeDataObjectsWithCompletion:(SCDataObjectsCompletionBlock)completion;

/**
 *  Create and run API request for object with query parameters
 *
 *  @param parameters NSDictionary with query params
 *  @param completion completion block
 */
- (void)giveMeDataObjectsWithParameters:(NSDictionary *)parameters completion:(SCDataObjectsCompletionBlock)completion;

/**
 *  Create and run API request for object with predicate for query and with parameters
 *
 *  @param predicate  SCPredicate to build query
 *  @param parameters NSDictionary with query params
 *  @param completion completion block
 */
- (void)giveMeDataObjectsWithPredicate:(id<SCPredicateProtocol>)predicate parameters:(NSDictionary *)parameters completion:(SCDataObjectsCompletionBlock)completion;

- (void)giveMeNextPageOfDataObjectsWithCompletion:(SCDataObjectsCompletionBlock)completion;
- (void)giveMePreviousPageOfDataObjectsWithCompletion:(SCDataObjectsCompletionBlock)completion;


@end
