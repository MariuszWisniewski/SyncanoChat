//
//  SCSchema.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 02/04/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle/Mantle.h"

@interface SCSchemaItem : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *target;
@end

@interface SCSchema : NSObject
@property (nonatomic,readonly) NSArray *items;
- (instancetype)initWithArrayOfJSONDictionaryObjects:(NSArray *)objects;
@end
