//
//  SCDataObject.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 27/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle/Mantle.h"
#import "SCConstants.h"

@class Syncano;
@class SCPlease;
@class SCAPIClient;

/**
 *  Main class for data object from Syncano API.
 */
@interface SCDataObject : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSNumber *objectId;
@property (nonatomic,copy) NSDate *created_at;
@property (nonatomic,copy) NSDate *updated_at;
@property (nonatomic,copy) NSNumber *revision;
@property (nonatomic,copy) NSDictionary *links;
@property (nonatomic,copy) NSString *channel_room;
@property (nonatomic,copy) NSString *channel;
@property (nonatomic,copy) NSNumber *group;
@property (nonatomic,copy) NSNumber *owner;
@property (nonatomic) SCDataObjectPermissionType owner_permissions;
@property (nonatomic) SCDataObjectPermissionType group_permissions;
@property (nonatomic) SCDataObjectPermissionType other_permissions;

@property (nonatomic,readonly,getter=path) NSString *path;


/**
 *  Returns class name used in Syncano API, by default this method converts object Class name to lower case string
 *
 *  @return string with API class name
 */
+ (NSString *)classNameForAPI;

/**
 *  Return custom property mapping between iOS class an API class
 *
 *  @return NSDictionary with 'key' of iOS class property name and 'value' with coresponding API class name
 */
+ (NSDictionary *)extendedPropertiesMapping;

/**
 *  Returns SCPlease instance for singleton Syncano
 *
 *  @return SCPlease instance
 */
+ (SCPlease *)please;

/**
 *  Returns SCPlease instance for provided Syncano instance
 *
 *  @param syncano Syncano instance which SCPlease will be using to query objects from
 *
 *  @return SCPlease instance
 */
+ (SCPlease *)pleaseFromSyncano:(Syncano *)syncano;

/**
 *  Registers class in SCParseManager for proper model parsing.
 */
+ (void)registerClass;

/**
 *  Returns SCDataObject instance created by parsing dictionary passed as a parameter
 *
 *  @param dictionary Dictionary with properties used to initialize new object
 *
 *  @return SCDataObject (or a subclass) created from provided dictionary
 */
+ (instancetype)objectFromDictionary:(NSDictionary *)dictionary;

/**
 *  Saves object to API in background for singleton default Syncano instance
 *
 *  @param completion completion block
 *
 */
- (void)saveWithCompletionBlock:(SCCompletionBlock)completion;

/**
 *  Saves object to API in background for chosen Syncano instance
 *
 *  @param syncano    Saves object to API in background for provided Syncano instance
 *  @param completion completion block
 *
 */
- (void)saveToSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion;

/**
 *  Fetches object from API using singleton Syncano instance
 *
 *  @param completion comletion block
 */
- (void)fetchWithCompletion:(SCCompletionBlock)completion;

/**
 *  Fetches object from API using provided Syncano instance
 *
 *  @param syncano    provided Syncano instance
 *  @param completion completion block
 */
- (void)fetchFromSyncano:(Syncano *)syncano completion:(SCCompletionBlock)completion;

- (void)deleteWithCompletion:(SCCompletionBlock)completion;
- (void)deleteFromSyncano:(Syncano *)syncano completion:(SCCompletionBlock)completion;

- (void)updateValue:(id)value forKey:(NSString *)key withCompletion:(SCCompletionBlock)completion;
- (void)updateValue:(id)value forKey:(NSString *)key inSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion;
- (void)updateValue:(id)value forKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion;
@end
