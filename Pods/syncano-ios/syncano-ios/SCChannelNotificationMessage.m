//
//  SCChannelNotificationMessage.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 08/06/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCChannelNotificationMessage.h"
#import "NSObject+SCParseHelper.h"

@implementation SCChannelNotificationMessage

- (instancetype)initWithJSONObject:(id)JSONObject {
    self = [super init];
    if (self) {
        self.identifier = [JSONObject[@"id"] sc_numberOrNil];
        self.createdAt = [JSONObject[@"createdAt"] sc_dateOrNil];
        self.author = [JSONObject[@"author"] sc_dictionaryOrNil];
        self.action = [SCConstants channelNotificationMessageActionByString:[JSONObject[@"action"] sc_stringOrEmpty]];
        self.payload = [JSONObject[@"payload"] sc_dictionaryOrNil];
        self.metadata = [JSONObject[@"metadata"] sc_dictionaryOrNil];
    }
    return self;
}
@end
