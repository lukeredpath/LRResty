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
  return [[[self alloc] initWithBlock:block] autorelease];
}

- (id)initWithBlock:(LRRestyResponseBlock)theBlock;
{
  if (self = [super init]) {
    block = Block_copy(theBlock);
  }
  return self;
}

- (void)dealloc
{
  Block_release(block);
  [super dealloc];
}

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response
{
  block(response);
}

@end
