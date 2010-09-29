//
//  LRRestyHTTPClient.m
//  LRResty
//
//  Created by Luke Redpath on 29/09/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyHTTPClient.h"
#import "LRRestyRequest.h"

@interface LRRestyHTTPClient ()
- (LRRestyRequest *)performRequest:(LRRestyRequest *)request;
- (LRRestyRequest *)requestForURL:(NSURL *)url method:(NSString *)httpMethod payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)delegate;
@end

@implementation LRRestyHTTPClient

- (id)initWithDelegate:(id<LRRestyHTTPClientDelegate>)aDelegate;
{
  if (self = [super init]) {
    delegate = aDelegate;
    operationQueue = [[NSOperationQueue alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [operationQueue release];
  [super dealloc];
}

- (LRRestyRequest *)getURL:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)responseDelegate;
{
  LRRestyRequest *request = [self requestForURL:url method:@"GET" payload:nil headers:headers delegate:responseDelegate];
  [request setQueryParameters:parameters];
  return [self performRequest:request];
}

- (void)postURL:(NSURL *)url payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)responseDelegate;
{
  [self performRequest:[self requestForURL:url method:@"POST" payload:payload headers:headers delegate:responseDelegate]];
}

- (void)putURL:(NSURL *)url payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)responseDelegate;
{
  [self performRequest:[self requestForURL:url method:@"PUT" payload:payload headers:headers delegate:responseDelegate]];
}

#pragma mark Private methods

- (LRRestyRequest *)requestForURL:(NSURL *)url method:(NSString *)httpMethod payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)responseDelegate;
{
  LRRestyRequest *request = [[LRRestyRequest alloc] initWithURL:url method:httpMethod client:nil delegate:responseDelegate];
  [request setPayload:[LRRestyRequestPayloadFactory payloadFromObject:payload]];
  [request setHeaders:headers];
  return [request autorelease];
}

- (LRRestyRequest *)performRequest:(LRRestyRequest *)request;
{
  if ([delegate respondsToSelector:@selector(HTTPClient:willPerformRequest:)]) {
    [delegate HTTPClient:self willPerformRequest:request];
  }
  [operationQueue addOperation:request];

  return request;
}

@end
