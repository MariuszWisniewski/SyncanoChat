//
//  SCAPIClient+SCDataObject.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 02/04/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCAPIClient+SCDataObject.h"

@implementation SCAPIClient (SCDataObject)
- (NSURLSessionDataTask *)getDataObjectsFromClassName:(NSString *)className params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"classes/%@/objects/",className];
    return [self getTaskWithPath:path params:params completion:completion];
}

- (NSURLSessionDataTask *)getDataObjectsFromClassName:(NSString *)className withId:(NSNumber *)identifier completion:(SCAPICompletionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"classes/%@/objects/%@/",className,identifier];
    return [self getTaskWithPath:path params:nil completion:completion];
}
@end
