//
//  LRResty.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClient.h"
#import "LRRestyClient+GET.h"
#import "LRRestyClient+POST.h"
#import "LRRestyClient+PUT.h"
#import "LRRestyClient+DELETE.h"
#import "LRRestyResponse.h"
#import "LRRestyRequest.h"
#import "LRRestyResource.h"

/**
 This is the main top-level interface to Resty and acts as a static factory for creating
 and accessing clients and resources.
 */
@interface LRResty : NSObject 

/// ---------------------------------
/// @name Accessing Clients
/// ---------------------------------

/**
 Returns a globally shared instance of LRRestyClient.
 
 For most simple cases, this is all you will need; if you need your own unique instance,
 you should use newClient instead.
 */
+ (LRRestyClient *)client;

/**
 Returns a new instance of LRRestyClient.
 */
+ (LRRestyClient *)newClient;

/**
 Returns a new (autoreleased) instance of LRRestyClient, pre-configured for basic authentication.
 
 @param username The username to use when authenticating.
 @param password The password to use when authenticating.
 */
+ (LRRestyClient *)authenticatedClientWithUsername:(NSString *)username password:(NSString *)password;

/**
 Returns a new (autoreleased) instance of LRRestyResource, using the global client.
 */
+ (LRRestyResource *)resource:(NSString *)urlString;

/**
 Returns a new (autoreleased) LRRestyResource, pre-configured for basic authentication.
 
 @param username The username to use when authenticating.
 @param password The password to use when authenticating.
 */
+ (LRRestyResource *)authenticatedResource:(NSString *)urlString username:(NSString *)username password:(NSString *)password;

/// ---------------------------------
/// @name Logging
/// ---------------------------------

/**
 Can be used to toggle logging for debug purposes.
 */
+ (void)setDebugLoggingEnabled:(BOOL)isEnabled;

/**
 Outputs the message to the console only if debug logging is enabled
 */
+ (void)log:(NSString *)message;

@end
