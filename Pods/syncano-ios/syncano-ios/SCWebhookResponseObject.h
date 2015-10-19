//
//  SCWebhookResponseObject.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 28/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCWebhookResponseObject : NSObject
@property (nonatomic,copy) NSString *status; //TODO: use enum
@property (nonatomic,copy) NSNumber *duration;
@property (nonatomic,copy) id result;
@property (nonatomic,copy) NSDate *executedAt;

- (instancetype)initWithJSONObject:(id)JSONObject;
@end
