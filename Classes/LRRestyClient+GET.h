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
 
 This method does not yield an LRRestyResponse object; instead it does some simple error checking and calls
 the error handler block if it receives a non-200 HTTP status code. Use the method below for more flexible
 error handling.
 
 @param urlString     The URL to request.
 @param dataHandler   Will be called with each chunk of data as it arrives.
 @param errorHandler  Will be called with an NSError if a non-200 HTTP status code is received.
 @returns The request object.
 */
- (LRRestyRequest *)get:(NSString *)urlString onData:(LRRestyStreamingDataBlock)dataHandler onError:(LRRestyStreamingErrorBlock)errorHandler;

/**
 Performs a GET request on URL, and yields data as it arrives. Designed for consuming streaming HTTP APIs.
 
 Unlike the above method, this does no error handling; it instead yields the LRRestyResponse to the supplied 
 response handler block allowing clients to do their own error handling.
 
 Because the data returned is not accumulated, the resulting LRRestyResponse will have an empty response body.
 It is the client's responsibility to store the data yielded to the dataHandler block (this could be in memory
 or directly to disk).
 
 @param urlString     The URL to request.
 @param block         The response handler.
 @param dataHandler   Will be called with each chunk of data as it arrives.
 @returns The request object.
 */
- (LRRestyRequest *)get:(NSString *)urlString withBlock:(LRRestyResponseBlock)block onData:(LRRestyStreamingDataBlock)dataHandler;
@end
