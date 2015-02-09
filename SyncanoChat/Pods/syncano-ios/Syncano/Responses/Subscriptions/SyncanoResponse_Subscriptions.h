//
//  SyncanoResponse_Subscriptions.h
//  Syncano
//
//  Created by Syncano Inc. on 09/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse.h"
#import "SyncanoObjects.h"

@interface SyncanoResponse_Subscriptions_Get : SyncanoResponse
/**
 Requested list of active subscriptions
 */
@property (strong)    NSArray *subscription;
@end
