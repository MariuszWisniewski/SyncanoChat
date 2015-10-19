//
//  SCAPIClient+SCDataObject.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 02/04/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCAPIClient.h"

@interface SCAPIClient (SCDataObject)
- (NSURLSessionDataTask *)getDataObjectsFromClassName:(NSString *)className params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion;
- (NSURLSessionDataTask *)getDataObjectsFromClassName:(NSString *)className withId:(NSNumber *)identifier completion:(SCAPICompletionBlock)completion;
@end
