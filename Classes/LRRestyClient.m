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
#import "LRRestyClientBlockDelegate.h"
#import "NSDictionary+QueryString.h"


@interface LRRestyClient ()
- (LRRestyRequest *)requestForURL:(NSURL *)url method:(NSString *)httpMethod headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
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

- (LRRestyRequest *)requestForURL:(NSURL *)url method:(NSString *)httpMethod headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  LRRestyRequest *request = [[LRRestyRequest alloc] initWithURL:url method:httpMethod client:self delegate:delegate];
  [request setHeaders:headers];
  return [request autorelease];
}

#pragma mark -
#pragma mark GET requests

- (void)get:(NSString *)urlString delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self get:urlString parameters:nil delegate:delegate];
}

- (void)get:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self get:urlString parameters:parameters headers:nil delegate:delegate];
}

- (void)get:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self getURL:[NSURL URLWithString:urlString] parameters:parameters headers:headers delegate:delegate];
}

- (void)getURL:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  LRRestyRequest *request = [self requestForURL:url method:@"GET" headers:headers delegate:delegate];
  [request setQueryParameters:parameters];
  [operationQueue addOperation:request];
}

#pragma mark withBlock

- (void)get:(NSString *)urlString withBlock:(LRRestyResponseBlock)block;
{
  [self get:urlString parameters:nil withBlock:block];
}

- (void)get:(NSString *)urlString parameters:(NSDictionary *)parameters withBlock:(LRRestyResponseBlock)block;
{
  [self get:urlString parameters:parameters headers:nil withBlock:block];
}

- (void)get:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self getURL:[NSURL URLWithString:urlString] parameters:parameters headers:headers withBlock:block];
}

- (void)getURL:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self getURL:url parameters:parameters headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

#pragma mark -
#pragma mark POST requests

- (void)post:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self post:urlString parameters:parameters headers:nil delegate:delegate];
}

- (void)post:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  NSMutableDictionary *mergedHeaders = [headers mutableCopy];
  if (mergedHeaders == nil) {
    mergedHeaders = [NSMutableDictionary dictionary];
  }
  [mergedHeaders setObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
  
  [self post:urlString 
        data:[[parameters stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding] 
     headers:mergedHeaders
    delegate:delegate];
}

- (void)post:(NSString *)urlString data:(NSData *)postData delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self post:urlString data:postData headers:nil delegate:delegate];
}

- (void)post:(NSString *)urlString data:(NSData *)postData headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self postURL:[NSURL URLWithString:urlString] data:postData headers:headers delegate:delegate];
}

- (void)postURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  LRRestyRequest *request = [self requestForURL:url method:@"POST" headers:headers delegate:delegate];
  [request setPostData:postData];
  [operationQueue addOperation:request];
}

#pragma mark withBlock

- (void)post:(NSString *)urlString parameters:(NSDictionary *)parameters withBlock:(LRRestyResponseBlock)block;
{
  [self post:urlString parameters:parameters headers:nil withBlock:block];
}

- (void)post:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self post:urlString parameters:parameters headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

- (void)post:(NSString *)urlString data:(NSData *)postData withBlock:(LRRestyResponseBlock)block;
{
  [self post:urlString data:postData headers:nil withBlock:block];
}

- (void)post:(NSString *)urlString data:(NSData *)postData headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self postURL:[NSURL URLWithString:urlString] data:postData headers:headers withBlock:block];
}

- (void)postURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self postURL:url data:postData headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

#pragma mark -
#pragma mark PUT requests

- (void)put:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self put:urlString parameters:parameters headers:nil delegate:delegate];
}

- (void)put:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  NSMutableDictionary *mergedHeaders = [headers mutableCopy];
  if (mergedHeaders == nil) {
    mergedHeaders = [NSMutableDictionary dictionary];
  }
  [mergedHeaders setObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
  
  [self put:urlString 
       data:[[parameters stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding] 
    headers:mergedHeaders
   delegate:delegate];
}

- (void)put:(NSString *)urlString data:(NSData *)postData delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self put:urlString data:postData headers:nil delegate:delegate];
}

- (void)put:(NSString *)urlString data:(NSData *)postData headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self putURL:[NSURL URLWithString:urlString] data:postData headers:headers delegate:delegate];
}

- (void)putURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  LRRestyRequest *request = [self requestForURL:url method:@"PUT" headers:headers delegate:delegate];
  [request setPostData:postData];
  [operationQueue addOperation:request];
}

#pragma mark withBlock

- (void)put:(NSString *)urlString parameters:(NSDictionary *)parameters withBlock:(LRRestyResponseBlock)block;
{
  [self put:urlString parameters:parameters headers:nil withBlock:block];
}

- (void)put:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self put:urlString parameters:parameters headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

- (void)put:(NSString *)urlString data:(NSData *)postData withBlock:(LRRestyResponseBlock)block;
{
  [self put:urlString data:postData headers:nil withBlock:block];
}

- (void)put:(NSString *)urlString data:(NSData *)postData headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self putURL:[NSURL URLWithString:urlString] data:postData headers:headers withBlock:block];
}

- (void)putURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self putURL:url data:postData headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

@end

