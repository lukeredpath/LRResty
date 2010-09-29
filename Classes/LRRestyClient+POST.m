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

@implementation LRRestyClient (POST)

- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  return [self post:urlString payload:payload headers:nil delegate:delegate];
}

- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  return [HTTPClient POST:[NSURL URLWithString:urlString] payload:payload headers:headers delegate:[LRRestyClientProxyDelegate proxyForClient:self responseDelegate:delegate]];
}

- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload withBlock:(LRRestyResponseBlock)block;
{
  return [self post:urlString payload:payload headers:nil withBlock:block];
}

- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  return [self postURL:[NSURL URLWithString:urlString] payload:payload headers:headers withBlock:block];
}

@end
