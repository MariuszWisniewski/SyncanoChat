//
//  SyncanoParameters.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

extern NSString *const kSyncanoParametersOrderAsc;
extern NSString *const kSyncanoParametersOrderDesc;

extern NSString *const kSyncanoParametersOrderByCreatedAt;
extern NSString *const kSyncanoParametersOrderByUpdatedAt;

extern NSString *const kSyncanoParametersFilterText;
extern NSString *const kSyncanoParametersFilterImage;

/**
   Base class for request parameters
 */
@interface SyncanoParameters : MTLModel <MTLJSONSerializing>
/**
   Module name that parameters are used with
 */
@property (strong, readonly)   NSString *moduleName;
/**
   Timezone for parameters object
 */
@property (strong)            NSString *timezone;
/**
   API key used with request
 */
@property (strong)    NSString *apiKey;
/**
   User authorization key.
 */
@property (strong)    NSString *authKey;
/**
   Session ID of request
 */
@property (strong)    NSString *sessionId;

- (NSDictionary *)jsonRPCPostDictionaryForJsonRPCId:(NSNumber *)jsonRPCId;
- (NSMutableDictionary *)jsonRPCMutablePostDictionaryForJsonRPCId:(NSNumber *)jsonRPCId;

- (NSDictionary *)syncServerDictionaryForMessageId:(NSNumber *)messageId;
- (NSMutableDictionary *)syncServerMutableDictionaryForMessageId:(NSNumber *)messageId;

- (id)responseFromJSON:(NSDictionary *)json;

+ (NSMutableDictionary *)mergeSuperParameters:(NSDictionary *)superParameters parameters:(NSDictionary *)parameters;

//Validation
- (SEL)initalizeSelector;
- (NSArray *)initializeSelectorNamesArray;
- (NSArray *)requiredParametersNames;
- (void)validateParameters;
- (void)validateSpecialParameters:(NSArray *)parameters;

@end

/**
   Parameters for collection by either key or ID
 */
@interface SyncanoParameters_ProjectId_CollectionId_CollectionKey : SyncanoParameters

@property (strong)    NSString *projectId;
@property (strong)    NSString *collectionId;
@property (strong)    NSString *collectionKey;

- (SyncanoParameters_ProjectId_CollectionId_CollectionKey *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId;
- (SyncanoParameters_ProjectId_CollectionId_CollectionKey *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey;

@end
