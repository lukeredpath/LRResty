//
//  LRRestyClientDelegate.h
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

@class LRRestyClient;

/**
 * The LRRestyClient delegate can be used to respond to the lifecycle of
 * all requests performed by the client.
 */
@protocol LRRestyClientDelegate <NSObject>
@optional
/**
 * Will be called before the request is added to the operation queue.
 */
- (void)restyClientWillPerformRequest:(LRRestyClient *)client;

/**
 * Will be called after the request completes 
 */
- (void)restyClientDidPerformRequest:(LRRestyClient *)client;
@end
