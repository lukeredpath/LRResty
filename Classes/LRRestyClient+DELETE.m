//
//  LRRestyClient+DELETE.m
//  LRResty
//
//  Created by Barry Wilson on 6/10/11.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient+DELETE.h"
#import "LRRestyClientProxyDelegate.h"
#import "LRRestyClientBlockDelegate.h"
#import "LRRestyClientStreamingDelegate.h"
#import "LRSynchronousProxy.h"

@implementation LRRestyClient (DELETE)

#pragma mark -
#pragma mark Delegate API

- (LRRestyRequest *)delete:(NSString *)urlString delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  return [self delete:urlString headers:nil delegate:delegate];
}

- (LRRestyRequest *)delete:(NSString *)urlString headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  return [HTTPClient DELETE:[NSURL URLWithString:urlString] payload:nil headers:headers delegate:[LRRestyClientProxyDelegate proxyForClient:self responseDelegate:delegate]];
}

#pragma mark -
#pragma mark Blocks API

- (LRRestyRequest *)delete:(NSString *)urlString withBlock:(LRRestyResponseBlock)block;
{
  return [self delete:urlString headers:nil withBlock:block];
}

- (LRRestyRequest *)delete:(NSString *)urlString headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
    return [HTTPClient DELETE:[NSURL URLWithString:urlString] payload:nil headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

- (LRRestyRequest *)delete:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block 
{
    return [HTTPClient DELETE:[NSURL URLWithString:urlString] payload:payload headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];    
}

#pragma mark -
#pragma mark Synchronous API

- (LRRestyResponse *)delete:(NSString *)urlString;
{
  return [self performAsynchronousBlockWithTimeout:globalTimeoutInterval andReturnResultWhenReady:^(id *result, dispatch_semaphore_t semaphore) 
  {
    [self delete:urlString withBlock:^(LRRestyResponse *response) {
      LRSYNCHRONOUS_PROXY_NOTIFY_CONDITION(result, [response retain], semaphore);
    }];
  }];
}

- (LRRestyResponse *)delete:(NSString *)urlString headers:(NSDictionary *)headers;
{
  return [self performAsynchronousBlockWithTimeout:globalTimeoutInterval andReturnResultWhenReady:^(id *result, dispatch_semaphore_t semaphore) 
  {
    [self delete:urlString headers:headers withBlock:^(LRRestyResponse *response) {
      LRSYNCHRONOUS_PROXY_NOTIFY_CONDITION(result, [response retain], semaphore);
    }];
  }];
}


@end
