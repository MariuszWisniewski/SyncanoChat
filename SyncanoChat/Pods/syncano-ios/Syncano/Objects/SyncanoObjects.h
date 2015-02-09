//
//  SyncanoObjects.h
//  Syncano
//
//  Created by Syncano Inc. on 08/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>
#import "SyncanoDateFormatter.h"

/**
 Informs about kind of change in SyncanoDataChange object
 */
typedef NS_ENUM (NSUInteger, SyncanoChange) {
	/**
   No changes were made in Data object.
	 */
	SyncanoChange_NO_CHANGE = 0,
	/**
   Changes in object parameters were made.
	 */
	SyncanoChange_REPLACE = 1,
	/**
   Some of object parameters were removed.
	 */
	SyncanoChange_DELETED = 2,
	/**
   Parameters were added to the object.
	 */
	SyncanoChange_ADDED = 3
};

/**
 Base class for all Syncano-sourced objects
 */
@interface SyncanoObject : MTLModel <MTLJSONSerializing>

/**
 Creates Syncano object from passed JSON dictionary. Overriden by all subclasses.
 
 @param json JSON `descriptionString` of object.
 
 @return Syncano object created from passed JSON.
 */
+ (instancetype)objectFromJSON:(NSDictionary *)json;

@end

@class SyncanoClient, SyncanoProject, SyncanoCollection, SyncanoFolder;
@class SyncanoAvatar, SyncanoImage, SyncanoUser, SyncanoData, SyncanoDataChanges;
@class SyncanoSubscription, SyncanoRole, SyncanoAdmin, SyncanoIdentity;
@class SyncanoApiKey, SyncanoChannel;

/**
 Syncano API client
 */
@interface SyncanoClient : SyncanoObject
/// API client id
@property (strong)    NSString *uid;
///  API client descriptionString
@property (strong)    NSString *descriptionString;
/// API key
@property (strong)    NSString *apiKey;
/// Role
@property (strong)    SyncanoRole *role;
@end

/**
 Syncano APIKey client
 */
@interface SyncanoApiKey : SyncanoObject
/// API client id
@property (strong)    NSString *uid;
/**
 API client type - possible values:
 backend - Backend API client,
 user - User API client.
 */
@property (strong)    NSString *type;
///  API client descriptionString
@property (strong)    NSString *descriptionString;
/// API key
@property (strong)    NSString *apiKey;
/// Role
@property (strong)    SyncanoRole *role;
@end


/**
 Syncano Client Connection
 */
@interface SyncanoConnection : SyncanoObject
/**
 Connection id - used for paginating with since_id
 */
@property (strong)    NSString *uid;
/**
 Connection UUID - used to uniquely identify connection
 */
@property (strong)    NSString *uuid;
/**
 API client id
 */
@property (strong)    NSString *apiClientId;
/**
 Connection name
 */
@property (strong)    NSString *name;
/**
 Connection state
 */
@property (strong)    NSString *state;
/**
 Connection source - takes values:
 - TCP
 - WebSocket.
 */
@property (strong)    NSString *source;
@end

/**
 Project object from Syncano API
 */
@interface SyncanoProject : SyncanoObject
/// Project id
@property (strong)  NSString *uid;
/// Project name
@property (strong)  NSString *name;
/// (optional) - project descriptionString - if set
@property (strong)  NSString *descriptionString;
@end

/**
 Syncano Collection from Syncano API
 */
@interface SyncanoCollection : SyncanoObject
/// Collection id
@property (strong)  NSString *uid;
/// Status: active/inactive
@property (strong)  NSString *status;
/// Collection name
@property (strong)  NSString *name;
/// (optional) - collection descriptionString - if set
@property (strong)  NSString *descriptionString;
/// Collection key
@property (strong)  NSString *key;
/// Date when collection became active - can be empty for new collections
@property (strong)  NSDate *startDate;
/// Date when collection became inactive - empty for active collections
@property (strong)  NSDate *endDate;
/// Consisting of arbitrary tags defined as name (string) - weight (decimal) pairs
@property (strong)  NSDictionary *tags;
@end

/**
 Syncano Folder, container for Syncano Data Objects
 */
@interface SyncanoFolder : SyncanoObject
/// Folder id
@property (strong)    NSString *uid;
/// If false, client is not allowed to modify it
@property (strong)    NSNumber *isCustom;
/// Folder name
@property (strong)    NSString *name;
/// Optional source id used for mapping folders to external sources
@property (strong)    NSString *sourceId;
@end

/**
 Image avatar, can be assigned to user
 */
@interface SyncanoAvatar : SyncanoObject
/// Image URL
@property (strong)    NSString *image;
/// Image width
@property (strong)    NSNumber *imageWidth;
/// Image height
@property (strong)    NSNumber *imageHeight;
/// Thumbnail URL
@property (strong)    NSString *thumbnail;
/// Thumbnail width
@property (strong)    NSNumber *thumbnailWidth;
/// Thumbnail height
@property (strong)    NSNumber *thumbnailHeight;
@end

/**
 Image, can be contained in Syncano Data Object
 */
