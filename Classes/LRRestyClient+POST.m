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

- (void)post:(NSString *)urlString payload:(id)payload delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  [self post:urlString payload:payload headers:nil delegate:delegate];
}

- (void)post:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  [self postURL:[NSURL URLWithString:urlString] payload:payload headers:headers delegate:delegate];
}

- (void)post:(NSString *)urlString payload:(id)payload withBlock:(LRRestyResponseBlock)block;
{
  [self post:urlString payload:payload headers:nil withBlock:block];
}

- (void)post:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self post:urlString payload:payload headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

@end