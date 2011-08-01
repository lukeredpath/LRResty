//
//  LRRestyRequest.h
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRURLRequestOperation.h"
#import "LRRestyClientResponseDelegate.h"
#import "LRRestyRequestPayload.h"
#import "LRRestyRequestDelegate.h"
#import "LRRestyClient.h"

/**
 * Represents a single request; provides an API for modifying properties of the request
 * prior to it being executed.
 */
@interface LRRestyRequest : LRURLRequestOperation
{
  id<LRRestyRequestDelegate> delegate;
  NSURLCredential *credential;
  NSMutableURLRequest *_URLRequest;
}
@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, assign, readonly) NSUInteger numberOfRetries;
@property (nonatomic, readonly) NSError *error;

/// ---------------------------------
/// @name Initializing
/// ---------------------------------

/**
 Creates a new request.
 
 *This is the designated initializer for the class*
 
 @param aURL      The request URL.
 @param method    The HTTP request method (GET/POST/PUT/DELETE/HEAD).
 @param delegate  The delegate for this request.
*/
- (id)initWithURL:(NSURL *)aURL method:(NSString *)httpMethod delegate:(id<LRRestyRequestDelegate>)theDelegate;

/// ---------------------------------
/// @name Configuring the request body
/// ---------------------------------

/**
 Set the query parameters for the request.
 
 This will convert a dictionary of parameters into the query string for the request
 (e.g. ?foo=bar&baz=qux).
 
 @param parameters A dictionary of key-value pairs (supports nested parameters).
 */
- (void)setQueryParameters:(NSDictionary *)parameters;

/**
 Sets the raw body data for a POST/PUT request.
 
 @param data The POST body data.
 */
- (void)setPostData:(NSData *)data;

/**
 Set the HTTP request body using a payload object.
 
 @see LRRestyRequestPayload
 
 @param thePayload The payload object that will form the POST or PUT's request body.
 */
- (void)setPayload:(id<LRRestyRequestPayload>)thePayload;

/// ---------------------------------
/// @name Modifying Headers
/// ---------------------------------

/**
 Set the HTTP request headers. 
 
 This will replace any existing headers for this request.
 
 @param headers A dictionary of HTTP headers.
 */
- (void)setHeaders:(NSDictionary *)headers;

/**
 Add a new header for this request.
 
 This will overwrite any previous value for the particular header being set.
 
 @param header  The HTTP request header to set (e.g. @"Content-Type")
 @param value   The value for the HTTP request header (e.g. @"application/xml").
 */
- (void)addHeader:(NSString *)header value:(NSString *)value;

/// ---------------------------------
/// @name Handling Cookies
/// ---------------------------------

/**
 Toggles automatic cookie handling.
 
 @param shouldHandleCookies If YES, the underlying HTTP request mechanism (NSURLConnection) will
 automatically handle cookies. Enabled by default.
 */
- (void)setHandlesCookiesAutomatically:(BOOL)shouldHandleCookies;

/// ---------------------------------
/// @name Basic Authentication
/// ---------------------------------

/**
 Set the HTTP basic credentials for this request.
 
 @param username        HTTP Basic username
 @param password        HTTP Basic password
 @param useCredential   When NO, uses the Authorization header will be used. When YES, will make an unauthenticated request and will use the supplied credentials only if an HTTP 401 (Not Authorized) response is received. 
 */
- (void)setBasicAuthUsername:(NSString *)username password:(NSString *)password useCredentialSystem:(BOOL)useCredential;

/// ---------------------------------
/// @name Handling Timeouts
/// ---------------------------------

/**
 Sets a timeout and handler for this request.
 
 By default, requests will time out only when the underlying NSURLConnection times out.
 
 This method allows you to handle timeouts in a more deterministic way by providing a timeout interval
 and block. Using Grand Central Dispatch, after the timeout interval has passed, the connection will be
 forcibly cancelled and the timeout handler will be called.
 
 You can call this method right after it is returned by one of the request methods on LRRestyClient, e.g.:
 
    [[[LRRestyClient client] get:@"http://www.example.com" handleWithBlock:^{...}] 
                    timeoutAfter:30.0 handleWithBlock:^(LRRestyRequest *request) {

      // handle the timeout in some way
      [self alertUserThatRequestHasTimedOut:request];
    }];
 
 To handle timeouts globally across all requests, see [LRRestyClient setGlobalTimeout:handleWithBlock:]
 
 @param timeout The timeout interval in seconds
 @param block   The timeout handler block. The cancelled request will be passed into the block.
 */
- (void)timeoutAfter:(NSTimeInterval)delayInSeconds handleWithBlock:(LRRestyRequestTimeoutBlock)block;

/// ---------------------------------
/// @name Retrying requests
/// ---------------------------------

/**
 Creates a new request based on the current one and automatically runs it.
 
 LRResty makes no assumptions about when to retry a request - you need to call this explicitly 
 within your response handler. You may want to retry a request if you did not get an expected 
 HTTP response code.
 
 Calling this method will create a brand new request based on the original and run it. Requests
 have a numberOfRetries property that tracks how many times a request has been retried. You 
 could use this in your response handler to limit the number of retries to perform.
 
 For instance, if you wanted to retry a request up to a maximum of 3 times until you received
 a 201 Created response, you would do something like this:
 
    __block LRRestyRequest *request = [[LRRestyClient client] post:@"http://www.example.com" payload:someObject 
          handleWithBlock:^(LRRestyResponse *response) {
      if (response.status == 201) {
        // do something with response
      }
      else if (request.numberOfRetries < 3) {
        // be sure to update the pointer to the new request
        request = [request retry];
      }
      else {
        // handle failure
      }
    }];
 
 @returns The newly created request.
 */ 
- (LRRestyRequest *)retry;

@end
