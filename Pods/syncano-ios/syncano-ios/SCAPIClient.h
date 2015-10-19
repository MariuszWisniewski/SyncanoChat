//
//  SCAPIClient.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 27/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "AFNetworking/AFHTTPSessionManager.h"
#import "SCConstants.h"

@class Syncano;

/**
 *  Base class for API calls
 */
@interface SCAPIClient : AFHTTPSessionManager

/**
 *  Creates API Client for provided Syncano instance
 *
 *  @param syncano Syncano instance
 *
 *  @return SCAPIClient object
 */
+ (SCAPIClient *)apiClientForSyncano:(Syncano *)syncano;

- (void)setSocialAuthTokenKey:(NSString *)authToken;

/**
 *  "Abstract" method to GET method call
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return NSURLSessionDataTask object
 */
- (NSURLSessionDataTask *)getTaskWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to POST method call
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return NSURLSessionDataTask object
 */
- (NSURLSessionDataTask *)postTaskWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to PUT method call
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return NSURLSessionDataTask object
 */
- (NSURLSessionDataTask *)putTaskWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to PATCH method call
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return NSURLSessionDataTask object
 */
- (NSURLSessionDataTask *)patchTaskWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to DELETE method call
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return NSURLSessionDataTask object
 */
- (NSURLSessionDataTask *)deleteTaskWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion;


- (NSURLSessionDataTask *)postUploadTaskWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData completion:(SCAPICompletionBlock)completion;

@end
