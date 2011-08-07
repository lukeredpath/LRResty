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
#import "LRRestyRequestPayload.h"
#import "LRRestyRequest.h"
#import "LRRestyHTTPClient.h"

@implementation LRRestyClient

@synthesize delegate = clientDelegate;

- (id)init
{
  LRRestyHTTPClient *client = [[[LRRestyHTTPClient alloc] initWithDelegate:self] autorelease];
  return [self initWithHTTPClient:client];
}

- (id)initWithHTTPClient:(id<LRRestyHTTPClient>)aHTTPClient
{
  if ((self = [super init])) {
    HTTPClient = [aHTTPClient retain];
    HTTPClient.delegate = self;
    requestModifiers = [[NSMutableArray alloc] init];
  }
  return self;  
}

- (void)dealloc
{
  [HTTPClient release];
  [requestModifiers release];
  [globalTimeoutHandler release];
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

- (void)cancelAllRequests
{
  [HTTPClient cancelAllRequests];
}

- (void)setGlobalTimeout:(NSTimeInterval)timeout handleWithBlock:(LRRestyRequestTimeoutBlock)block
{
  [globalTimeoutHandler release];
  globalTimeoutHandler = [block copy];
  globalTimeoutInterval = timeout;
}

#pragma mark -
#pragma mark LRRestyHTTPClientDelegate methods

- (void)HTTPClient:(id <LRRestyHTTPClient>)client willPerformRequest:(LRRestyRequest *)request
{
  if ([clientDelegate respondsToSelector:@selector(restyClientWillPerformRequest:)] ){
    [clientDelegate restyClientWillPerformRequest:self];
  }
  __block LRRestyClient *blockClient = self;
  
  [request setCompletionBlock:^{
    if ([blockClient.delegate respondsToSelector:@selector(restyClientDidPerformRequest:)]) {
      [blockClient.delegate restyClientDidPerformRequest:blockClient];
    }
  }];
  for (LRRestyRequestBlock requestModifier in requestModifiers) {
    requestModifier(request);
  }
  if (globalTimeoutHandler) {
    [request timeoutAfter:globalTimeoutInterval handleWithBlock:globalTimeoutHandler];
  }
}

@end
