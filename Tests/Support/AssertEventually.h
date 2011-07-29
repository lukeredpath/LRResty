//
//  AssertEventually.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCMatcher.h"

#define kDEFAULT_PROBE_TIMEOUT 1
#define kDEFAULT_PROBE_DELAY   0.1

@protocol LRProbe <NSObject>
- (BOOL)isSatisfied;
- (void)sampleWithCondition:(NSCondition *)condition;
- (NSString *)describeToString:(NSString *)description;
@end

@interface LRProbePoller : NSObject
{
  NSTimeInterval timeoutInterval;
  NSTimeInterval delayInterval;
  NSCondition *condition;
}
- (id)initWithTimeout:(NSTimeInterval)theTimeout delay:(NSTimeInterval)theDelay;
- (BOOL)check:(id<LRProbe>)probe;
@end

@class SenTestCase;

void LR_assertEventuallyWithLocationAndTimeout(SenTestCase *testCase, const char* fileName, int lineNumber, id<LRProbe>probe, NSTimeInterval timeout);
void LR_assertEventuallyWithLocation(SenTestCase *testCase, const char* fileName, int lineNumber, id<LRProbe>probe);

#define assertEventuallyWithTimeout(probe, timeout) \
        LR_assertEventuallyWithLocationAndTimeout(self, __FILE__, __LINE__, probe, timeout)

#define assertEventually(probe) \
        LR_assertEventuallyWithLocation(self, __FILE__, __LINE__, probe)

typedef BOOL (^LRBlockProbeBlock)();

@interface LRBlockProbe : NSObject <LRProbe>
{
  LRBlockProbeBlock block;
  BOOL isSatisfied;
}
+ (id)probeWithBlock:(LRBlockProbeBlock)block;
- (id)initWithBlock:(LRBlockProbeBlock)aBlock;
@end

#define assertEventuallyWithBlockAndTimeout(block,timeout) \
        assertEventuallyWithTimeout([LRBlockProbe probeWithBlock:block], timeout)

#define assertEventuallyWithBlock(block) \
        assertEventually([LRBlockProbe probeWithBlock:block])

@interface LRHamcrestProbe : NSObject <LRProbe>
{
  id *pointerToActualObject;
  id<HCMatcher> matcher;
  BOOL didMatch;
}
+ (id)probeWithObjectPointer:(id *)objectPtr matcher:(id<HCMatcher>)matcher;
- (id)initWithObjectPointer:(id *)objectPtr matcher:(id<HCMatcher>)aMatcher;
- (id)actualObject;
@end

#define assertEventuallyThatWithTimeout(objectPtr, aMatcher, timeout) \
        assertEventuallyWithTimeout([LRHamcrestProbe probeWithObjectPointer:objectPtr matcher:aMatcher], timeout)

#define assertEventuallyThat(objectPtr, aMatcher) \
        assertEventually([LRHamcrestProbe probeWithObjectPointer:objectPtr matcher:aMatcher])
