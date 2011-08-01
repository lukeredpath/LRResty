//
//  LRRestyResponse.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRRestyRequest;

/**
 Represents a response for a single LRRestyRequest.
 
 This will typically be used in response handler blocks or delegate objects implementing LRRestyClientResponseDelegate.
 */
@interface LRRestyResponse : NSObject {
  NSUInteger status;
  NSData *responseData;
  NSDictionary *headers;
  NSDictionary *cookies;
}
/**
 The original request that this is the response for.
 */
@property (nonatomic, readonly) LRRestyRequest *originalRequest;

/**
 Returns the raw response data.
 */
@property (nonatomic, readonly) NSData *responseData;

/**
 Returns a dictionary of response headers 
 */
@property (nonatomic, readonly) NSDictionary *headers;

/**
 * The HTTP status code.
 */
@property (nonatomic, readonly) NSUInteger status;

/**
 Localized status description for the HTTP status code
 */
- (NSString *)localizedStatusDescription;

/**
 Attempts to return a string representation of the response body.
 */
- (NSString *)asString;

/**
 Returns the named cookie.
 */
- (NSHTTPCookie *)cookieNamed:(NSString *)name;

/**
 Returns the value for the named header.
 */
- (NSString *)valueForHeader:(NSString *)header;

/**
 Returns the value for the named cookie.
 */
- (NSString *)valueForCookie:(NSString *)cookieName;

/**
 Indicates that a response was received without error.
 */
- (BOOL)wasSuccessful;

@end

