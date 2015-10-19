//
//  SCFile.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 26/06/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle/Mantle.h"
#import "SCConstants.h"

@class SCDataObject;

@interface SCFile : MTLModel<MTLJSONSerializing>

/**
 *  Remote URL of a file
 */
@property (nonatomic,copy) NSURL *fileURL;

/**
 *  NSData representation of a file
 */
@property (nonatomic,readonly) NSData *data;

/**
 *  After set this property to YES fetched data will be stored and can be accessed via 'data' property
 */
@property (nonatomic) BOOL storeDataAfterFetch;

/**
 *  SCFile initializer
 *
 *  @param data NSData representation of a file
 *
 *  @return SCFile instance
 */
+ (instancetype)fileWithaData:(NSData *)data;

/**
 *  Attempts to save file to server, 'data' proeprty cannot be nil
 *
 *  @param name       name of the data object param that is associated with this file
 *  @param dataObject data object which this file is part of
 *  @param completion completion block
 */
- (void)saveAsPropertyWithName:(NSString *)name ofDataObject:(SCDataObject *)dataObject withCompletion:(SCCompletionBlock)completion;

/**
 *  Attempts to fetch file from server.
 *
 *  @param completion completion block
 */
- (void)fetchInBackgroundWithCompletion:(SCFileFetchCompletionBlock)completion;

@end
