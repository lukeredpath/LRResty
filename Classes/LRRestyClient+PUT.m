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

@implementation LRRestyClient (PUT)

- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  return [self put:urlString payload:payload headers:nil delegate:delegate];
}

- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  return [HTTPClient PUT:[NSURL URLWithString:urlString] payload:payload headers:headers delegate:[LRRestyClientProxyDelegate proxyForClient:self responseDelegate:delegate]];
}

- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload withBlock:(LRRestyResponseBlock)block;
{
  return [self put:urlString payload:payload headers:nil withBlock:block];
}

- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  return [self putURL:[NSURL URLWithString:urlString] payload:payload headers:headers withBlock:block];
}

@end
