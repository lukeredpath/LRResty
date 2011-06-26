//
//  LRRestyClient+GET.h
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient.h"
#import "LRRestyTypes.h"

@class LRRestyRequest;

@interface LRRestyClient (GET)

/// ---------------------------------
/// @name Making GET requests
/// ---------------------------------

#pragma mark -
#pragma mark Delegate API

/**
 Performs a GET request on URL with delegate response handling.
 @param urlString   The URL to request.
 @param delegate    The response delegate.
 @returns The request object.
 */
- (LRRestyRequest *)get:(NSString *)urlString delegate:(id<LRRestyClientResponseDelegate>)delegate;

/**
 Performs a GET request on URL with the specified query parameters with delegate response handling.
 @param urlString   The URL to request.
 @param parameters  A dictionary of query string parameters.
 @param delegate    The response delegate.
 @returns The request object.
 */
- (LRRestyRequest *)get:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<LRRestyClientResponseDelegate>)delegate;

/**
 Performs a GET request on URL with the specified query parameters and request headers with delegate response handling.
 @param urlString   The URL to request.
 @param parameters  A dictionary of query string parameters.
 @param headers     A dictionary of HTTP request headers.
 @param delegate    The response delegate.
 @returns The request object.
 */
- (LRRestyRequest *)get:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)delegate;

#pragma mark -
#pragma mark Blocks API

/**
 Performs a GET request on URL with block response handling.
 @param urlString   The URL to request.
 @param block       The response handler.
 @returns The request object.
 */
- (LRRestyRequest *)get:(NSString *)urlString withBlock:(LRRestyResponseBlock)block;

/**
 Performs a GET request on URL with the specified query parameters block response handling.
 @param urlString   The URL to request.
 @param parameters  A dictionary of query string parameters.
 @param block       The response handler.
 @returns The request object.
 */
- (LRRestyRequest *)get:(NSString *)urlString parameters:(NSDictionary *)parameters withBlock:(LRRestyResponseBlock)block;

/**
 Performs a GET request on URL with block response handling.
 @param urlString   The URL to request.
 @param parameters  A dictionary of query string parameters.
 @param headers     A dictionary of HTTP request headers.
 @param block       The response handler.
 @returns The request object.
 */
- (LRRestyRequest *)get:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;

#pragma mark -
#pragma mark Synchronous API

/**
 Performs a *synchronous* GET request on URL, blocking the calling thread.
 @param urlString   The URL to request.
 @returns The response to the request.
 */
- (LRRestyResponse *)get:(NSString *)urlString;

/**
 Performs a *synchronous* GET request on URL, blocking the calling thread.
 @param urlString   The URL to request.
 @param parameters  A dictionary of query string parameters.
 @returns The response to the request.
 */
- (LRRestyResponse *)get:(NSString *)urlString parameters:(NSDictionary *)parameters;

/**
 Performs a *synchronous* GET request on URL, blocking the calling thread.
 @param urlString   The URL to request.
 @param parameters  A dictionary of query string parameters.
 @param headers     A dictionary of HTTP request headers.
 @returns The response to the request.
 */
- (LRRestyResponse *)get:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers;

@end

#pragma mark -
#pragma mark Streaming API

@interface LRRestyClient (GET_Streaming)
/**
 Performs a GET request on URL, and yields data as it arrives. Designed for consuming streaming HTTP APIs.
 @param urlString    The URL to request.
 @returns The request object.
 */
- (LRRestyRequest *)get:(NSString *)urlString onData:(LRRestyStreamingDataBlock)dataHandler onError:(LRRestyStreamingErrorBlock)errorHandler;
@end
