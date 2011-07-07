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
  id result = nil;
  
  NSCondition *condition = [[NSCondition alloc] init];
  
  block(&result, condition);
  
  [condition lock];
  [condition wait];
  [condition unlock];

  [condition release];
  
  return [result autorelease];
}

@end
