//
//  LRResty.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRResty.h"
#import "NSObject+Tap.h"

@implementation LRResty

+ (LRRestyClient *)client;
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [self newClient];
  });
}

+ (LRRestyClient *)newClient;
{
  return [[LRRestyClient alloc] init];
}

+ (LRRestyClient *)authenticatedClientWithUsername:(NSString *)username password:(NSString *)password;
{
  LRRestyClient *client = [self newClient];
  return [client tap:^(id client) {
    [client setUsername:username password:password];
  }];
}

+ (LRRestyResource *)resource:(NSString *)urlString;
{
  return [[LRRestyResource alloc] initWithRestClient:[self client] URL:[NSURL URLWithString:urlString]];
}

+ (LRRestyResource *)authenticatedResource:(NSString *)urlString username:(NSString *)username password:(NSString *)password;
{
  LRRestyClient *client = [self authenticatedClientWithUsername:username password:password];
  return [[LRRestyResource alloc] initWithRestClient:client URL:[NSURL URLWithString:urlString]];
}

static BOOL __RestyDebugLoggingEnabled = NO;

+ (void)setDebugLoggingEnabled:(BOOL)isEnabled;
{
  __RestyDebugLoggingEnabled = isEnabled; 
}

+ (void)log:(NSString *)message;
{
  if (__RestyDebugLoggingEnabled) {
    NSLog(@"debug: %@", message);
  }
}

@end
