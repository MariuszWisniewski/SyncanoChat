//
//  SCTrace.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 25/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCTrace.h"
#import "NSObject+SCParseHelper.h"
#import "Syncano.h"
#import "SCAPIClient.h"

@implementation SCTrace

- (instancetype)initWithJSONObject:(id)JSONObject andCodeboxIdentifier:(NSNumber *)codeboxIdentifier {
    self = [super init];
    if (self) {
        [self fillWithJSONObject:JSONObject];
        self.codeboxIdentifier = codeboxIdentifier;
    }
    return self;
}

- (void)fillWithJSONObject:(id)JSONObject {
    self.identifier = [JSONObject[@"id"] sc_numberOrNil];
    self.status = [JSONObject[@"status"] sc_stringOrEmpty];
    self.links = [JSONObject[@"links"] sc_dictionaryOrNil];
    self.executedAt = [JSONObject[@"executed_at"] sc_dateOrNil];
    self.result = [JSONObject[@"result"] sc_objectOrNil];
    self.duration = [JSONObject[@"duration"] sc_numberOrNil];
}

- (void)fetchWithCompletion:(SCTraceCompletionBlock)completion {
    [self fetchUsingAPIClient:[Syncano sharedAPIClient] withCompletion:completion];
}

- (void)fetchFromSyncano:(Syncano *)syncano withCompletion:(SCTraceCompletionBlock)completion {
    [self fetchUsingAPIClient:syncano.apiClient withCompletion:completion];
}

- (void)fetchUsingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCTraceCompletionBlock)completion {
    //TODO: rise an error if there is no identifier or codebox identifier;
    NSString *path = [NSString stringWithFormat:@"codeboxes/%@/traces/%@/",self.codeboxIdentifier,self.identifier];
    [apiClient getTaskWithPath:path params:nil completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil,error);
            }
        } else {
            [self fillWithJSONObject:responseObject];
            if (completion) {
                completion(self,error);
            }
        }
    }];
}

@end
