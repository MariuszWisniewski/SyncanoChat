//
//  SCJSONResponseSerializer.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 16/06/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCJSONResponseSerializer.h"

@implementation SCJSONResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {
    id JSONObject = [super responseObjectForResponse:response data:data error:error];
    if (*error != nil) {
        NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
        userInfo[kSyncanoRepsonseErrorKey] = @"";
        userInfo[kSyncanoValidationErrorKey] = @[];
        if (data != nil) {
            id errorData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (errorData) {
                if (errorData[@"detail"]) {
                    NSString *responseErrorString = errorData[@"detail"];
                    userInfo[kSyncanoRepsonseErrorKey] = responseErrorString.length > 0 ? errorData : @"";
                }
                if (errorData[@"name"]) {
                    NSArray *validationErrorArray = errorData[@"name"];
                    userInfo[kSyncanoValidationErrorKey] = validationErrorArray;
                }
            }
        }
        NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
        (*error) = newError;
    }
    return (JSONObject);
}

@end
