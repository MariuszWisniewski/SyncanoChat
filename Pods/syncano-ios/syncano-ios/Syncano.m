//
//  syncano4_ios.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 26/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "Syncano.h"
#import "SCAPIClient.h"
#import "SCParseManager.h"
#import "SCAPIClient+Class.h"

@interface Syncano ()
@end

@implementation Syncano

/**
 *  Initiates singleton instance of Syncano Class
 *
 *  @param apiKey       API Key to authorize syncano
 *  @param instanceName name of the Syncano instance
 *
 *  @return Syncano singleton instance
 */
+ (Syncano *)instance {
    static dispatch_once_t pred;
    __strong static Syncano * instance= nil;
    dispatch_once( &pred, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (Syncano *)sharedInstanceWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName {
    Syncano *syncano = [Syncano instance];
    [syncano setApiKey:apiKey instanceName:instanceName];
    syncano.apiClient = [SCAPIClient apiClientForSyncano:syncano];
    return syncano;
}

+ (Syncano *)sharedInstanceWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName andValidateWithCompletion:(SCCompletionBlock)completion {
    Syncano *syncano = [Syncano instance];
    [syncano setApiKey:apiKey instanceName:instanceName];
    syncano.apiClient = [SCAPIClient apiClientForSyncano:syncano];
    [syncano validateInstanceOnServerWithCompletion:completion];
    return syncano;
}

+ (NSString *)getApiKey {
    return [[Syncano instance] apiKey];
}

+ (NSString *)getInstanceName {
    return [[Syncano instance] instanceName];
}

+ (SCAPIClient *)sharedAPIClient {
    return [[Syncano instance] apiClient];
}

- (instancetype)initWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName {
    self = [super init];
    if (self) {
        self.apiKey = apiKey;
        self.instanceName = instanceName;
        self.apiClient = [SCAPIClient apiClientForSyncano:self];
    }
    return self;
}

- (instancetype)initWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName andValidateWithCompletion:(SCCompletionBlock)completion {
    self = [self initWithApiKey:apiKey instanceName:instanceName];
    if (self) {
        [self validateInstanceOnServerWithCompletion:completion];
    }
    return self;
}

- (void)validateInstanceOnServerWithCompletion:(SCCompletionBlock)completion {
    [self.apiClient getTaskWithPath:@"" params:nil completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

+ (Syncano *)newSyncanoWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName {
    Syncano *syncano = [[Syncano alloc] initWithApiKey:apiKey instanceName:instanceName];
    return syncano;
}

+ (Syncano *)newSyncanoWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName andValidateWithCompletion:(SCCompletionBlock)completion {
    Syncano *syncano = [[Syncano alloc] initWithApiKey:apiKey instanceName:instanceName andValidateWithCompletion:completion];
    return syncano;
}

+ (Syncano *)testInstance {
    //1429b1898655e3c576d4352cb7ed383946dbc8e4
    return [Syncano sharedInstanceWithApiKey:@"68fef4346bbb1db550aba1f1188d5b8fb91b25a9" instanceName:@"mytestinstance"];
}

- (void)setApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName {
    self.apiKey = apiKey;
    self.instanceName = instanceName;
}


@end
