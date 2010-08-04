//
//  LRRestyClient+PUT.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient+PUT.h"
#import "LRRestyClientBlockDelegate.h"

@implementation LRRestyClient (PUT)

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

@end
