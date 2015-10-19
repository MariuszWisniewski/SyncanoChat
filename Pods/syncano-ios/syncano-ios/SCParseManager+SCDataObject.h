//
//  SCParseManager+SCDataObject.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 07/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCParseManager.h"
#import "SCDataObject.h"
/**
 *  Class contains info about registered class for subclassing
 */
@interface SCClassRegisterItem : NSObject
/**
 *  Name of class using in Syncano
 */
@property (nonatomic,copy) NSString *classNameForAPI;

/**
 *  Local reference of subslassed class
 */
@property (nonatomic, copy) Class classReference;
/**
 *  Local name of subslassed class
 */
@property (nonatomic,copy) NSString *className;
/**
 *  Dictionary stores property names as keys and type names as values
 */
@property (nonatomic,copy) NSDictionary *properties;
@end


@interface SCParseManager (SCDataObject)

/**
 *  Array of SCClassRegisterItems
 */
@property (nonatomic,readonly) NSMutableArray *registeredClasses;


/**
 *  Attempts to parse JSON to SCDataObject
 *
 *  @param objectClass Class of object to parse for
 *  @param JSONObject  serialiazed JSON object from API response
 *
 *  @return parsed SCDataObject
 */
- (id)parsedObjectOfClass:(__unsafe_unretained Class)objectClass
           fromJSONObject:(id)JSONObject;

/**
 *  Attempts to parse JSON response object to array of SCDataObjects
 *
 *  @param objectClass    objectClass Class of object to parse for
 *  @param responseObject JSON object with array of serialized JSON objects from API response
 *  @return NSArray with parsed SCDataObjects
 */
- (NSArray *)parsedObjectsOfClass:(__unsafe_unretained Class)objectClass
                   fromJSONObject:(id)responseObject;


/**
 *  Attempt to fill provided SCDataObject with data from JSON response object. 
 *
 *  @param object         SCDataObject to update
 *  @param responseObject JSON response object to update from
 */
- (void)fillObject:(SCDataObject *)object withDataFromJSONObject:(id)responseObject;

/**
 *  Converts SCDataObject to NSDictionary representation
 *
 *  @param dataObject SCDataObject to convert
 *
 *  @return JSON representation of SCDataObject
 */
- (NSDictionary *)JSONSerializedDictionaryFromDataObject:(SCDataObject *)dataObject error:(NSError **)error;

/**
 *  Registers class for subclassing
 *
 *  @param classToRegister
 */
- (void)registerClass:(__unsafe_unretained Class)classToRegister;

/**
 *  Returns registered item for provided class
 *
 *  @param registeredClass class to look up register for
 *
 *  @return SCClassRegisterItem for provided class or nil
 */
- (SCClassRegisterItem *)registeredItemForClass:(__unsafe_unretained Class)registeredClass;

/**
 *  Returns relations for provided class
 *
 *  @param class provided class
 *
 *  @return NSDictionary with property name as 'key' and SCClassRegisterItem as 'value' or empty NSDictionary if there are no relations
 */
- (NSDictionary *)relationsForClass:(__unsafe_unretained Class)class;


@end
