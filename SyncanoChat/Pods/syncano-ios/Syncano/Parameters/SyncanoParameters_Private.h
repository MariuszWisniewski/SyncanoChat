//
//  SyncanoParameters_Private.h
//  Syncano
//
//  Created by Syncano Inc. on 02/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters.h"

extern NSString *const SYNCANO_PARAMETERS_KEY_METHOD_NAME;

@interface SyncanoParameters ()

@property (strong, readwrite)  NSString *moduleName;
@property (strong, nonatomic)  NSMutableDictionary *parameters;

- (NSString *)methodName;

@end
