//
//  LRSynchronousProxy.m
//  LRResty
//
//  Created by Luke Redpath on 20/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "LRSynchronousProxy.h"
#import "NSRunLoop+Additions.h"

@implementation LRSynchronousProxy

+ (id)performAsynchronousBlockAndReturnResultWhenReady:(LRSynchronousProxyBlock)block;
{
  return [self performAsynchronousBlockWithTimeout:0 andReturnResultWhenReady:block];
}

+ (id)performAsynchronousBlockWithTimeout:(NSTimeInterval)timeout andReturnResultWhenReady:(LRSynchronousProxyBlock)block
{
  id result = nil;
  
  NSCondition *condition = [[NSCondition alloc] init];
  
  block(&result, condition);
  
  [condition lock];
  
  if (timeout > 0) {
    [condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:timeout]];
  }
  else {
    [condition wait];
  }

  [condition unlock];
  [condition release];
  
  return [result autorelease];
}

@end

@implementation NSObject (SynchronousProxy)

- (id)performAsynchronousBlockAndReturnResultWhenReady:(LRSynchronousProxyBlock)block;
{
  return [LRSynchronousProxy performAsynchronousBlockAndReturnResultWhenReady:block];
}

- (id)performAsynchronousBlockWithTimeout:(NSTimeInterval)timeout andReturnResultWhenReady:(LRSynchronousProxyBlock)block
{
  return [LRSynchronousProxy performAsynchronousBlockWithTimeout:timeout andReturnResultWhenReady:block];
}

@end
