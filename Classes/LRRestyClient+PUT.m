//
//  LRRestyClient+PUT.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient+PUT.h"
#import "LRRestyClientBlockDelegate.h"
#import "LRRestyClientProxyDelegate.h"
#import "LRSynchronousProxy.h"

@implementation LRRestyClient (PUT)

#pragma mark -
#pragma mark Delegate API

- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  return [self put:urlString payload:payload headers:nil delegate:delegate];
}

- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  return [HTTPClient PUT:[NSURL URLWithString:urlString] payload:payload headers:headers delegate:[LRRestyClientProxyDelegate proxyForClient:self responseDelegate:delegate]];
}

#pragma mark -
#pragma mark Blocks API

- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload withBlock:(LRRestyResponseBlock)block;
{
  return [self put:urlString payload:payload headers:nil withBlock:block];
}

- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  return [HTTPClient PUT:[NSURL URLWithString:urlString] payload:payload headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

#pragma mark -
#pragma mark Synchronous API

- (LRRestyResponse *)put:(NSString *)urlString payload:(id)payload;
{
  return [self performAsynchronousBlockAndReturnResultWhenReady:^(id *result, NSCondition *condition)
  {
    [self put:urlString payload:payload withBlock:^(LRRestyResponse *response) {
      LRSYNCHRONOUS_PROXY_NOTIFY_CONDITION(result, [response retain], condition);
    }];
  }];
}

- (LRRestyResponse *)put:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers;
{
  return [self performAsynchronousBlockAndReturnResultWhenReady:^(id *result, NSCondition *condition)
  {
    [self put:urlString payload:payload headers:headers withBlock:^(LRRestyResponse *response) {
      LRSYNCHRONOUS_PROXY_NOTIFY_CONDITION(result, [response retain], condition);
    }];
  }];
}

@end
