//
//  SCWebhookResponseObject.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 28/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCWebhookResponseObject.h"
#import "NSObject+SCParseHelper.h"

@implementation SCWebhookResponseObject

- (instancetype)initWithJSONObject:(id)JSONObject {
    self = [super init];
    if (self) {
        self.status = [JSONObject[@"status"] sc_stringOrEmpty];
        self.duration = [JSONObject[@"duration"] sc_numberOrNil];
        self.result = [JSONObject[@"result"] sc_objectOrNil];
        self.executedAt = [JSONObject[@"executed_at"] sc_dateOrNil];
    }
    return self;
}

@end
