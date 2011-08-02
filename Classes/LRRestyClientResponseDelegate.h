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

/**
 * Objects should implement this protocol if they want to be used for delegate-based
 * response handling.
 */
@protocol LRRestyClientResponseDelegate <NSObject>

/**
 * Returns the received response 
 * @param client    The client performing the request.
 * @param response  The received response.
 */
- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response;

@optional

/**
 * Called before the request is added to the operation queue
 * @param client    The client performing the request.
 * @param request   The request about to be performed.
 */
- (void)restClient:(LRRestyClient *)client willPerformRequest:(LRRestyRequest *)request;

/**
 * Called every time a chunk of data is received from the server.
 * This can be useful when dealing with streaming APIs.
 * @param client    The client performing the request
 * @param request   The request in progress.
 * @param data      The chunk of data received.
 */
- (void)restClient:(LRRestyClient *)client request:(LRRestyRequest *)request receivedData:(NSData *)data;

/**
 * Called whenever a request fails.
 * @param client     The client performing the request.
 * @param request    The request that failed.
 * @param error      The request error.
 */
- (void)restClient:(LRRestyClient *)client request:(LRRestyRequest *)request didFailWithError:(NSError *)error;
@end
