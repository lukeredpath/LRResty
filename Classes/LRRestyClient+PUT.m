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

- (void)put:(NSString *)urlString payload:(id)payload delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  [self put:urlString payload:payload headers:nil delegate:delegate];
}

- (void)put:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)delegate;
{
  [self putURL:[NSURL URLWithString:urlString] payload:payload headers:headers delegate:delegate];
}

- (void)put:(NSString *)urlString payload:(id)payload withBlock:(LRRestyResponseBlock)block;
{
  [self put:urlString payload:payload headers:nil withBlock:block];
}

- (void)put:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self put:urlString payload:payload headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

@end
