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
 LRRestyClient provides the core API for performing requests. It provides both
 a block-based and delegate-based API for handling responses.
 */
@interface LRRestyClient : NSObject <LRRestyHTTPClientDelegate>
{
  id<LRRestyHTTPClient> HTTPClient;
  NSMutableArray *requestModifiers;
  id<LRRestyClientDelegate> clientDelegate;
  LRRestyRequestTimeoutBlock globalTimeoutHandler;
  NSTimeInterval globalTimeoutInterval;
}
/* *
 The client's delegate will be notified when a request is performed and finished.
 This is not used to handle individual responses, but to perform more generic actions
 (like displaying a network activity indicator) when requests start and stop. */
@property (nonatomic, assign) id<LRRestyClientDelegate> delegate;

/**
 The designated initializer. 
 
 User's should rarely need to call this method directly as they should use the LRResty
 factory to get instances of LRRestyClient. Calling the standard init method will call
 this method with a concrete instance of the LRRestyHTTPClient class.
 
 @param an implementation of the LRRestyHTTPClient protocol; will be retained
 */
- (id)initWithHTTPClient:(id<LRRestyHTTPClient>)aHTTPClient;

/**
 Determines whether the underlying HTTP request mechanism (NSURLConnection) should
 automatically handle cookies. Enabled by default.
 */
- (void)setHandlesCookiesAutomatically:(BOOL)shouldHandleCookies;

/**
 Attach a request modifier to the client. 
 
 A request modifier is a block that will be called with the constructed LRRestyRequest
 prior to it being performed; request modifiers can be used to apply global transformations
 to all requests performed by the client, such as setting specific HTTP headers or setting
 any other request parameters as permitted by the LRRestyRequest API.
 
 @code
      // set the content-type header for all requests
      [[LRResty client] attachRequestModifier:^(LRRestyRequest *req) {
        [req addHeader:@"Content-Type" value:@"application/xml"];
      }];
  @endcode
 */
- (NSInteger)attachRequestModifier:(LRRestyRequestBlock)block;

/**
 Removes a request modifier at the specified index
 */
- (void)removeRequestModifierAtIndex:(NSInteger)index;

/**
 Configures HTTP Basic authentication for all requests performed by the client.
 Authentication will be made using an Authorization HTTP header; this cannot currently be
 overridden.
 */
- (void)setUsername:(NSString *)username password:(NSString *)password;

/**
 Cancels all outstanding requests
 */
- (void)cancelAllRequests;

- (void)setGlobalTimeout:(NSTimeInterval)timeout handleWithBlock:(LRRestyRequestTimeoutBlock)block;
@end
