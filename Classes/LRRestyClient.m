//
//  LRRestyClient.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient.h"
#import "LRRestyResponse.h"
#import "LRRestyClientResponseDelegate.h"
#import "LRRestyRequest.h"
#import "NSDictionary+QueryString.h"
#import "LRRestyClientBlockDelegate.h"
#import "LRRestyClientStreamingDelegate.h"
#import "LRRestyRequestPayload.h"
#import "LRRestyRequest.h"
#import "LRRestyClientProxyDelegate.h"


@implementation LRRestyClient

@synthesize delegate = clientDelegate;

- (id)init
{
  if (self = [super init]) {
    HTTPClient = [[LRRestyHTTPClient alloc] initWithDelegate:self];
    requestModifiers = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [HTTPClient release];
  [requestModifiers release];
  [super dealloc];
}

- (NSInteger)attachRequestModifier:(LRRestyRequestBlock)block;
{
  LRRestyRequestBlock modifier = [block copy];
  [requestModifiers addObject:modifier];
  [modifier release];
  return [requestModifiers indexOfObject:modifier];
}

- (void)removeRequestModifierAtIndex:(NSInteger)index
{
  [requestModifiers removeObjectAtIndex:index];
}

- (void)setHandlesCookiesAutomatically:(BOOL)shouldHandleCookies;
{
  [self attachRequestModifier:^(LRRestyRequest *request) {
    [request setHandlesCookiesAutomatically:shouldHandleCookies];
  }];
}

- (void)setUsername:(NSString *)username password:(NSString *)password;
{
  [self attachRequestModifier:^(LRRestyRequest *request) {
    [request setBasicAuthUsername:username password:password useCredentialSystem:NO];
  }];
}

- (void)HTTPClient:(id <LRRestyHTTPClient>)client willPerformRequest:(LRRestyRequest *)request
{
  if ([clientDelegate respondsToSelector:@selector(restyClientWillPerformRequest:)] ){
    [clientDelegate restyClientWillPerformRequest:self];
  }
  [request setCompletionBlock:^{
    if ([clientDelegate respondsToSelector:@selector(restyClientDidPerformRequest:)]) {
      [clientDelegate restyClientDidPerformRequest:self];
    }
  }];
  for (LRRestyRequestBlock requestModifier in requestModifiers) {
    requestModifier(request);
  }
}

@end

@implementation LRRestyClient (Blocks)

- (LRRestyRequest *)getURL:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  return [HTTPClient getURL:url parameters:parameters headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

- (void)postURL:(NSURL *)url payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [HTTPClient postURL:url payload:payload headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

- (void)putURL:(NSURL *)url payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [HTTPClient putURL:url payload:payload headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

@end

@implementation LRRestyClient (Streaming)

- (LRRestyRequest *)getURL:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers 
        onData:(LRRestyStreamingDataBlock)dataHandler onError:(LRRestyStreamingErrorBlock)errorHandler;
{
  return [HTTPClient getURL:url parameters:parameters headers:headers delegate:[LRRestyClientStreamingDelegate delegateWithDataHandler:dataHandler errorHandler:errorHandler]];
}

@end

