//
//  SCAPIClient+SCFile.m
//  Pods
//
//  Created by Jan Lipmann on 30/06/15.
//
//

#import "SCAPIClient+SCFile.h"

@implementation SCAPIClient (SCFile)

+ (AFHTTPRequestOperation *)downloadFileFromURL:(NSURL *)fileURL withCompletion:(SCAPIFileDownloadCompletionBlock)completion {
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    AFHTTPRequestOperation *downloadRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [downloadRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
    
    [downloadRequestOperation start];
    return downloadRequestOperation;
}

@end
