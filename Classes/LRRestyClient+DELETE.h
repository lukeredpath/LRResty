//
//  LRRestyClient+DELETE.h
//  LRResty
//
//  Created by Barry Wilson on 6/10/11.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient.h"
#import "LRRestyTypes.h"

@class LRRestyRequest;

@interface LRRestyClient (DELETE)

/// ---------------------------------
/// @name Making DELETE requests
/// ---------------------------------

#pragma mark -
#pragma mark Delegate API

/**
 Performs a DELETE request on URL resource with delegate response handling.
 @param urlString   The URL resource to delete.
 @param delegate    The response delegate.
 @returns The request object.
 */
- (LRRestyRequest *)delete:(NSString *)urlString delegate:(id<LRRestyClientResponseDelegate>)delegate;

/**
 Performs a DELETE request on URL resource with the specified request headers with delegate response handling.
 @param urlString   The URL resource to delete.
 @param headers     A dictionary of HTTP request headers.
 @param delegate    The response delegate.
 @returns The request object.
 */
- (LRRestyRequest *)delete:(NSString *)urlString headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)delegate;

#pragma mark -
#pragma mark Blocks API

/**
 Performs a DELETE request on URL resource with block response handling.
 @param urlString   The URL resource to delete.
 @param block       The response handler.
 @returns The request object.
 */
- (LRRestyRequest *)delete:(NSString *)urlString withBlock:(LRRestyResponseBlock)block;

/**
 Performs a DELETE request on URL resource with block response handling.
 @param urlString   The URL resource to delete.
 @param headers     A dictionary of HTTP request headers.
 @param block       The response handler.
 @returns The request object.
 */
- (LRRestyRequest *)delete:(NSString *)urlString headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;

#pragma mark -
#pragma mark Synchronous API

/**
 Performs a *synchronous* DELETE request on URL resource, blocking the calling thread.
 @param urlString   The URL resource to delete.
 @returns The response to the request.
 */
- (LRRestyResponse *)delete:(NSString *)urlString;

/**
 Performs a *synchronous* DELETE request on URL resource, blocking the calling thread.
 @param urlString   The URL resource to delete.
 @param headers     A dictionary of HTTP request headers.
 @returns The response to the request.
 */
- (LRRestyResponse *)delete:(NSString *)urlString headers:(NSDictionary *)headers;


@end
