//
//  LRRestClientDelegate.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRRestyClient;
@class LRRestyResponse;
@class LRRestyRequest;

@protocol LRRestyClientResponseDelegate <NSObject>
- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response;
@optional
- (void)restClient:(LRRestyClient *)client willPerformRequest:(LRRestyRequest *)request;
- (void)restClient:(LRRestyClient *)client request:(LRRestyRequest *)request receivedData:(NSData *)data;
@end
