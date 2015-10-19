//
//  SCCoumpoundPredicate.h
//  syncano-ios
//
//  Created by Jan Lipmann on 19/09/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPredicateProtocol.h"

@interface SCCompoundPredicate : NSObject <SCPredicateProtocol>
+ (instancetype)compoundPredicateWithPredicates:(NSArray *)predicates;
- (instancetype)initWithPredicates:(NSArray *)predicates;
- (void)addPredicate:(id<SCPredicateProtocol>)predicate;
@end
