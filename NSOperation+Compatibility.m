//
//  NSOperation+Compatibility.m
//  LRResty
//
//  Created by Luke Redpath on 29/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "NSOperation+Compatibility.h"

@interface LRNSOperationCompletionObserver : NSObject
{
  void (^completionBlock)(void);
}
- (id)initWithBlock:(void (^)(void))block;
@end

@implementation LRNSOperationCompletionObserver

- (id)initWithBlock:(void (^)(void))block;
{
  if (self = [super init]) {
    completionBlock = Block_copy(block);
  }
  return self;
}

- (void)dealloc
{
  Block_release(completionBlock);
  [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if ([keyPath isEqualToString:@"isFinished"]) {
    completionBlock();
    [self release];
  }
}

@end

@implementation NSOperation (Compatibility)

static LRNSOperationCompletionObserver *__LRCompletionObserver = nil;

- (void)setCompletionBlock:(void (^)(void))block
{
  __LRCompletionObserver = [[LRNSOperationCompletionObserver alloc] initWithBlock:block];
  [self addObserver:__LRCompletionObserver forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
}

@end

