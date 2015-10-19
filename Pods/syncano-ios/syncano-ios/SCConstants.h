//
//  SCConstants.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 27/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//
#import <Foundation/Foundation.h>

@class SCTrace;
@class SCWebhookResponseObject;
@class SCChannelNotificationMessage;

typedef void (^SCAPICompletionBlock)(NSURLSessionDataTask *task, id responseObject, NSError *error);
typedef void (^SCAPIFileDownloadCompletionBlock)(id responseObject, NSError *error);
typedef void (^SCDataObjectsCompletionBlock)(NSArray *objects, NSError *error);
typedef void (^SCParseObjectCompletionBlock)(id parsedObject, NSError *error);
typedef void (^SCCompletionBlock)(NSError *error);
typedef void (^SCCodeBoxCompletionBlock)(SCTrace *trace,NSError *error);
typedef void (^SCTraceCompletionBlock)(SCTrace *trace, NSError *error);
typedef void (^SCWebhookCompletionBlock)(SCWebhookResponseObject *responseObject,NSError *error);
typedef void (^SCPleaseResolveQueryParametersCompletionBlock)(NSDictionary *queryParameters,NSArray *includeKeys);
typedef void (^SCChannelPublishCompletionBlock)(SCChannelNotificationMessage *notificationMessage, NSError *error);
typedef void (^SCFileFetchCompletionBlock)(NSData *data, NSError *error);

extern NSString * const SCDataObjectErrorDomain;

extern NSString * const kBaseURL;
extern NSString * const kUserKeyKeychainKey;

extern NSString * const kSCPermissionTypeNone;
extern NSString * const kSCPermissionTypeRead;
extern NSString * const kSCPermissionTypeWrite;
extern NSString * const kSCPermissionTypeFull;
extern NSString * const kSCPermissionTypeSubscribe;
extern NSString * const kSCPermissionTypePublish;

extern NSString * const kSCChannelTypeDefault;
extern NSString * const kSCChannelTypeSeparateRooms;

extern NSString * const kSCSocialBackendFacebook;
extern NSString * const kSCSocialBackendGoogle;

extern NSString * const kSCChannelNotificationMessageActionCreate;
extern NSString * const kSCChannelNotificationMessageActionUpdate;
extern NSString * const kSCChannelNotificationMessageActionDelete;

typedef NS_ENUM(NSUInteger, SCDataObjectPermissionType) {
    SCDataObjectPermissionTypeNone,
    SCDataObjectPermissionTypeRead,
    SCDataObjectPermissionTypeWrite,
    SCDataObjectPermissionTypeFull,
};

typedef NS_ENUM(NSUInteger, SCChannelPermisionType) {
    SCChannelPermisionTypeNone,
    SCChannelPermisionTypeSubscribe,
    SCChannelPermisionTypePublish,
};

typedef NS_ENUM(NSUInteger, SCChannelType) {
    SCChannelTypeDefault,
    SCChannelTypeSeparateRooms
};

typedef NS_ENUM(NSUInteger, SCSocialAuthenticationBackend) {
    SCSocialAuthenticationBackendFacebook,
    SCSocialAuthenticationBackendGoogle,
};

typedef NS_ENUM(NSUInteger, SCChannelNotificationMessageAction) {
    SCChannelNotificationMessageActionNone,
    SCChannelNotificationMessageActionCreate,
    SCChannelNotificationMessageActionUpdate,
    SCChannelNotificationMessageActionDelete,
};

typedef NS_ENUM(NSUInteger, SCErrorCode) {
    SCErrorCodeDataObjectWrongParentClass = 1,
};


@interface SCConstants : NSObject
+ (SCDataObjectPermissionType)dataObjectPermissiontypeByString:(NSString *)typeString;
+ (SCChannelPermisionType)channelPermissionTypeByString:(NSString *)typeString;
+ (SCChannelType)channelTypeByString:(NSString *)typeString;
+ (NSString *)socialAuthenticationBackendToString:(SCSocialAuthenticationBackend)backend;
+ (NSValueTransformer *)SCDataObjectPermissionsValueTransformer;
+ (SCChannelNotificationMessageAction)channelNotificationMessageActionByString:(NSString *)actionString;
@end