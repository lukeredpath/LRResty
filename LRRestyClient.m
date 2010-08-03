//
//  LRRestyClient.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient.h"
#import "LRRestyResponse.h"

@implementation LRRestyClient

- (void)get:(NSString *)urlString delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self getURL:[NSURL URLWithString:urlString] delegate:delegate];
}

- (void)getURL:(NSString *)urlString delegate:(id<LRRestyClientDelegate>)delegate;
{
  [delegate restClient:self receivedResponse:[[LRRestyResponse new] autorelease]];
}

@end

