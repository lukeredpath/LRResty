//
//  LRRestyResponseBlock.h
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClient.h"

@interface LRRestyClientBlockDelegate : NSObject <LRRestyClientResponseDelegate>
{
  LRRestyResponseBlock block;
  LRRestyErrorHandlerBlock errorHandlerBlock;
}
+ (id)delegateWithBlock:(LRRestyResponseBlock)block errorHandler:(LRRestyErrorHandlerBlock)errorHandler;
- (id)initWithBlock:(LRRestyResponseBlock)theBlock errorHandler:(LRRestyErrorHandlerBlock)errorBlock;
@end
