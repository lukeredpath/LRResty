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
  
  dispatch_queue_t synchronousProxyQueue = dispatch_queue_create("co.uk.lukeredpath.resty.synchronousProxy", NULL);
  
  dispatch_sync(synchronousProxyQueue, ^{
    NSCondition *condition = [[NSCondition alloc] init];
    
    id blockResult = nil;
    
    block(&blockResult, condition);
    
    [condition lock];
    
    if (timeout > 0) {
      [condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:timeout]];
    }
    else {
      [condition wait];
    }
    
    [condition unlock];
    [condition release];
    
    result = blockResult;
  });
  
  dispatch_release(synchronousProxyQueue);
  
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
