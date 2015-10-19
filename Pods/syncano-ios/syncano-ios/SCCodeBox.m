//
//  SCCodeBox.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 22/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCCodeBox.h"
#import "SCAPIClient.h"
#import "Syncano.h"
#import "SCTrace.h"

@implementation SCCodeBox

+ (void)runCodeBoxWithId:(NSNumber *)codeBoxId params:(NSDictionary *)params completion:(SCCodeBoxCompletionBlock)completion {
    [self runCodeBoxWithId:codeBoxId params:params usingAPIClient:[Syncano sharedAPIClient] completion:completion];
}

+ (void)runCodeBoxWithId:(NSNumber *)codeBoxId params:(NSDictionary *)params onSyncano:(Syncano *)syncano completion:(SCCodeBoxCompletionBlock)completion {
    [self runCodeBoxWithId:codeBoxId params:params usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)runCodeBoxWithId:(NSNumber *)codeBoxId params:(NSDictionary *)params usingAPIClient:(SCAPIClient *)apiClient completion:(SCCodeBoxCompletionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"codeboxes/%@/run/",codeBoxId];
    NSDictionary *payload = (params) ? @{@"payload" : params} : nil;
    [apiClient postTaskWithPath:path params:payload completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil,error);
            }
        } else {
            if (completion) {
                SCTrace *trace = [[SCTrace alloc] initWithJSONObject:responseObject andCodeboxIdentifier:codeBoxId];
                completion(trace,error);
            }
        }
    }];
}



@end
