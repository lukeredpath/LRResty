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

@protocol LRRestyRequestDelegate <NSObject>
- (void)restyRequest:(LRRestyRequest *)request didFinishWithResponse:(LRRestyResponse *)response;
@optional
- (void)restyRequestDidStart:(LRRestyRequest *)request;
- (void)restyRequest:(LRRestyRequest *)request didReceiveData:(NSData *)data;
@end
