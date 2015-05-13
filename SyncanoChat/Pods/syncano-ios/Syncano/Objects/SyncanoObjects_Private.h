//
//  SyncanoObject+Private.h
//  Syncano
//
//  Created by Syncano Inc. on 15/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoObjects.h"

@interface NSDictionary (SyncanoObjects)
- (id)syncano_notNullObjectForKey:(id)aKey;
@end

@interface SyncanoAuth : SyncanoObject
@property (strong)    NSString *object;
@property (strong)    NSString *result;
@property (strong)    NSDate *timestamp;
@property (strong)    NSString *type;
@property (strong)    NSString *uuid;
- (BOOL)OK;
@end

@interface SyncanoPing : SyncanoObject
@property (strong)    NSString *object;
@property (strong)    NSDate *timestamp;
@property (strong)    NSString *type;
@end

@interface SyncanoError : SyncanoObject
@property (strong)    NSString *result;
@property (strong)    NSString *error;
@end
