//
//  SCQuery.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 27/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCPlease.h"
#import "Syncano.h"
#import "SCAPIClient+SCDataObject.h"
#import "SCParseManager.h"
#import "SCPredicate.h"
#import "SCDataObject.h"
#import "SCUser.h"

NSString *const SCPleaseParameterFields = @"fields";
NSString *const SCPleaseParameterExcludedFields = @"excluded_fields";
NSString *const SCPleaseParameterPageSize = @"page_size";
NSString *const SCPleaseParameterOrderBy = @"order_by";
NSString *const SCPleaseParameterIncludeKeys = @"include_keys";


@interface SCPlease ()

/**
 *  Connected SCDataObject Class
 */
@property (nonatomic,assign) Class dataObjectClass;

/**
 *  API class name representation of connected SCDataObject Class
 */
@property (nonatomic,retain) NSString *classNameForAPICalls;

/**
 *  SCPredicate to use with API call
 */
@property (nonatomic,retain) id<SCPredicateProtocol> predicate;

/**
 *  Params of API call
 */
@property (nonatomic,retain) NSDictionary *parameters;

/**
 *  URL string to get next part of objects from
 */
@property (nonatomic,retain) NSString *nextUrlString;

/**
 *  URL string to get prevoius of objects from
 */
@property (nonatomic,retain) NSString *previousUrlString;

@property (nonatomic,retain) NSArray *includeKeys;
@end

@implementation SCPlease
- (instancetype)initWithDataObjectClass:(Class)dataObjectClass {
    self = [super init];
    if (self) {
        self.dataObjectClass = dataObjectClass;
        self.classNameForAPICalls = [dataObjectClass classNameForAPI];
    }
    return self;
}
+ (SCPlease *)pleaseInstanceForDataObjectWithClass:dataObjectClass {
    return [self pleaseInstanceForDataObjectWithClass:dataObjectClass forSyncano:nil];
}

+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forSyncano:(Syncano *)syncano {
    SCPlease *please = [[SCPlease alloc] initWithDataObjectClass:dataObjectClass];
    if (syncano) {
        please.syncano = syncano;
    }
    return please;
}

+ (SCPlease *)pleaseInstanceForUserClass {
    return [self pleaseInstanceForUserClassForSyncano:nil];
}

+ (SCPlease *)pleaseInstanceForUserClassForSyncano:(Syncano *)syncano {
    SCPlease *please = [[SCPlease alloc] init];
    please.dataObjectClass = [SCUser class];
    please.classNameForAPICalls = @"users";
    if (syncano) {
        please.syncano = syncano;
    }
    return please;
}
/**
 *  Returns proper API Client
 *
 *  @return API Client
 */
- (SCAPIClient *)apiClient {
    if (self.syncano) {
        return self.syncano.apiClient;
    }
    return [Syncano sharedAPIClient];
}

- (void)resolveQueryParameters:(NSDictionary *)parameters withPredicate:(id<SCPredicateProtocol>)predicate completion:(SCPleaseResolveQueryParametersCompletionBlock)completion {
    NSMutableDictionary *queryParameters = (parameters.count > 0) ? [parameters mutableCopy] : [NSMutableDictionary new];
    NSArray *includeKeys;
    if (queryParameters[SCPleaseParameterIncludeKeys]) {
        if ([queryParameters[SCPleaseParameterIncludeKeys] isKindOfClass:[NSArray class]]) {
            includeKeys = queryParameters[SCPleaseParameterIncludeKeys];
        }
        [queryParameters removeObjectForKey:SCPleaseParameterIncludeKeys];
    }
    if ([parameters[SCPleaseParameterFields] isKindOfClass:[NSArray class]] == YES) {
        NSArray *fieldsArray = parameters[SCPleaseParameterFields];
        NSString *fields = [fieldsArray componentsJoinedByString:@","];
        [queryParameters setObject:fields forKey:SCPleaseParameterFields];
    }
    if (predicate) {
        [queryParameters  addEntriesFromDictionary:@{@"query" : [predicate queryRepresentation]}];
    }
    if (completion) {
        completion([NSDictionary dictionaryWithDictionary:queryParameters],includeKeys);
    }
}

- (void)giveMeDataObjectsWithCompletion:(SCDataObjectsCompletionBlock)completion {
    self.parameters = nil;
    self.predicate = nil;
    [self getDataObjectFromAPIWithCompletion:completion];
}

- (void)giveMeDataObjectsWithParameters:(NSDictionary *)parameters completion:(SCDataObjectsCompletionBlock)completion {
    self.parameters = parameters;
    self.predicate = nil;
    [self getDataObjectFromAPIWithCompletion:completion];
}

