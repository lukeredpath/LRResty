//
//  HCPassesBlock.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "HCPassesBlock.h"
#import "HCDescription.h"

@implementation HCPassesBlock

+ (id)passesBlock:(HCPassesBlockBlock)block withMessage:(NSString *)message;
{
  return [[[self alloc] initWithBlock:block expectationMessage:message] autorelease];
}

- (id)initWithBlock:(HCPassesBlockBlock)theBlock expectationMessage:(NSString *)expectationMessage;
{
  if (self = [super init]) {
    block = Block_copy(theBlock);
    message = [expectationMessage copy];
  }
  return self;
}

- (void)dealloc
{
  Block_release(block);
  [message release];
  [super dealloc];
}

- (BOOL)matches:(id)item
{
  return block(item);
}

- (void)describeTo:(id <HCDescription>)description
{
  [description appendText:message];
}

@end

id<HCMatcher> HC_passesBlock(HCPassesBlockBlock theBlock, NSString *expectationMessage)
{
  return [HCPassesBlock passesBlock:theBlock withMessage:expectationMessage];
}
