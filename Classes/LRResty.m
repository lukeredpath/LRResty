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
  return [[[LRRestyClient alloc] init] autorelease];
}

+ (LRRestyClient *)authenticatedClientWithUsername:(NSString *)username password:(NSString *)password;
{
  return [[self client] tap:^(id client) {
    [client setUsername:username password:password];
  }];
}

+ (LRRestyResource *)resource:(NSString *)urlString;
{
  return [[[LRRestyResource alloc] initWithRestClient:[self client] URL:[NSURL URLWithString:urlString]] autorelease];
}

+ (LRRestyResource *)authenticatedResource:(NSString *)urlString username:(NSString *)username password:(NSString *)password;
{
  LRRestyClient *client = [self authenticatedClientWithUsername:username password:password];
  return [[[LRRestyResource alloc] initWithRestClient:client URL:[NSURL URLWithString:urlString]] autorelease];
}

@end
