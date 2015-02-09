//
//  SyncanoProtocolRequest.h
//  Syncano
//
//  Created by Mariusz Wisniewski on 22/08/14.
//  Copyright (c) 2014 Mindpower. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This protocol provides functionality of 'AFURLConnectionOperation' and 
 underlying NSOperation, which are used to queue all requests being
 sent with Syncano iOS library.
 
 It forwards all calls being passed to instances of this objects implementing
 this protocol, to proper instance of 'AFURLConnectionOperation'
 or its subclasses.
 
 It was created, to hide from Syncano's iOS Library user, implementation
 of network connectivity based on AFNetworking - developer should not be
 forced to include other frameworks headers, if he meant to use only
 Syncano Framework.
 */
@protocol SyncanoRequest <NSObject>

@required

- (BOOL)isCancelled;
- (void)cancel;

- (BOOL)isExecuting;
- (BOOL)isFinished;

/**
 Pauses the execution of the request operation.
 
 A paused request returns `NO` for `-isExecuting`, and `-isFinished`. As such, it will remain in an internal requests queue until it is either cancelled or resumed. Pausing a finished, cancelled, or paused operation has no effect.
 */
- (void)pause;

/**
 Whether the request operation is currently paused.
 
 @return `YES` if the request is currently paused, otherwise `NO`.
 */
- (BOOL)isPaused;

/**
 Resumes the execution of the paused request operation.
 
 Pause/Resume behavior varies depending on the underlying implementation for the operation class. In its base implementation, resuming a paused requests restarts the original request. However, since HTTP defines a specification for how to request a specific content range, 'SyncanoRequest' will resume downloading the request from where it left off, instead of restarting the original request.
 */
- (void)resume;

@end
