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
- (LRRestyRequest *)requestForURL:(NSURL *)url method:(NSString *)httpMethod payload:(id)payload headers:(NSDictionary *)headers requestDelegate:(id<LRRestyRequestDelegate>)requestDelegate;
@end

@implementation LRRestyHTTPClient

@synthesize delegate;

- (id)init
{
  if ((self = [super init])) {
    operationQueue = [[NSOperationQueue alloc] init];
  }
  return self;
}

- (id)initWithDelegate:(id<LRRestyHTTPClientDelegate>)aDelegate;
{
  if ((self = [self init])) {
    delegate = aDelegate;
  }
  return self;
}


- (void)cancelAllRequests
{
  [operationQueue cancelAllOperations];
}

- (LRRestyRequest *)GET:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyRequestDelegate>)requestDelegate;
{
  LRRestyRequest *request = [self requestForURL:url method:@"GET" payload:nil headers:headers requestDelegate:requestDelegate];
  [request setQueryParameters:parameters];
  return [self performRequest:request];
}

- (LRRestyRequest *)POST:(NSURL *)url payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyRequestDelegate>)requestDelegate;
{
  return [self performRequest:[self requestForURL:url method:@"POST" payload:payload headers:headers requestDelegate:requestDelegate]];
}

- (LRRestyRequest *)PUT:(NSURL *)url payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyRequestDelegate>)requestDelegate;
{
  return [self performRequest:[self requestForURL:url method:@"PUT" payload:payload headers:headers requestDelegate:requestDelegate]];
}

- (LRRestyRequest *)DELETE:(NSURL *)url headers:(NSDictionary *)headers delegate:(id<LRRestyRequestDelegate>)requestDelegate;
{
    return [self performRequest:[self requestForURL:url method:@"DELETE" payload:nil headers:headers requestDelegate:requestDelegate]];
}

#pragma mark Private methods

- (LRRestyRequest *)requestForURL:(NSURL *)url method:(NSString *)httpMethod payload:(id)payload headers:(NSDictionary *)headers requestDelegate:(id<LRRestyRequestDelegate>)requestDelegate;
{
  LRRestyRequest *request = [[LRRestyRequest alloc] initWithURL:url method:httpMethod delegate:requestDelegate];
  [request setPayload:[LRRestyRequestPayloadFactory payloadFromObject:payload]];
  [request setHeaders:headers];
  return request;
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
