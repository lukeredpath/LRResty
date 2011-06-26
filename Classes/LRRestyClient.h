//
//  LRRestyClient.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClientResponseDelegate.h"
#import "LRRestyClientDelegate.h"
#import "LRRestyTypes.h"
#import "LRRestyHTTPClient.h"

@class LRRestyResponse;
@class LRRestyRequest;

typedef void (^LRRestyResponseBlock)(LRRestyResponse *response);
typedef void (^LRRestyRequestBlock)(LRRestyRequest *request);
typedef void (^LRRestyRequestTimeoutBlock)(LRRestyRequest *);

/**
 An instance of LRRestyClient allows you to make HTTP requests using a simple, concise API.
 
 It provides both block-based and delegate-based callback mechanisms for handling responses.
 
 You are encouraged to use the block-based methods wherever possible as the resulting code is
 simpler however if you require extra control over the request life-cycle, you may want to implement
 the LRRestyClientResponseDelegate protocol and use the delegate-based methods instead.
 
 A number of methods are provided for each supported HTTP verb with different options for setting
 the request headers, parameters or for POST and PUT requests, the request body (payload).
 
 This is an example of a simple GET request, with no parameters:
 
    // Obtain an instance of the shared client
    LRRestyClient *client = [LRResty client];
 
    // Perform a GET request to http://www.example.com/ and handle the response with a block
    [client get:@"http://www.example.com" withBlock:^(LRRestyResponse *response) {
        [self doSomethingUsefulWithResponse:response];
    }];
 
 Throughout the API, URLs are represented using NSString rather than NSURL, to keep the API
 simple and avoid the need to create NSURL objects inline. If you have an NSURL object, you 
 can call [NSURL absoluteString] to return a string that you can use with the LRResty API.
 */
@interface LRRestyClient : NSObject <LRRestyHTTPClientDelegate>
{
  id<LRRestyHTTPClient> HTTPClient;
  NSMutableArray *requestModifiers;
  id<LRRestyClientDelegate> clientDelegate;
  LRRestyRequestTimeoutBlock globalTimeoutHandler;
  NSTimeInterval globalTimeoutInterval;
}
/**
 Set's the client's delegate.
 
 You can assign a delegate to be notified when a request is performed and finished.

 This is not designed for handling individual responses, but to perform more generic actions
 that should happen whenever a request is performed (i.e. displaying a network activity indicator).
*/
@property (nonatomic, assign) id<LRRestyClientDelegate> delegate;

/// ---------------------------------
/// @name Initializing
/// ---------------------------------

/**
 Initializes a new client with an implementation of the LRRestyHTTPClient protocol.
 
 You should rarely, if ever need to call this method directly. You should use the LRResty
 static factory to create new client instances.
 
 *This is the designated initializer for this class*
 
  @param aHTTPClient an implementation of the LRRestyHTTPClient protocol; will be retained
 */
- (id)initWithHTTPClient:(id<LRRestyHTTPClient>)aHTTPClient;

/**
 Initializes a new client using the built-in LRRestyHTTPClient implementation.
 
 You should rarely, if ever need to call this method directly. You should use the LRResty
 static factory to create new client instances.
 */
- (id)init;

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
/// @name Modifying Requests
/// ---------------------------------

/**
 Attaches a request modifier to the client. 
 
 A request modifier is a block that will be called with the constructed request object
 prior to it being performed.
 
 Request modifiers can be used to apply global transformations to all requests performed 
 by the client; for instance, if you wanted to ensure that all requests have a Content-Type
 header of "application/xml", rather than passing this header in with every request, you
 can attach a request modifier that does it for you:
 
    // set the content-type header for all requests
    [[LRResty client] attachRequestModifier:^(LRRestyRequest *request) {
      [request addHeader:@"Content-Type" value:@"application/xml"];
    }];
 
 @param block The block that will be called with the request prior to it being performed.
 @return The index of the added request modifier.
 */
- (NSInteger)attachRequestModifier:(LRRestyRequestBlock)block;

/**
 Removes a request modifier.
 
 If you think you may need to remove a request modifier at runtime, you should store
 the index returned by attachRequestModifier: so you can remove it later.
 
 @param index The index of the request modifier to remove.
 */
- (void)removeRequestModifierAtIndex:(NSInteger)index;

/// ---------------------------------
/// @name Basic Authentication
/// ---------------------------------

/**
 Configures HTTP Basic authentication for all requests performed by the client.

 @warning Authentication will be performed using an Authorization HTTP header; this cannot 
 currently be overridden.
 
 @param username The username to use when authenticating.
 @param password The password to use when authenticating.
 */
- (void)setUsername:(NSString *)username password:(NSString *)password;

/// ---------------------------------
/// @name Cancellation
/// ---------------------------------

/**
 Cancels all outstanding requests.
 
 If you need to cancel a specific request, you should keep a reference to the request returned
 by the request method used originally and call cancel on it instead.
 */
- (void)cancelAllRequests;

/// ---------------------------------
/// @name Handling Timeouts
/// ---------------------------------

/**
 Sets a global timeout and handler for all requests performed by the client.
 
 By default, requests will time out only when the underlying NSURLConnection times out.
 
 This method allows you to handle timeouts in a more deterministic way by providing a timeout interval
 and block. Using Grand Central Dispatch, after the timeout interval has passed, the connection will be
 forcibly cancelled and the timeout handler will be called.
 
 To set a timeout for a specific request only, see [LRRestyRequest timeoutAfter:handleWithBlock:]
 
 @param timeout The timeout interval in seconds
 @param block   The timeout handler block. The cancelled request will be passed into the block.
 */
- (void)setGlobalTimeout:(NSTimeInterval)timeout handleWithBlock:(LRRestyRequestTimeoutBlock)block;
@end