@interface SyncanoImage : SyncanoObject
/// Image URL
@property (strong)    NSString *image;
/// Image width
@property (strong)    NSNumber *imageWidth;
/// Image height
@property (strong)    NSNumber *imageHeight;
/// Thumbnail URL
@property (strong)    NSString *thumbnail;
/// Thumbnail width
@property (strong)    NSNumber *thumbnailWidth;
/// Thumbnail height
@property (strong)    NSNumber *thumbnailHeight;
/// Optional, Image source URL
@property (strong)    NSString *sourceUrl;
@end

/**
 Syncano internal user
 */
@interface SyncanoUser : SyncanoObject
/// Id of user
@property (strong)    NSString *uid;
/// Username - unique string
@property (strong)    NSString *name;
/// User nickname
@property (strong)    NSString *nick;
/// User avatar
@property (strong)    SyncanoAvatar *avatar;

- (NSString *)displayedName;

@end

/**
 Syncano Data Object
 */
@interface SyncanoData : SyncanoObject <NSCopying>
/// Only present if parent_ids is defined, provides information about which parent connection was used. Takes only values from parentIds list in data.get()
@property (strong)    NSString *parentId;
/// Only present if child_ids is defined, provides information about which child connection was used. Takes only values from child_ids list in data.get()
@property (strong)  NSString *childId;
/// id of data for future reference
@property (strong)    NSString *uid;
/// date and time of creation
@property (strong)    NSDate *createdAt;
/// date and time of last update
@property (strong)    NSDate *updatedAt;
/// Folder name
@property (strong)    NSString *folder;
/// State: possible values: Pending, Moderated, Rejected
@property (strong)    NSString *state;
/// User
@property (strong)    SyncanoUser *user;
/// Used to uniquely define data object
@property (strong)    NSString *key;
/// Title
@property (strong)    NSString *title;
/// Text
@property (strong)    NSString *text;
/// Link
@property (strong)    NSString *link;
/// URL associated with data object's source
@property (strong)    NSString *sourceUrl;
/// Image
@property (strong)    SyncanoImage *image;
/// Consisting of arbitrary string data defined as key - value (string) pairs
@property (strong)    NSDictionary *additional;
/// Consisting of child Data Objects array (same structure, recursively)
@property (strong)    NSArray *children;
/// Number of associated children
@property (strong)    NSNumber *childrenCount;
/// Filterable integeres - optional
@property (assign)  NSInteger data1;
@property (assign)  NSInteger data2;
@property (assign)  NSInteger data3;
@end

/**
 Contains information about data relation that was changed (either added or deleted)
 */
@interface SyncanoDataRelation : SyncanoObject <NSCopying>
//parent id of relation that was changed
@property (strong) NSString *parentId;
// child id of relation that was changed
@property (strong) NSString *childId;
@end

/**
 Informs about Data Object changes received by notification from Sync Server.
 */
@interface SyncanoDataChanges : SyncanoData <NSCopying>
/**
 Use to receive names of properties that were replaced with new values.
 
 @return Array of property names which values were replaced.
 */
- (NSArray *)getReplaced;
/**
 Use to receive names of properties that were deleted from the object.
 
 @return Array of property names which were deleted from the object.
 */
- (NSArray *)getDeleted;
/**
 Use to receive names of properties that were added to the object.
 @return Array of property names which values were replaced.
 */
- (NSArray *)getAdded;
/**
 Use to check change status of given property.
 
 ```
 SyncanoDataChanges *changes = ... // receive object
 SyncanoChange objectChange = [changes getChange:changes.text];
 switch (objectChange) {
 case SyncanoChange_DELETED:
 //...
 break;
 default:
 break;
 }
 ```
 
 @param property One of the properties of object which method you're calling.
 
 @return Change status of given property.
 */
- (SyncanoChange)getChange:(id)property;
@end

/**
 Syncano Client Subscription Information from Syncano API
 */
@interface SyncanoSubscription : SyncanoObject
/**
 Subscription type (e.g. Project, Collection).
 */
@property (strong) NSString *type;
/**
 Subscription object id (e.g. project_id if type is equal Project)
 */
@property (strong) NSString *uid;
/**
 Subscription context - client, session or connection
 */
@property (strong) NSString *context;
@end

/**
 Syncano Role information for Role object from Syncano API
 */
@interface SyncanoRole : SyncanoObject
/// Role id
@property (strong) NSString *uid;
/// Role name
@property (strong) NSString *name;
@end

/**
 Administrator object from Syncano API
 */
@interface SyncanoAdmin : SyncanoObject
/// admin id
@property (strong) NSString *uid;
/// admin email
@property (strong) NSString *email;
/// admin first name
@property (strong) NSString *firstName;
/// admin last name
@property (strong) NSString *lastName;
/// date and time of last successful login
@property (strong) NSDate *lastLogin;
/// role
@property (strong) SyncanoRole *role;

@end

/**
 Channel info of object received through subscription
 */
@interface SyncanoChannel : SyncanoObject

/// Project id, where object came from
@property (strong) NSString *projectId;
/// Collection id, where object came from
@property (strong) NSString *collectionId;
/// Folder where object came from, not present for relationship changes - see parentFolder, or childFolder
@property (strong) NSString *folder;
// Folder where parent is stored for relationship change
@property (strong) NSString *parentFolder;
// Folder where child is stored for relationship changes
@property (strong) NSString *childFolder;

@end
