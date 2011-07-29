//
//  LRRestyResponseBlock.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClientBlockDelegate.h"


@implementation LRRestyClientBlockDelegate

static BOOL _shouldDispatchOnMainQueue = YES;

+ (void)setDispatchesOnMainQueue:(BOOL)shouldDispatchOnMainQueue
{
  _shouldDispatchOnMainQueue = shouldDispatchOnMainQueue;
}

+ (id)delegateWithBlock:(LRRestyResponseBlock)block;
{
  return [[[self alloc] initWithBlock:block] autorelease];
}

- (id)initWithBlock:(LRRestyResponseBlock)theBlock;
{
  if ((self = [super init])) {
    block = [theBlock copy];
  }
  return self;
}

- (void)dealloc
{
  [block release];
  [super dealloc];
}

- (void)restyRequest:(LRRestyRequest *)request didFinishWithResponse:(LRRestyResponse *)response
{
  if (block) {
    if (_shouldDispatchOnMainQueue) {
      dispatch_async(dispatch_get_main_queue(), ^{
        block(response);
      });
    }
    else {
      block(response);
    }
  }
}

@end
