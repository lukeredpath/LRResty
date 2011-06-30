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
  
  block(&result);
  
  while (result == nil) {
    [[NSRunLoop currentRunLoop] runForTimeInterval:0.1];
  }
  return result;
}

@end
