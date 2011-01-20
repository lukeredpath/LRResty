//
//  NSObject+SynchronousProxy.m
//  LRResty
//
//  Created by Luke Redpath on 20/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "NSObject+SynchronousProxy.h"


@implementation NSObject (SynchronousProxy)

- (id)performAsynchronousBlockAndReturnResultWhenReady:(LRSynchronousProxyBlock)block;
{
  return [LRSynchronousProxy performAsynchronousBlockAndReturnResultWhenReady:block];
}

@end
