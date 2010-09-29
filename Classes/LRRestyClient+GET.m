//
//  LRRestyClient+GET.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient+GET.h"
#import "LRRestyClientProxyDelegate.h"
#import "LRRestyClientBlockDelegate.h"
#import "LRRestyClientStreamingDelegate.h"

@implementation LRRestyClient (GET)

- (LRRestyRequest *)get:(NSString *)urlString delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  return [self get:urlString parameters:nil delegate:delegate];
}

- (LRRestyRequest *)get:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  return [self get:urlString parameters:parameters headers:nil delegate:delegate];
}

- (LRRestyRequest *)get:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  return [HTTPClient GET:[NSURL URLWithString:urlString] parameters:parameters headers:headers delegate:[LRRestyClientProxyDelegate proxyForClient:self responseDelegate:delegate]];
}

- (LRRestyRequest *)get:(NSString *)urlString withBlock:(LRRestyResponseBlock)block;
{
  return [self get:urlString parameters:nil withBlock:block];
}

- (LRRestyRequest *)get:(NSString *)urlString parameters:(NSDictionary *)parameters withBlock:(LRRestyResponseBlock)block;
{
  return [self get:urlString parameters:parameters headers:nil withBlock:block];
}

- (LRRestyRequest *)get:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  return [HTTPClient GET:[NSURL URLWithString:urlString] parameters:parameters headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

@end

@implementation LRRestyClient (GET_Streaming)

- (LRRestyRequest *)get:(NSString *)urlString onData:(LRRestyStreamingDataBlock)dataHandler onError:(LRRestyStreamingErrorBlock)errorHandler;
{
  return [HTTPClient GET:[NSURL URLWithString:urlString] parameters:nil headers:nil delegate:[LRRestyClientStreamingDelegate delegateWithDataHandler:dataHandler errorHandler:errorHandler]];
}

@end

