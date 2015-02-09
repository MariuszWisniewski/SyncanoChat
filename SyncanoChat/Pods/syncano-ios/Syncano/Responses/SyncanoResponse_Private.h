//
//  SyncanoResponse_Private.h
//  Syncano
//
//  Created by Syncano Inc. on 07/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoResponse.h"

@interface SyncanoResponse ()

@property (strong)    NSDictionary *json;
@property (assign, readwrite)    BOOL responseOK;

- (BOOL)isKeyDate:(NSString *)key;
- (BOOL)isKeyArray:(NSString *)key;
- (Class)classForKey:(NSString *)key;
- (void)setValue:(id)value forKey:(NSString *)key;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
- (NSString *)description;

@end
