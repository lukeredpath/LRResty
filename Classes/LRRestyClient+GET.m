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
#import "LRSynchronousProxy.h"

@implementation LRRestyClient (GET)

#pragma mark -
#pragma mark Delegate API

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

#pragma mark -
#pragma mark Blocks API

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

#pragma mark -
#pragma mark Synchronous API

- (LRRestyResponse *)get:(NSString *)urlString;
{
  return [self performAsynchronousBlockWithTimeout:globalTimeoutInterval andReturnResultWhenReady:^(id *result, NSCondition *condition) 
  {
    [self get:urlString withBlock:^(LRRestyResponse *response) {
      LRSYNCHRONOUS_PROXY_NOTIFY_CONDITION(result, [response retain], condition);
    }];
  }];
}

- (LRRestyResponse *)get:(NSString *)urlString parameters:(NSDictionary *)parameters;
{
  return [self performAsynchronousBlockWithTimeout:globalTimeoutInterval andReturnResultWhenReady:^(id *result, NSCondition *condition) 
  {
    [self get:urlString parameters:parameters withBlock:^(LRRestyResponse *response) {
      LRSYNCHRONOUS_PROXY_NOTIFY_CONDITION(result, [response retain], condition);
    }];
  }];
}

- (LRRestyResponse *)get:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers;
{
  return [self performAsynchronousBlockAndReturnResultWhenReady:^(id *result, NSCondition *condition) 
  {
    [self get:urlString parameters:parameters headers:headers withBlock:^(LRRestyResponse *response) {
      LRSYNCHRONOUS_PROXY_NOTIFY_CONDITION(result, [response retain], condition);
    }];
  }];
}

@end

#pragma mark -
#pragma mark Streaming API

@implementation LRRestyClient (GET_Streaming)

- (LRRestyRequest *)get:(NSString *)urlString onData:(LRRestyStreamingDataBlock)dataHandler onError:(LRRestyStreamingErrorBlock)errorHandler;
{
  return [HTTPClient GET:[NSURL URLWithString:urlString] parameters:nil headers:nil delegate:[LRRestyClientStreamingDelegate delegateWithDataHandler:dataHandler errorHandler:errorHandler]];
}

@end

