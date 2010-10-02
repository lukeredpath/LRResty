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
#import "LRRestyResponse.h"
#import "LRRestyRequest.h"
#import "LRRestyResource.h"

/**
 A simple static factory for creating clients and resources.
 */
@interface LRResty : NSObject {

}
/**
 Returns a shared instance of +LRRestyClient+.
 */
+ (LRRestyClient *)client;
/**
 Returns an auto-released instance of LRRestyClient with HTTP Basic Auth parameters set.
 */
+ (LRRestyClient *)authenticatedClientWithUsername:(NSString *)username password:(NSString *)password;
/**
 Returns an auto-released LRRestyResource, using the shared client.
 */
+ (LRRestyResource *)resource:(NSString *)urlString;
/**
 Returns an auto-released LRRestyResource, using an authenticated client.
 */
+ (LRRestyResource *)authenticatedResource:(NSString *)urlString username:(NSString *)username password:(NSString *)password;
/**
 Can be used to toggle logging for debug purposes.
 */
+ (void)setDebugLoggingEnabled:(BOOL)isEnabled;
/**
 Outputs the message to the console only if debug logging is enabled
 */
+ (void)log:(NSString *)message;
@end
