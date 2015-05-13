//
//  SyncanoResponse_Notifications.h
//  Syncano
//
//  Created by Syncano Inc. on 09/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse.h"

@interface SyncanoResponse_Notifications_GetHistory : SyncanoResponse
/**
   Requested list of notification history entries
 */
@property (strong)    NSArray *history;
@end
