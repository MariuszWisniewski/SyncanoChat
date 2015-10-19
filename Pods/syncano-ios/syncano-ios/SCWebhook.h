//
//  SCWebhook.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 28/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"
#import "SCWebhookResponseObject.h"

@class Syncano;

@interface SCWebhook : NSObject


+ (void)runWebhookWithName:(NSString *)name completion:(SCWebhookCompletionBlock)completion;
+ (void)runWebhookWithName:(NSString *)name onSyncano:(Syncano *)syncano completion:(SCWebhookCompletionBlock)completion;

+ (void)runWebhookWithName:(NSString *)name withPayload:(NSDictionary *)payload completion:(SCWebhookCompletionBlock)completion;
+ (void)runWebhookWithName:(NSString *)name withPayload:(NSDictionary *)payload onSyncano:(Syncano *)syncano completion:(SCWebhookCompletionBlock)completion;


+ (void)runPublicWebhookWithHash:(NSString *)hashTag name:(NSString *)name params:(NSDictionary *)params forInstanceName:(NSString *)instanceName completion:(SCWebhookCompletionBlock)completion;
+ (void)runPublicWebhookWithURLString:(NSString *)urlString params:(NSDictionary *)params completion:(SCWebhookCompletionBlock)completion;

@end
