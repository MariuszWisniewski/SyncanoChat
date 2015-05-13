//
//  SyncanoParameters_Administrators.h
//  Syncano
//
//  Created by Syncano Inc. on 12/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters.h"

/**
 Adds a new administrator to current instance. Account with admin_email must exist in Syncano. Only Admin permission role can add new administrators.
 */
@interface SyncanoParameters_Administrators_New : SyncanoParameters
@property (strong)    NSString *adminEmail;
@property (strong)    NSString *roleId;
@property (strong)    NSString *message;

/**
 
 @param adminEmail Email of admin to add
 @param roleId     Initial role for current instance
 @param message    Message
 
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Administrators_New*)initWithAdminEmail:(NSString*)adminEmail roleId:(NSString*)roleId message:(NSString*)message;

@end

/**
 Get all administrators of current instance.
 */
@interface SyncanoParameters_Administrators_Get : SyncanoParameters
@end

/**
 Gets admin info with specific id or email from current instance. admin_id/admin_email parameter means that one can use either one of them - admin_id or admin_email.
 */
@interface SyncanoParameters_Administrators_GetOne : SyncanoParameters
/**
 Use only one from the admin_id/admin_email pair
 */
@property (strong) NSString *adminId;
/**
 Use only one from the admin_id/admin_email pair
 */
@property (strong) NSString *adminEmail;

/**
 
 @param adminId ID of administrator
 
 @return SyncanoParameters object with required field initialized
 */
- (SyncanoParameters_Administrators_GetOne*)initWithAdminId:(NSString*)adminId;
/**
 
 @param adminEmail Email of administrator
 
 @return SyncanoParameters object with required field initialized
 */
- (SyncanoParameters_Administrators_GetOne*)initWithAdminEmail:(NSString*)adminEmail;

@end

/**
 Updates specified admin's permission role. Only Admin permission role can edit administrators. admin_id/admin_email parameter means that one can use either one of them - admin_id or admin_email.
 */
@interface SyncanoParameters_Administrators_Update : SyncanoParameters
/**
 Use only one from the admin_id/admin_email pair
 */
@property (strong) NSString *adminId;
/**
 Use only one from the admin_id/admin_email pair
 */
@property (strong) NSString *adminEmail;
/**
 New admin's instance role id to set
 */
@property (strong) NSString *roleId;
/**
 
 @param adminId ID of administartor
 @param roleId  Administators instance role id to set
 
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Administrators_Update*)initWithAdminId:(NSString*)adminId roleId:(NSString*)roleId;
/**
 
 @param adminEmail Email of administartor
 @param roleId  Administators instance role id to set
 
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Administrators_Update*)initWithAdminEmail:(NSString*)adminEmail roleId:(NSString*)roleId;

@end
/**
 Deletes specified administrator from current instance. Only Admin permission role can delete administrators. admin_id/admin_email parameter means that one can use either one of them - admin_id or admin_email.
 */
@interface SyncanoParameters_Administrators_Delete : SyncanoParameters
/**
 Use only one from the admin_id/admin_email pair
 */
@property (strong) NSString *adminId;
/**
 Use only one from the admin_id/admin_email pair
 */
@property (strong) NSString *adminEmail;

/**
 
 @param adminId ID of administrator
 
 @return SyncanoParameters object with required field initialized
 */
- (SyncanoParameters_Administrators_Delete*)initWithAdminId:(NSString*)adminId;
/**
 
 @param adminEmail Email of administrator
 
 @return SyncanoParameters object with required field initialized
 */
- (SyncanoParameters_Administrators_Delete*)initWithAdminEmail:(NSString*)adminEmail;

@end
