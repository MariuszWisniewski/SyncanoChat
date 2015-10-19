//
//  SCChannel.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 03/06/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"
#import "SCChannelDelegate.h"

@class Syncano;

@interface SCChannel : NSObject

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSNumber *lastId;
@property (nonatomic,retain) NSString *room;


@property (nonatomic,assign) id<SCChannelDelegate> delegate;

- (instancetype)initWithName:(NSString *)channelName;

- (instancetype)initWithName:(NSString *)channelName andDelegate:(id<SCChannelDelegate>)delegate;

- (instancetype)initWithName:(NSString *)channelName lastId:(NSNumber *)lastId andDelegate:(id<SCChannelDelegate>)delegate;

- (instancetype)initWithName:(NSString *)channelName room:(NSString *)room andDelegate:(id<SCChannelDelegate>)delegate;

- (instancetype)initWithName:(NSString *)channelName lastId:(NSNumber *)lastId room:(NSString *)room andDelegate:(id<SCChannelDelegate>)delegate;


- (void)subscribeToChannel;
- (void)subscribeToChannelInSyncano:(Syncano *)syncano;

- (void)publishToChannelWithPayload:(NSDictionary *)payload completion:(SCChannelPublishCompletionBlock)completion;
- (void)publishToChannelInSyncano:(Syncano *)syncano withPayload:(NSDictionary *)payload completion:(SCChannelPublishCompletionBlock)completion;

@end
