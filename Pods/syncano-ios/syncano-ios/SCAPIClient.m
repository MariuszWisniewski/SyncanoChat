//
//  SCAPIClient.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 27/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCAPIClient.h"
#import "Syncano.h"
#import "SCJSONResponseSerializer.h"
#import "NSData+MimeType.h"

@interface SCAPIClient ()
@property (nonatomic,copy) NSString *apiKey;
@property (nonatomic,copy) NSString *instanceName;
@end

@implementation SCAPIClient

- (instancetype)initWithBaseURL:(NSURL *)url apiKey:(NSString *)apiKey instanceName:(NSString *)instanceName {
    self = [self initWithBaseURL:url];
    if (self) {
        self.apiKey = apiKey;
        self.instanceName = instanceName;
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
        self.responseSerializer = [SCJSONResponseSerializer serializer];
    }
    return self;
}

+ (SCAPIClient *)apiClientForSyncano:(Syncano *)syncano {
    NSURL *instanceURL = [NSURL URLWithString:syncano.instanceName relativeToURL:[NSURL URLWithString:kBaseURL]];
    SCAPIClient *apiClient = [[SCAPIClient alloc] initWithBaseURL:instanceURL apiKey:syncano.apiKey instanceName:syncano.instanceName];
    return apiClient;
}

- (void)setSocialAuthTokenKey:(NSString *)authToken {
    [self.requestSerializer setValue:[NSString stringWithFormat:@"token %@",authToken] forHTTPHeaderField:@"Authorization"];
}

- (void)authorizeRequest {
    NSString *apiKey = (self.apiKey.length > 0) ? self.apiKey : [Syncano getApiKey];
   [self.requestSerializer setValue:apiKey forHTTPHeaderField:@"X-API-KEY"];
    if ([SCUser currentUser]) {
        NSString *userKey = [SCUser currentUser].userKey;
        [self.requestSerializer setValue:userKey forHTTPHeaderField:@"X-USER-KEY"];
    }
}

- (NSURLSessionDataTask *)getTaskWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    [self authorizeRequest];
    NSURLSessionDataTask *task = [self GET:path
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       completion(task,responseObject, nil);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       completion(task,nil, error);
                                   }];
    
    return task;
}

- (NSURLSessionDataTask *)postTaskWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    [self authorizeRequest];
    NSURLSessionDataTask *task = [self POST:path
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       completion(task,responseObject, nil);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       completion(task,nil, error);
                                   }];
    
    return task;
}

- (NSURLSessionDataTask *)putTaskWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    [self authorizeRequest];
    NSURLSessionDataTask *task = [self PUT:path
                                 parameters:params
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        completion(task,responseObject, nil);
                                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        completion(task,nil, error);
                                    }];
    
    return task;
}

- (NSURLSessionDataTask *)patchTaskWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    [self authorizeRequest];
    NSURLSessionDataTask *task = [self PATCH:path
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       completion(task,responseObject, nil);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       completion(task,nil, error);
                                   }];
    
    return task;
}

- (NSURLSessionDataTask *)deleteTaskWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    [self authorizeRequest];
    NSURLSessionDataTask *task = [self DELETE:path
                                 parameters:params
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        completion(task,responseObject, nil);
                                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        completion(task,nil, error);
                                    }];
    
    return task;
}

- (NSURLSessionDataTask *)postUploadTaskWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData completion:(SCAPICompletionBlock)completion {
    [self authorizeRequest];
    NSURLSessionDataTask *task = [self POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:propertyName fileName:propertyName mimeType:[fileData mimeTypeByGuessing]];
        [formData appendPartWithFormData:fileData name:propertyName];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(task,responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(task,nil, error);
    }];
    return task;
}

@end
