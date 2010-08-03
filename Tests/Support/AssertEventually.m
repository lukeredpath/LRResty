//
//  AssertEventually.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "AssertEventually.h"
#import <SenTestingKit/SenTestCase.h>
#import "HCStringDescription.h"

@interface Timeout : NSObject
{
  NSDate *timeoutDate;
}
- (id)initWithTimeout:(NSTimeInterval)timeout;
- (BOOL)hasTimedOut;
@end

@implementation Timeout

- (id)initWithTimeout:(NSTimeInterval)timeout
{
  if (self = [super init]) {
    timeoutDate = [[NSDate alloc] initWithTimeIntervalSinceNow:timeout];
  }
  return self;
}

- (void)dealloc
{
  [timeoutDate release];
  [super dealloc];
}

- (BOOL)hasTimedOut
{
  return [timeoutDate timeIntervalSinceDate:[NSDate date]] < 0;
}

@end

#pragma mark -
#pragma mark Core

NSString *const ProbePollerTimedOutException = @"ProbePollerTimedOutException";

@implementation ProbePoller

- (id)initWithTimeout:(NSInteger)theTimeout delay:(NSInteger)theDelay;
{
  if (self = [super init]) {
    timeoutInterval = theTimeout;
    delayInterval = theDelay;
  }
  return self;
}

- (BOOL)check:(id<Probe>)probe;
{
  Timeout *timeout = [[Timeout alloc] initWithTimeout:timeoutInterval];
  
  while (![probe isSatisfied]) {
    if ([timeout hasTimedOut]) {
      return NO;
    }
    [NSThread sleepForTimeInterval:delayInterval];
    [probe sample];
  }
  return YES;
}

@end

void assertEventuallyWithLocationAndTimeout(SenTestCase *testCase, const char* fileName, int lineNumber, id<Probe>probe, NSTimeInterval timeout)
{
  ProbePoller *poller = [[ProbePoller alloc] initWithTimeout:timeout delay:kDEFAULT_PROBE_DELAY];
  if (![poller check:probe]) {
    NSString *failureMessage = [probe describeTo:[NSString stringWithFormat:@"Probe failed after %d second(s). ", (int)timeout]];
    
    [testCase failWithException:
      [NSException failureInFile:[NSString stringWithUTF8String:fileName] 
                          atLine:lineNumber 
                 withDescription:failureMessage]];
  }
  [poller release];
}

void assertEventuallyWithLocation(SenTestCase * testCase, const char* fileName, int lineNumber, id<Probe>probe)
{
  assertEventuallyWithLocationAndTimeout(testCase, fileName, lineNumber, probe, kDEFAULT_PROBE_TIMEOUT);
}

#pragma mark -
#pragma mark Block support

@implementation BlockProbe

+ (id)probeWithBlock:(BlockProbeBlock)block;
{
  return [[[self alloc] initWithBlock:block] autorelease];
}

- (id)initWithBlock:(BlockProbeBlock)aBlock;
{
  if (self = [super init]) {
    block = Block_copy(aBlock);
    isSatisfied = NO;
    [self sample];
  }
  return self;
}

- (void)dealloc
{
  Block_release(block);
  [super dealloc];
}

- (BOOL)isSatisfied;
{
  return isSatisfied;
}

- (void)sample;
{
  isSatisfied = block();
}
            
- (NSString *)describeTo:(NSString *)description;
{
  // FIXME: this is a bit shit and non-descriptive
  return [description stringByAppendingString:@"Block call did not return positive value."];
}

@end

#pragma mark -
#pragma mark Hamcrest support

@implementation HamcrestProbe

+ (id)probeWithObject:(id)object matcher:(id<HCMatcher>)matcher;
{
  return [[[self alloc] initWithObject:object matcher:matcher] autorelease];
}

- (id)initWithObject:(id)object matcher:(id<HCMatcher>)aMatcher;
{
  if (self = [super init]) {
    objectToMatch = [object retain];
    matcher = [aMatcher retain];
    [self sample];
  }
  return self;
}

- (void)dealloc
{
  [objectToMatch release];
  [matcher release];
  [super dealloc];
}

- (BOOL)isSatisfied;
{
  return didMatch;
}

- (void)sample;
{
  didMatch = [matcher matches:objectToMatch];
}

- (NSString *)describeTo:(NSString *)description;
{
  HCStringDescription* stringDescription = [HCStringDescription stringDescription];
  [[[[stringDescription appendText:@"Expected "]
               appendDescriptionOf:matcher]
                        appendText:@", got "]
                       appendValue:objectToMatch];
  
  return [description stringByAppendingString:[stringDescription description]];
}

@end
