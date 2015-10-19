//
//  SCChannelNotificationMessage.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 08/06/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

@interface SCChannelNotificationMessage : NSObject

@property (nonatomic,copy) NSNumber *identifier;
@property (nonatomic,copy) NSDate *createdAt;
@property (nonatomic,copy) NSDictionary *author;
@property (nonatomic) SCChannelNotificationMessageAction action;
@property (nonatomic,copy) NSDictionary *payload;
@property (nonatomic,copy) NSDictionary *metadata;

- (instancetype)initWithJSONObject:(id)JSONObject;
@end
