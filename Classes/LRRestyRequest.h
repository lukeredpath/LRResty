//
//  LRRestyRequest.h
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClientResponseDelegate.h"
#import "LRRestyRequestPayload.h"
#import "LRRestyRequestDelegate.h"

/**
 * Represents a single request; provides an API for modifying properties of the request
 * prior to it being executed.
 */
@interface LRRestyRequest : NSOperation
{
  NSMutableURLRequest *URLRequest;
  id<LRRestyRequestDelegate> delegate;
  BOOL _isExecuting;
  BOOL _isFinished;
  NSError *connectionError;
  NSMutableData *responseData;
  NSHTTPURLResponse *response;
  NSURLCredential *credential;
}
@property (nonatomic, retain) NSHTTPURLResponse *response;
@property (nonatomic, retain) NSData *responseData;
@property (nonatomic, retain) NSError *connectionError;
@property (nonatomic, readonly) NSURL *URL;

/**
 * Designated initializer
 * @param aURL      The request URL.
 * @param method    The HTTP request method (GET/POST/PUT/DELETE/HEAD).
 * @param delegate  The delegate for this request.
 */
- (id)initWithURL:(NSURL *)aURL method:(NSString *)httpMethod delegate:(id<LRRestyRequestDelegate>)theDelegate;
- (void)setExecuting:(BOOL)isExecuting;
- (void)setFinished:(BOOL)isFinished;
- (void)finish;
/**
 * Set the query parameters for the request.
 * @param parameters A dictionary of key-value pairs (supports nested parameters).
 */
- (void)setQueryParameters:(NSDictionary *)parameters;
/**
 * Set the HTTP request headers. Replaces any existing headers.
 */
- (void)setHeaders:(NSDictionary *)headers;
/**
 * Add a new header for this request; will overwrite any previous value for the header being set.
 */
- (void)addHeader:(NSString *)header value:(NSString *)value;
/**
 * Set the raw HTTP request body data.
 */
- (void)setPostData:(NSData *)data;
/**
 * Set the HTTP request body using a payload object.
 */
- (void)setPayload:(id<LRRestyRequestPayload>)thePayload;
/**
 * Toggle the automatic cookie handling menchanism (defaults to YES).
 */
- (void)setHandlesCookiesAutomatically:(BOOL)shouldHandleCookies;
/**
 * Set the HTTP basic credentials for this request, using either the Authorization header or the native
 * authentication mechanism of NSURLConnection. The latter will make an unauthenticated request and will
 * use the supplied credentials if an HTTP 401 response is received. 
 * @param username        HTTP Basic username
 * @param password        HTTP Basic password
 * @param useCredential   When set to NO, will use a HTTP Authorization header.
 */
- (void)setBasicAuthUsername:(NSString *)username password:(NSString *)password useCredentialSystem:(BOOL)useCredential;
@end
