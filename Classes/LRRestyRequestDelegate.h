//
//  LRRestyRequestDelegate.h
//  LRResty
//
//  Created by Luke Redpath on 29/09/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRRestyClient;
@class LRRestyResponse;
@class LRRestyRequest;

/**
 * Implemented by objects that respond to the lifecycle of an individual request.
 * This is used internally and will not normally need to be implemented by end users.
 */
@protocol LRRestyRequestDelegate <NSObject>
- (void)restyRequest:(LRRestyRequest *)request didFinishWithResponse:(LRRestyResponse *)response;
@optional
- (void)restyRequestDidStart:(LRRestyRequest *)request;
- (void)restyRequest:(LRRestyRequest *)request didReceiveData:(NSData *)data;
- (void)restyRequest:(LRRestyRequest *)request didFailWithError:(NSError *)error;
@end
