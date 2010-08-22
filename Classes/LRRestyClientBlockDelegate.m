//
//  LRRestyResponseBlock.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClientBlockDelegate.h"


@implementation LRRestyClientBlockDelegate

+ (id)delegateWithBlock:(LRRestyResponseBlock)block errorHandler:(LRRestyErrorHandlerBlock)errorHandler;
{
  return [[[self alloc] initWithBlock:block errorHandler:errorHandler] autorelease];
}

- (id)initWithBlock:(LRRestyResponseBlock)theBlock errorHandler:(LRRestyErrorHandlerBlock)errorBlock;
{
  if (self = [super init]) {
    block = Block_copy(theBlock);
    errorHandlerBlock = Block_copy(errorBlock);
  }
  return self;
}

- (void)dealloc
{
  Block_release(errorHandlerBlock);
  Block_release(block);
  [super dealloc];
}

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response
{
  block(response);
}

- (void)restClient:(LRRestyClient *)client failedWithError:(NSError *)error
{
  errorHandlerBlock(error);
}

@end
