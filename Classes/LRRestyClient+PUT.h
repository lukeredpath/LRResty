//
//  LRRestyClient+PUT.h
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient.h"

@class LRRestyRequest;

@interface LRRestyClient (PUT)

/// ---------------------------------
/// @name Making PUT requests
/// ---------------------------------

#pragma mark -
#pragma mark Delegate API

/**
 Performs a PUT request with a payload on URL with delegate response handling.
 @param urlString   The URL to request.
 @param payload     The object to POST.
 @param delegate    The response delegate.
 @returns The request object.
 @see LRRestyRequestPayload
 */
- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload delegate:(id<LRRestyClientResponseDelegate>)delegate;

/**
 Performs a PUT request with a payload on URL with delegate response handling.
 @param urlString   The URL to request.
 @param delegate    The response delegate.
 @returns The request object.
 @see LRRestyRequestPayload
 */
- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)delegate;

#pragma mark -
#pragma mark Blocks API

/**
 Performs a PUT request with a payload on URL with block response handling.
 @param urlString   The URL to request.
 @param payload     The object to POST.
 @param block       The response block.
 @returns The request object.
 @see LRRestyRequestPayload
 */
- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload withBlock:(LRRestyResponseBlock)block;

/**
 Performs a PUT request with a payload on URL with block response handling.
 @param urlString   The URL to request.
 @param block       The response block.
 @returns The request object.
 @see LRRestyRequestPayload
 */
- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;

#pragma mark -
#pragma mark Synchronous API

/**
 Performs a *synchronous* POST request with a payload on URL, blocking the calling thread.
 @param urlString   The URL to request.
 @param payload     The object to POST.
 @returns The response object.
 @see LRRestyRequestPayload
 */
- (LRRestyResponse *)put:(NSString *)urlString payload:(id)payload;

/**
 Performs a *synchronous* POST request with a payload on URL, blocking the calling thread.
 @param urlString   The URL to request.
 @param block       The response block.
 @returns The response object.
 @see LRRestyRequestPayload
 */
- (LRRestyResponse *)put:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers;

@end

