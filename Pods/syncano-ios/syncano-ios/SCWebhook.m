//
//  SCWebhook.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 28/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCWebhook.h"
#import "SCAPIClient.h"
#import "Syncano.h"
#import "SCWebhookResponseObject.h"


@implementation SCWebhook

+ (void)runWebhookWithName:(NSString *)name completion:(SCWebhookCompletionBlock)completion {
    [self runWebhookWithName:name withPayload:nil usingAPIClient:[Syncano sharedAPIClient] completion:completion];
}
+ (void)runWebhookWithName:(NSString *)name onSyncano:(Syncano *)syncano completion:(SCWebhookCompletionBlock)completion {
    [self runWebhookWithName:name withPayload:nil usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)runWebhookWithName:(NSString *)name withPayload:(NSDictionary *)payload completion:(SCWebhookCompletionBlock)completion {
    [self runWebhookWithName:name withPayload:payload usingAPIClient:[Syncano sharedAPIClient] completion:completion];
}
+ (void)runWebhookWithName:(NSString *)name withPayload:(NSDictionary *)payload onSyncano:(Syncano *)syncano completion:(SCWebhookCompletionBlock)completion {
    [self runWebhookWithName:name withPayload:payload usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)runWebhookWithName:(NSString *)name withPayload:(NSDictionary *)payload usingAPIClient:(SCAPIClient *)apiClient completion:(SCWebhookCompletionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"webhooks/%@/run/",name];
    NSDictionary *params = (payload) ? @{@"payload":payload} : nil;
   [apiClient postTaskWithPath:path params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
       if (error) {
           if (completion) {
               completion(nil,error);
           }
       } else {
           if (completion) {
               SCWebhookResponseObject *webhookResponseObject = [[SCWebhookResponseObject alloc] initWithJSONObject:responseObject];
               completion(webhookResponseObject,nil);
           }
       }
   }];
}

+ (void)runPublicWebhookWithHash:(NSString *)hashTag name:(NSString *)name params:(NSDictionary *)params forInstanceName:(NSString *)instanceName completion:(SCWebhookCompletionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"%@/webhooks/p/%@/%@/",instanceName,hashTag,name];
    SCAPIClient *apiClient = [[SCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];

    [apiClient POST:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
                SCWebhookResponseObject *webhookResponseObject = [[SCWebhookResponseObject alloc] initWithJSONObject:responseObject];
                completion(webhookResponseObject,nil);
            }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
}

+ (void)runPublicWebhookWithURLString:(NSString *)urlString params:(NSDictionary *)params completion:(SCWebhookCompletionBlock)completion {
    SCAPIClient *apiClient = [[SCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    [apiClient POST:@"" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            SCWebhookResponseObject *webhookResponseObject = [[SCWebhookResponseObject alloc] initWithJSONObject:responseObject];
            completion(webhookResponseObject,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
}
@end
