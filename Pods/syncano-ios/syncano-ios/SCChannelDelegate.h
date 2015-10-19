//
//  SCPollCallbackProtocol.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 08/06/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCChannelNotificationMessage.h"

@protocol SCChannelDelegate <NSObject>

- (void)chanellDidReceivedNotificationMessage:(SCChannelNotificationMessage *)notificationMessage;

@end
