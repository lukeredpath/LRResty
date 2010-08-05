//
//  LRRestyClient+GET.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient+GET.h"


@implementation LRRestyClient (GET)

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

@end
