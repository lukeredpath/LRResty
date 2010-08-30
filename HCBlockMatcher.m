//
//  HCBlockMatcher.m
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "HCBlockMatcher.h"
#import "HCDescription.h"

@implementation HCBlockMatcher

+ (id)matcherWithBlock:(HCBlockMatcherBlock)block description:(NSString *)aDescription;
{
  return [[[self alloc] initWithBlock:block description:aDescription] autorelease];
}

- (id)initWithBlock:(HCBlockMatcherBlock)aBlock description:(NSString *)aDescription;
{
  if (self = [super init]) {
    block = Block_copy(aBlock);
    description = [aDescription copy];
  }
  return self;
}

- (void)dealloc
{
  [description release];
  Block_release(block);
  [super dealloc];
}

- (BOOL)matches:(id)actual
{
  return block(actual);
}

- (void)describeTo:(id <HCDescription>)_description
{
  [_description appendText:description];
}

@end

#ifdef __cplusplus
extern "C" {
#endif
  id<HCMatcher> HC_satisfiesBlock(NSString *description, HCBlockMatcherBlock block)
  {
    return [HCBlockMatcher matcherWithBlock:block description:description];
  }
#ifdef __cplusplus
}
#endif
