//
//  LRRestyClientDelegate.h
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

@class LRRestyClient;

@protocol LRRestyClientDelegate <NSObject>
@optional
- (void)restyClientWillPerformRequest:(LRRestyClient *)client;
- (void)restyClientDidPerformRequest:(LRRestyClient *)client;
@end
