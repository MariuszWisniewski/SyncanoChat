//
//  SCSchema.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 02/04/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCSchema.h"

@implementation SCSchemaItem
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}
@end


@interface SCSchema ()
@property (nonatomic,retain) NSArray *schemaItems;
@end

@implementation SCSchema

- (instancetype)initWithArrayOfJSONDictionaryObjects:(NSArray *)objects {
    self = [super init];
    if (self) {
        [self parseSchemaItemsFromArrayOfJSONObjects:objects];
    }
    return self;
}

- (void)parseSchemaItemsFromArrayOfJSONObjects:(NSArray *)objects {
    NSMutableArray *parsedObjects = [[NSMutableArray alloc] initWithCapacity:objects.count];
    for (NSDictionary *object in objects) {
        NSError *error;
        SCSchemaItem *item = [MTLJSONAdapter modelOfClass:[SCSchemaItem class] fromJSONDictionary:object error:&error];
        if (!error) {
            [parsedObjects addObject:item];
        }
    }
    self.schemaItems = parsedObjects;
}

- (NSArray *)items {
    return self.schemaItems;
}

@end
