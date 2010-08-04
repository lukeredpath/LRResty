//
//  LRRestyClient+POST.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient+POST.h"
#import "LRRestyClientBlockDelegate.h"

@implementation LRRestyClient (POST)

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

@end