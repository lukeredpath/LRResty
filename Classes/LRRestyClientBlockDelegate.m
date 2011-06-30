//
//  LRRestyResponseBlock.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClientBlockDelegate.h"


@implementation LRRestyClientBlockDelegate

+ (id)delegateWithBlock:(LRRestyResponseBlock)block;
{
  return [[self alloc] initWithBlock:block];
}

- (id)initWithBlock:(LRRestyResponseBlock)theBlock;
{
  if ((self = [super init])) {
    block = [theBlock copy];
  }
  return self;
}


- (void)restyRequest:(LRRestyRequest *)request didFinishWithResponse:(LRRestyResponse *)response
{
  if (block) {
    block(response);
  }
}

@end