- (void)giveMeDataObjectsWithPredicate:(id<SCPredicateProtocol>)predicate
                            parameters:(NSDictionary *)parameters
                            completion:(SCDataObjectsCompletionBlock)completion {
    self.parameters = parameters;
    self.predicate = predicate;
    [self getDataObjectFromAPIWithCompletion:completion];
}



- (void)getDataObjectFromAPIWithCompletion:(SCDataObjectsCompletionBlock)completion {
    self.previousUrlString = nil;
    self.nextUrlString = nil;
    self.includeKeys = nil;
    [self resolveQueryParameters:self.parameters withPredicate:self.predicate completion:^(NSDictionary *queryParameters, NSArray *includeKeys) {
        self.includeKeys = includeKeys;
        [[self apiClient] getDataObjectsFromClassName:self.classNameForAPICalls params:queryParameters completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
            [self handleResponse:responseObject error:error completion:completion includeKeys:includeKeys];
        }];
    }];

}

- (void)giveMeNextPageOfDataObjectsWithCompletion:(SCDataObjectsCompletionBlock)completion {
    if (self.nextUrlString) {
        [[self apiClient] GET:self.nextUrlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self handleResponse:responseObject error:nil completion:completion includeKeys:self.includeKeys];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (completion) {
                completion(nil,error);
            }
        }];
    } else {
        //TODO: handle with error
        if (completion) {
            completion(nil,nil);
        }
    }
}

- (void)giveMePreviousPageOfDataObjectsWithCompletion:(SCDataObjectsCompletionBlock)completion {
    if (self.previousUrlString) {
        [[self apiClient] GET:self.previousUrlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self handleResponse:responseObject error:nil completion:completion includeKeys:self.includeKeys];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (completion) {
                completion(nil,error);
            }
        }];
    } else {
        //TODO: handle with error
        if (completion) {
            completion(nil,nil);
        }
    }
}

- (void)handleResponse:(id)responseObject error:(NSError *)error completion:(SCDataObjectsCompletionBlock)completion includeKeys:(NSArray *)includeKeys {
    self.previousUrlString = nil;
    self.nextUrlString = nil;
    if (responseObject[@"prev"] && responseObject[@"prev"]!=[NSNull null]) {
        self.previousUrlString = responseObject[@"prev"];
    }
    if (responseObject[@"next"] && responseObject[@"next"]!=[NSNull null]) {
        self.nextUrlString = responseObject[@"next"];
    }
    if (responseObject[@"objects"]) {
        NSArray *parsedObjects = [[SCParseManager sharedSCParseManager] parsedObjectsOfClass:self.dataObjectClass fromJSONObject:responseObject[@"objects"]];
        if (includeKeys.count > 0) {
            [self handleIncludesForObjects:parsedObjects includeKeys:includeKeys completion:^(NSArray *objects, NSError *error) {
                if (completion) {
                    completion(objects,nil);
                }
            }];
        } else {
            if (completion) {
                completion(parsedObjects,nil);
            }
        }
    } else {
        if (completion) {
            completion(nil,error);
        }
    }
}

- (void)handleIncludesForObjects:(NSArray *)objects includeKeys:(NSArray *)includeKeys completion:(SCDataObjectsCompletionBlock)completion {
    dispatch_group_t fetchGroup = dispatch_group_create();
    for (id object in objects) {
        for (NSString *includeKey in includeKeys) {
            dispatch_group_enter(fetchGroup);
            if ([object respondsToSelector:NSSelectorFromString(includeKey)]) {
                id relatedObject = [object valueForKey:includeKey];
                if (self.syncano && [relatedObject respondsToSelector:@selector(fetchFromSyncano:completion:)]) {
                    [relatedObject fetchFromSyncano:self.syncano completion:^(NSError *error) {
                        dispatch_group_leave(fetchGroup);
                    }];
                } else if ([relatedObject respondsToSelector:@selector(fetchWithCompletion:)]) {
                    [relatedObject fetchWithCompletion:^(NSError *error) {
                        dispatch_group_leave(fetchGroup);
                    }];
                } else {
                    //TODO: throw error here
                    dispatch_group_leave(fetchGroup);
                }

            } else {
                //TODO: throw error here
                dispatch_group_leave(fetchGroup);
            }
        }
    }
    dispatch_group_notify(fetchGroup, dispatch_get_main_queue(), ^{
        if (completion) {
            completion(objects,nil);
        }
    });
}
@end
