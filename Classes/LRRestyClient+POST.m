//
//  LRRestyClient+POST.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient+POST.h"
#import "LRRestyClientBlockDelegate.h"
#import "LRRestyClientProxyDelegate.h"
#import "LRSynchronousProxy.h"

@implementation LRRestyClient (POST)

#pragma mark -
#pragma mark Delegate API

- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  return [self post:urlString payload:payload headers:nil delegate:delegate];
}

- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  return [HTTPClient POST:[NSURL URLWithString:urlString] payload:payload headers:headers delegate:[LRRestyClientProxyDelegate proxyForClient:self responseDelegate:delegate]];
}

#pragma mark -
#pragma mark Blocks API

- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload withBlock:(LRRestyResponseBlock)block;
{
  return [self post:urlString payload:payload headers:nil withBlock:block];
}

- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  return [HTTPClient POST:[NSURL URLWithString:urlString] payload:payload headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

#pragma mark -
#pragma mark Synchronous API

- (LRRestyResponse *)post:(NSString *)urlString payload:(id)payload;
{
  return [self performAsynchronousBlockWithTimeout:globalTimeoutInterval + 1 andReturnResultWhenReady:^(id *result, NSCondition *condition)
  {
    [self post:urlString payload:payload withBlock:^(LRRestyResponse *response) {
      LRSYNCHRONOUS_PROXY_NOTIFY_CONDITION(result, [response retain], condition);
    }];
  }];
}

- (LRRestyResponse *)post:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers;
{
  return [self performAsynchronousBlockAndReturnResultWhenReady:^(id *result, NSCondition *condition)
  {
    [self post:urlString payload:payload headers:headers withBlock:^(LRRestyResponse *response) {
      LRSYNCHRONOUS_PROXY_NOTIFY_CONDITION(result, [response retain], condition);
    }];
  }];
}

@end
