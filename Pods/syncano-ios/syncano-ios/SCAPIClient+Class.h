//
//  SCAPIClient+SCClass.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 02/04/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCAPIClient.h"

@interface SCAPIClient (Class)
- (NSURLSessionDataTask *)getClassesWithCompletion:(SCAPICompletionBlock)completion;
@end
