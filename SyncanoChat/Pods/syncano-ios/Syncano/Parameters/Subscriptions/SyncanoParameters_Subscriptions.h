//
//  SyncanoParameters_Subscriptions.h
//  Syncano
//
//  Created by Syncano Inc. on 07/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters.h"

/**
   Subscribe to project level notifications - will get all notifications in contained collections.
 */
@interface SyncanoParameters_Subscriptions_SubscribeProject : SyncanoParameters
/**
   Project id.
 */
@property (strong)    NSString *projectId;
/**
   Context to subscribe within. Possible values:
   - client (default) - subscribe all connections of current API client,
   - session - store subscription in current session,
   - connection - subscribe current connection only (requires Sync Server connection).
 */
@property (strong)    NSString *context;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Subscriptions_SubscribeProject *)initWithProjectId:(NSString *)projectId context:(NSString *)context;

@end

/**
   Unsubscribe from a project. Unsubscribing will work in context that it was originally created for.
 */
@interface SyncanoParameters_Subscriptions_UnsubscribeProject : SyncanoParameters
/**
   Project id.
 */
@property (strong)    NSString *projectId;

- (SyncanoParameters_Subscriptions_UnsubscribeProject *)initWithProjectId:(NSString *)projectId;

@end

/**
   Subscribe to collection level notifications within a specified project.
 */
@interface SyncanoParameters_Subscriptions_SubscribeCollection : SyncanoParameters
/**
   Project id.
 */
@property (strong)    NSString *projectId;
/**
   Collection id or key defining collection.
 */
@property (strong)    NSString *collectionId;
/**
   Collection id or key defining collection.
 */
@property (strong)    NSString *collectionKey;
/**
   Context to subscribe within. Possible values:
   - client (default) - subscribe all connections of current API client,
   - session - store subscription in current session,
   - connection - subscribe current connection only (requires Sync Server connection).
 */
@property (strong)    NSString *context;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Subscriptions_SubscribeCollection *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId context:(NSString *)context;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Subscriptions_SubscribeCollection *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey context:(NSString *)context;

@end

/**
   Unsubscribe from a collection within a specified project. Unsubscribing will work in context that it was originally created for.
 */
@interface SyncanoParameters_Subscriptions_UnsubscribeCollection : SyncanoParameters_ProjectId_CollectionId_CollectionKey

@end

/**
   Get API client subscriptions.
 */
@interface SyncanoParameters_Subscriptions_Get : SyncanoParameters
/**
   API client id defining client. If not present, gets subscriptions for current API client.
 */
@property (strong)    NSString *apiClientId;
/**
   Session id associated with API client. If present, gets subscriptions associated with specified API client's session.
 */
@property (strong)    NSString *sessionId;
/**
   Connection UUID. If present, gets subscriptions associated with specified API client's connection.
 */
@property (strong)    NSString *uuid;


@end
