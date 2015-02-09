//
//  SyncanoReachability.h
//  Syncano
//
//  Created by Mariusz Wisniewski on 25/08/14.
//  Copyright (c) 2014 Mindpower. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, SyncanoNetworkReachabilityStatus) {
	SyncanoNetworkReachabilityStatusUnknown          = -1,
	SyncanoNetworkReachabilityStatusNotReachable     = 0,
	SyncanoNetworkReachabilityStatusReachableViaWWAN = 1,
	SyncanoNetworkReachabilityStatusReachableViaWiFi = 2
};

/**
 This class provides functionality of 'AFNetworkReachabilityManager', which
 monitors the reachability of domains, and addresses for both WWAN and WiFi
 network interfaces.
 
 It forwards all calls being passed to instances of this class, to proper
 instance of AFNetworkReachabilityManager, observing Syncano domain.
 
 It was created, to hide from Syncano's iOS Library user, implementation
 of network connectivity based on AFNetworking - developer should not be
 forced to include other frameworks headers, if he meant to use only
 Syncano Framework.
 */

@interface SyncanoReachability : NSObject

/**
 Current domain, for which status is being observed
 */
@property (strong, readonly, nonatomic) NSString *domain;

/**
 Creates and initializes object of class SyncanoReachability
 
 @param domain Domain for which reachability object will be created
 
 @return Created reachability object, observing availability of given domain
 */
+ (instancetype)reachabilityForDomain:(NSString *)domain;

/**
 The current network reachability status.
 */
@property (readonly, nonatomic, assign) SyncanoNetworkReachabilityStatus networkReachabilityStatus;

/**
 Whether or not the network is currently reachable.
 */
@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;

/**
 Whether or not the network is currently reachable via WWAN.
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;

/**
 Whether or not the network is currently reachable via WiFi.
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

/**
 Starts monitoring for changes in network reachability status.
 */
- (void)startMonitoring;

/**
 Stops monitoring for changes in network reachability status.
 */
- (void)stopMonitoring;

/**
 Sets a callback to be executed when the network availability of the `baseURL` host changes.
 
 @param block A block object to be executed when the network availability of the `baseURL` host changes.. This block has no return value and takes a single argument which represents the various reachability states from the device to the `baseURL`.
 */
- (void)setReachabilityStatusChangeBlock:(void (^)(SyncanoNetworkReachabilityStatus status))block;

///--------------------
/// @name Notifications
///--------------------

/**
 Posted when network reachability changes.
 This notification assigns no notification object. The `userInfo` dictionary contains an `NSNumber` object under the `SyncanoNetworkingReachabilityNotificationStatusItem` key, representing the `SyncanoNetworkReachabilityStatus` value for the current network reachability.
 */
extern NSString *const SyncanoNetworkingReachabilityDidChangeNotification;
extern NSString *const SyncanoNetworkingReachabilityNotificationStatusItem;

@end
