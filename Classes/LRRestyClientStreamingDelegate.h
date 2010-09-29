//
//  LRRestyClientStreamingDelegate.h
//  LRResty
//
//  Created by Luke Redpath on 30/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClientResponseDelegate.h"
#import "LRRestyTypes.h"

extern NSString *const LRRestyClientStreamingErrorDomain;

typedef enum {
  LRRestyStreamingErrorUnsuccessfulResponse = 100
} LRRestyStreamingErrorCode;

@interface LRRestyClientStreamingDelegate : NSObject <LRRestyClientResponseDelegate>
{
  LRRestyStreamingDataBlock dataHandler;
  LRRestyStreamingErrorBlock errorHandler;
}
+ (id)delegateWithDataHandler:(LRRestyStreamingDataBlock)dataBlock errorHandler:(LRRestyStreamingErrorBlock)errorBlock;
- (id)initWithDataHandler:(LRRestyStreamingDataBlock)dataBlock errorHandler:(LRRestyStreamingErrorBlock)errorBlock;
@end

