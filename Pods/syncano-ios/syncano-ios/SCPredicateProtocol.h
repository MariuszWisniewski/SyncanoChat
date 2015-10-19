//
//  SCPredicateProtocol.h
//  syncano-ios
//
//  Created by Jan Lipmann on 19/09/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCPredicateProtocol <NSObject>
@required
- (NSString *)queryRepresentation;
@end
