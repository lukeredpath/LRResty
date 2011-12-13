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
  __block id result = nil;
  
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
  
  block(&result, semaphore);
  
  if (timeout > 0) {
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * timeout));
  }
  else {
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
  }  
  
  dispatch_release(semaphore);
  
  return result;
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
