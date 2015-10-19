//
//  SCChannel.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 03/06/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCChannel.h"
#import "Syncano.h"
#import "SCAPIClient.h"
#import "SCChannelNotificationMessage.h"

@interface SCChannel ()
@property (nonatomic)           SCChannelType type;
@property (nonatomic)           BOOL customPublish;
@property (nonatomic,retain)    NSDictionary *links;
@property (nonatomic,retain)    NSDate *createdAt;
@property (nonatomic,retain)    NSDate *updatedAt;
@property (nonatomic)           SCChannelPermisionType groupPermissions;
@property (nonatomic)           SCChannelPermisionType otherPermissions;
@property (nonatomic,retain)    NSNumber *group;
@end

@implementation SCChannel

- (instancetype)initWithName:(NSString *)channelName {
    return [self initWithName:channelName andDelegate:nil];
}

- (instancetype)initWithName:(NSString *)channelName andDelegate:(id<SCChannelDelegate>)delegate {
    return [self initWithName:channelName lastId:nil room:nil andDelegate:delegate];
}

- (instancetype)initWithName:(NSString *)channelName lastId:(NSNumber *)lastId andDelegate:(id<SCChannelDelegate>)delegate {
    return [self initWithName:channelName lastId:lastId room:nil andDelegate:delegate];
}

- (instancetype)initWithName:(NSString *)channelName room:(NSString *)room andDelegate:(id<SCChannelDelegate>)delegate {
    return [self initWithName:channelName lastId:nil room:room andDelegate:delegate];
}

- (instancetype)initWithName:(NSString *)channelName lastId:(NSNumber *)lastId room:(NSString *)room andDelegate:(id<SCChannelDelegate>)delegate {
    self = [super init];
    if (self) {
        self.name = channelName;
        self.lastId = lastId;
        self.room = room;
        self.delegate = delegate;
    }
    return self;
}

- (void)subscribeToChannel {
    [self subscribeToChannelUsingAPIClient:[Syncano sharedAPIClient]];
}
- (void)subscribeToChannelInSyncano:(Syncano *)syncano {
    [self subscribeToChannelUsingAPIClient:syncano.apiClient];
}

- (void)subscribeToChannelUsingAPIClient:(SCAPIClient *)apiClient {
    [self pollToChannelUsingAPIClient:apiClient];
}

- (void)pollToChannelUsingAPIClient:(SCAPIClient *)apiClient {
    NSString *path = [NSString stringWithFormat:@"channels/%@/poll/",self.name];
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (self.room.length > 0) {
        [params setObject:self.room forKey:@"room"];
    }
    if (self.lastId) {
        [params setObject:self.lastId forKey:@"last_id"];
    }
    [apiClient getTaskWithPath:path params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            SCChannelNotificationMessage *message = [[SCChannelNotificationMessage alloc] initWithJSONObject:responseObject];
            self.lastId = message.identifier;
            if ([self.delegate respondsToSelector:@selector(chanellDidReceivedNotificationMessage:)]) {
                [self.delegate chanellDidReceivedNotificationMessage:message];
            }
        }
        //TODO: QUESTION: How does it handle the error (what we should do when error occured) ?
        [self pollToChannelUsingAPIClient:apiClient];
    }];
}

- (void)publishToChannelWithPayload:(NSDictionary *)payload completion:(SCChannelPublishCompletionBlock)completion {
    [self publishToChannelUsingAPIClient:[Syncano sharedAPIClient] withPayload:payload completion:completion];
}

- (void)publishToChannelInSyncano:(Syncano *)syncano withPayload:(NSDictionary *)payload completion:(SCChannelPublishCompletionBlock)completion {
    [self publishToChannelUsingAPIClient:syncano.apiClient withPayload:payload completion:completion];
}

- (void)publishToChannelUsingAPIClient:(SCAPIClient *)apiClient withPayload:(NSDictionary *)payload completion:(SCChannelPublishCompletionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"channels/%@/publish/",self.name];
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (self.room.length > 0) {
        [params setObject:self.room forKey:@"room"];
    }
    if (payload) {
        [params setObject:payload forKey:@"payload"];
    }
    [apiClient postTaskWithPath:path params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            SCChannelNotificationMessage *message = [[SCChannelNotificationMessage alloc] initWithJSONObject:responseObject];
            if (completion) {
                completion(message,nil);
            }
        } else {
            if (completion) {
                completion(nil,error);
            }
        }
    }];
}

@end
