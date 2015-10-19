//
//  SCAPIClient+SCFile.h
//  Pods
//
//  Created by Jan Lipmann on 30/06/15.
//
//

#import "SCAPIClient.h"
#import "AFNetworking/AFNetworking.h"

@interface SCAPIClient (SCFile)
+ (AFHTTPRequestOperation *)downloadFileFromURL:(NSURL *)fileURL withCompletion:(SCAPIFileDownloadCompletionBlock)completion;
@end
