//
//  SCAPIClient+SCClass.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 02/04/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCAPIClient+Class.h"

@implementation SCAPIClient (Class)
- (NSURLSessionDataTask *)getClassesWithCompletion:(SCAPICompletionBlock)completion {
    return [self getTaskWithPath:@"classes/" params:nil completion:completion];
}
@end
