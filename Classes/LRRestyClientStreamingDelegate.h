//
//  LRRestyClientStreamingDelegate.h
//  LRResty
//
//  Created by Luke Redpath on 30/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClientBlockDelegate.h"
#import "LRRestyTypes.h"

extern NSString *const LRRestyClientStreamingErrorDomain;

typedef enum {
  LRRestyStreamingErrorUnsuccessfulResponse = 100
} LRRestyStreamingErrorCode;

@interface LRRestyClientStreamingDelegate : LRRestyClientBlockDelegate
{
  LRRestyStreamingDataBlock dataHandler;
  LRRestyStreamingErrorBlock errorHandler;
}
+ (id)delegateWithBlock:(LRRestyResponseBlock)theBlock dataHandler:(LRRestyStreamingDataBlock)dataBlock errorHandler:(LRRestyStreamingErrorBlock)errorBlock;
- (id)initWithBlock:(LRRestyResponseBlock)theBlock dataHandler:(LRRestyStreamingDataBlock)dataBlock errorHandler:(LRRestyStreamingErrorBlock)errorBlock;
@end

