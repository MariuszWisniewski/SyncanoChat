//
//  SCUser.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 06/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//
#import "Syncano.h"
#import "SCUser.h"
#import "SCPlease.h"
#import "SCAPIClient.h"
#import "NSObject+SCParseHelper.h"
#import "SCParseManager+SCUser.h"
#import "UICKeyChainStore/UICKeyChainStore.h"
#import "NSObject+SCParseHelper.h"


static NSString *const kCurrentUser = @"com.syncano.kCurrentUser";
static id _currentUser;

@implementation SCUser

- (void)fillWithJSONObject:(id)JSONObject {
    self.userId = [JSONObject[@"id"] sc_numberOrNil];
    self.username = [JSONObject[@"username"] sc_stringOrEmpty];
    self.links = [JSONObject[@"links"] sc_dictionaryOrNil];
}

- (NSString *)userKey {
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.syncano"];
    NSString *userKey = [keychain stringForKey:kUserKeyKeychainKey];
    return userKey;
}

+ (instancetype)currentUser {
    if (_currentUser) {
        return _currentUser;
    }
    id archivedUserData = [self JSONUserDataFromDefaults];
    if (archivedUserData) {
        _currentUser = [[SCParseManager sharedSCParseManager] parsedUserObjectFromJSONObject:archivedUserData];
        return _currentUser;
    }
    return nil;
}

+ (id)JSONUserDataFromDefaults {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUser];
    if (data) {
        id userData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return userData;
    }
    return nil;
}

+ (void)saveJSONUserData:(id)JSONUserData {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:JSONUserData];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)registerClass {
    [self registerClassWithProfileClass:nil];
}

+(void)registerClassWithProfileClass:(__unsafe_unretained Class)profileClass {
    [[SCParseManager sharedSCParseManager] registerUserClass:[self class]];
    if (profileClass) {
        [[SCParseManager sharedSCParseManager] registerUserProfileClass:profileClass];
    } else {
        [[SCParseManager sharedSCParseManager] registerUserProfileClass:[SCUserProfile class]];
    }
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(SCCompletionBlock)completion{
    [self loginWithUsername:username password:password usingAPIClient:[Syncano sharedAPIClient] completion:completion];
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password toSyncano:(Syncano *)syncano completion:(SCCompletionBlock)completion {
    [self loginWithUsername:username password:password usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password usingAPIClient:(SCAPIClient *)apiClient completion:(SCCompletionBlock)completion {
    NSDictionary *params = @{@"username" : username , @"password" : password};
    [apiClient postTaskWithPath:@"user/auth/" params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            completion(error);
        } else {
            [self saveJSONUserData:responseObject];
            completion(nil);
        }
    }];
}

+ (void)registerWithUsername:(NSString *)username password:(NSString *)password completion:(SCCompletionBlock)completion {
    [self registerWithUsername:username password:password usingAPIClient:[Syncano sharedAPIClient] completion:completion];
}

+ (void)registerWithUsername:(NSString *)username password:(NSString *)password inSyncano:(Syncano *)syncano completion:(SCCompletionBlock)completion {
    [self registerWithUsername:username password:password usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)registerWithUsername:(NSString *)username password:(NSString *)password usingAPIClient:(SCAPIClient *)apiClient completion:(SCCompletionBlock)completion {
    //TODO: validate if username and password are not empty or maybe leave it to API :)
    NSDictionary *params = @{@"username" : username , @"password" : password};
    [apiClient postTaskWithPath:@"users/" params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            completion(error);
        } else {
            [self saveJSONUserData:responseObject];
            completion(nil);
        }
    }];
}

+ (void)loginWithSocialBackend:(SCSocialAuthenticationBackend)backend authToken:(NSString *)authToken completion:(SCCompletionBlock)completion {
    [self loginWithSocialBackend:backend authToken:authToken usingAPIClient:[Syncano sharedAPIClient] completion:completion];
}

+ (void)loginWithSocialBackend:(SCSocialAuthenticationBackend)backend authToken:(NSString *)authToken toSyncano:(Syncano *)syncano completion:(SCCompletionBlock)completion {
    [self loginWithSocialBackend:backend authToken:authToken usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)loginWithSocialBackend:(SCSocialAuthenticationBackend)backend authToken:(NSString *)authToken usingAPIClient:(SCAPIClient *)apiClient completion:(SCCompletionBlock)completion {
    [apiClient setSocialAuthTokenKey:authToken];
    NSString *path = [NSString stringWithFormat:@"user/auth/%@/", [SCConstants socialAuthenticationBackendToString:backend]];
    [apiClient postTaskWithPath:path params:nil completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            completion(error);
        } else {
            [self saveJSONUserData:responseObject];
            completion(nil);
        }
    }];

}

- (void)logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.syncano"];
    [keychain removeItemForKey:kUserKeyKeychainKey];
    _currentUser = nil;
}

+ (SCPlease *)please {
    return [SCUserProfile please];
}

+ (SCPlease *)pleaseFromSyncano:(Syncano *)syncano {
    return [SCUserProfile pleaseFromSyncano:syncano];
}

- (void)updateUsername:(NSString *)username withCompletion:(SCCompletionBlock)completion {
    [self updateUsername:username password:nil usingAPIClient:[Syncano sharedAPIClient] withCompletion:completion];
}
- (void)updateUsername:(NSString *)username inSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion {
    [self updateUsername:username password:nil usingAPIClient:syncano.apiClient withCompletion:completion];
}

- (void)updatePassword:(NSString *)password withCompletion:(SCCompletionBlock)completion {
    [self updateUsername:nil password:password usingAPIClient:[Syncano sharedAPIClient] withCompletion:completion];
}
- (void)updatePassword:(NSString *)password inSyncno:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion {
    [self updateUsername:nil password:password usingAPIClient:syncano.apiClient withCompletion:completion];
}


- (void)updateUsername:(NSString *)username password:(NSString *)password usingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (username.length > 0) {
        self.username = username;
        [params setObject:username forKey:@"username"];
    }
    if (password.length > 0) {
        [params setObject:password forKey:@"password"];
    }
    NSString *path = @"user/";
    [apiClient patchTaskWithPath:path params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        completion(error);
    }];

}
@end
