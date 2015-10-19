//
//  SCParseManager+SCUser.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 07/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCParseManager.h"
@class SCUser;

@interface SCParseManager (SCUser)


@property (nonatomic,readonly) Class userClass;
@property (nonatomic,readonly) Class userProfileClass;


/**
 *  Registers class for user subclassing
 *
 *  @param classToRegister
 */
- (void)registerUserClass:(__unsafe_unretained Class)classToRegister;

/**
 *  Registers class for subclassing user profile
 *
 *  @param classToRegister
 */
- (void)registerUserProfileClass:(__unsafe_unretained Class)classToRegister;

- (id)parsedUserObjectFromJSONObject:(id)JSONObject;
@end
