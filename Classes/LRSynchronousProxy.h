//
//  LRSynchronousProxy.h
//  LRResty
//
//  Created by Luke Redpath on 20/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LRSYNCHRONOUS_PROXY_NOTIFY_CONDITION(resultPtr, result, semaphore) \
  *resultPtr = result; dispatch_semaphore_signal(semaphore);

typedef void (^LRSynchronousProxyBlock)(id *, dispatch_semaphore_t);

@interface LRSynchronousProxy : NSObject {

}
+ (id)performAsynchronousBlockAndReturnResultWhenReady:(LRSynchronousProxyBlock)block;
+ (id)performAsynchronousBlockWithTimeout:(NSTimeInterval)timeout andReturnResultWhenReady:(LRSynchronousProxyBlock)block;
@end

@interface NSObject (SynchronousProxy)

- (id)performAsynchronousBlockAndReturnResultWhenReady:(LRSynchronousProxyBlock)block;
- (id)performAsynchronousBlockWithTimeout:(NSTimeInterval)timeout andReturnResultWhenReady:(LRSynchronousProxyBlock)block;

@end
