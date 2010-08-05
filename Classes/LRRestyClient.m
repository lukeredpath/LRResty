//
//  LRRestyClient.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient.h"
#import "LRRestyResponse.h"
#import "LRRestyClientDelegate.h"
#import "LRRestyRequest.h"
#import "NSDictionary+QueryString.h"
#import "LRRestyClientBlockDelegate.h"
#import "LRRestyRequestPayload.h"

@interface LRRestyClient ()
- (LRRestyRequest *)requestForURL:(NSURL *)url method:(NSString *)httpMethod headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
- (LRRestyRequest *)requestForURL:(NSURL *)url method:(NSString *)httpMethod payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
@end

#pragma mark -

@implementation LRRestyClient

- (id)init
{
  if (self = [super init]) {
    operationQueue = [[NSOperationQueue alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [operationQueue release];
  [super dealloc];
}

#pragma mark -
#pragma mark Core API

- (void)getURL:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  LRRestyRequest *request = [self requestForURL:url method:@"GET" headers:headers delegate:delegate];
  [request setQueryParameters:parameters];
  [operationQueue addOperation:request];
}

- (void)postURL:(NSURL *)url payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  [operationQueue addOperation:
    [self requestForURL:url method:@"POST" payload:payload headers:headers delegate:delegate]];
}

- (void)postURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  LRRestyRequest *request = [self requestForURL:url method:@"POST" headers:headers delegate:delegate];
  [request setPostData:postData];
  [operationQueue addOperation:request];
}

- (void)putURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  LRRestyRequest *request = [self requestForURL:url method:@"PUT" headers:headers delegate:delegate];
  [request setPostData:postData];
  [operationQueue addOperation:request];
}

#pragma mark -
#pragma mark Private

- (LRRestyRequest *)requestForURL:(NSURL *)url method:(NSString *)httpMethod headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  LRRestyRequest *request = [[LRRestyRequest alloc] initWithURL:url method:httpMethod client:self delegate:delegate];
  [request setHeaders:headers];
  return [request autorelease];
}

- (LRRestyRequest *)requestForURL:(NSURL *)url method:(NSString *)httpMethod payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  LRRestyRequest *request = [[LRRestyRequest alloc] initWithURL:url method:httpMethod client:self delegate:delegate];
  [request setPayload:[LRRestyRequestPayloadFactory payloadFromObject:payload]];
  [request setHeaders:headers];
  return [request autorelease];
}

@end

@implementation LRRestyClient (Blocks)

- (void)getURL:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self getURL:url parameters:parameters headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

- (void)postURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self postURL:url data:postData headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

- (void)putURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self putURL:url data:postData headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

@end
