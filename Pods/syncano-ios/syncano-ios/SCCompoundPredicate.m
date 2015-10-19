//
//  SCCoumpoundPredicate.m
//  syncano-ios
//
//  Created by Jan Lipmann on 19/09/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCCompoundPredicate.h"


@interface SCCompoundPredicate ()
@property (strong,nonatomic) NSMutableArray* predicates;
@end

@implementation SCCompoundPredicate

- (instancetype)init
{
    self = [super init];
    if (self) {
        _predicates = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithPredicates:(NSArray *)predicates {
    self = [self init];
    if (self) {
        _predicates = [predicates mutableCopy];
    }
    return self;
}

+ (instancetype)compoundPredicateWithPredicates:(NSArray *)predicates {
    return [[self alloc] initWithPredicates:predicates];
}

- (void)addPredicate:(id<SCPredicateProtocol>)predicate {
    if (!predicate || ![predicate conformsToProtocol:@protocol(SCPredicateProtocol)]) {
        return;
    }
    [self.predicates addObject:predicate];
}

-(NSString *)queryRepresentation {
    NSMutableString* query = [NSMutableString stringWithString:@"{"];
    
    int i=0;
    for(id<SCPredicateProtocol> predicate in self.predicates) {
        if(i!=0) {
            [query appendString:@","];
        }
        NSString* localQuery = [predicate queryRepresentation];
        localQuery = [localQuery substringWithRange:NSMakeRange(1, localQuery.length-2)];
        [query appendString:localQuery];
        i++;
    }
    
    [query appendString:@"}"];
    
    return query;
}

@end
