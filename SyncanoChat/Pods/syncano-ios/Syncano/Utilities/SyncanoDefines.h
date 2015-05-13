//
//  SyncanoDefines.h
//  Syncano
//
//  Created by Mariusz Wisniewski on 5/13/15.
//  Copyright (c) 2015 Mindpower. All rights reserved.
//

#ifndef Syncano_SyncanoDefines_h
#define Syncano_SyncanoDefines_h

#ifndef SYNCANO_IS_IOS_VERSION_6_1_OR_LOWER
#define SYNCANO_IS_IOS_VERSION_6_1_OR_LOWER (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
#endif

#ifndef SYNCANO_IS_IOS_VERSION_7_0_OR_HIGHER
#define SYNCANO_IS_IOS_VERSION_7_0_OR_HIGHER (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
#endif

#ifdef DEBUG
#define SyncanoDebugLog(format, ...) {NSLog((format), ##__VA_ARGS__);}
#define SyncanoDebugClassLog(format, ...) {NSLog((@"[%@] " format),NSStringFromClass([self class]), ##__VA_ARGS__);}
#else
#define SyncanoDebugLog(...)
#define SyncanoDebugClassLog(...)
#endif

#endif
