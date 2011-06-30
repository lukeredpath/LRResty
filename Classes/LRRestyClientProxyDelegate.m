//
//  LRRestyClientProxyDelegate.m
//  LRResty
//
//  Created by Luke Redpath on 29/09/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClientProxyDelegate.h"


@implementation LRRestyClientProxyDelegate

+ (id)proxyForClient:(LRRestyClient *)client responseDelegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  return [[self alloc] initWithClient:client responseDelegate:delegate];
}

- (id)initWithClient:(LRRestyClient *)client responseDelegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  if ((self = [super init])) {
    restyClient = client;
    responseDelegate = delegate;
  }
  return self;
}


- (void)restyRequestDidStart:(LRRestyRequest *)request;
{
  if ([responseDelegate respondsToSelector:@selector(restClient:willPerformRequest:)]) {
    [responseDelegate restClient:restyClient willPerformRequest:request];
  } 
}

- (void)restyRequest:(LRRestyRequest *)request didReceiveData:(NSData *)data;
{
  if ([responseDelegate respondsToSelector:@selector(restClient:request:receivedData:)]) {
    [responseDelegate restClient:restyClient request:request receivedData:data];
  }
}

- (void)restyRequest:(LRRestyRequest *)request didFinishWithResponse:(LRRestyResponse *)response;
{
  [responseDelegate restClient:restyClient receivedResponse:response];
}

@end
