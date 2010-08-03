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

@protocol Probe <NSObject>
- (BOOL)isSatisfied;
- (void)sample;
- (NSString *)describeTo:(NSString *)description;
@end

extern NSString *const ProbePollerTimedOutException;

@interface ProbePoller : NSObject
{
  NSTimeInterval timeoutInterval;
  NSTimeInterval delayInterval;
}
- (id)initWithTimeout:(NSInteger)theTimeout delay:(NSInteger)theDelay;
- (BOOL)check:(id<Probe>)probe;
@end

@class SenTestCase;

void assertEventuallyWithLocationAndTimeout(SenTestCase *testCase, const char* fileName, int lineNumber, id<Probe>probe, NSTimeInterval timeout);
void assertEventuallyWithLocation(SenTestCase *testCase, const char* fileName, int lineNumber, id<Probe>probe);

#define assertEventuallyWithTimeout(probe, timeout) \
        assertEventuallyWithLocationAndTimeout(self, __FILE__, __LINE__, probe, timeout)

#define assertEventually(probe) \
        assertEventuallyWithLocation(self, __FILE__, __LINE__, probe)

typedef BOOL (^BlockProbeBlock)();

@interface BlockProbe : NSObject <Probe>
{
  BlockProbeBlock block;
  BOOL isSatisfied;
}
+ (id)probeWithBlock:(BlockProbeBlock)block;
- (id)initWithBlock:(BlockProbeBlock)aBlock;
@end

#define assertEventuallyWithBlockAndTimeout(block,timeout) \
        assertEventuallyWithTimeout([BlockProbe probeWithBlock:block], timeout)

#define assertEventuallyWithBlock(block) \
        assertEventually([BlockProbe probeWithBlock:block])

@interface HamcrestProbe : NSObject <Probe>
{
  id objectToMatch;
  id<HCMatcher> matcher;
  BOOL didMatch;
}
+ (id)probeWithObject:(id)object matcher:(id<HCMatcher>)matcher;
- (id)initWithObject:(id)object matcher:(id<HCMatcher>)aMatcher;
@end

#define assertEventuallyThatWithTimeout(object, aMatcher, timeout) \
        assertEventuallyWithTimeout([HamcrestProbe probeWithObject:object matcher:aMatcher], timeout)

#define assertEventuallyThat(object, aMatcher) \
        assertEventually([HamcrestProbe probeWithObject:object matcher:aMatcher])
