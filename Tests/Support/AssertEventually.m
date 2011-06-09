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

@interface LRTimeout : NSObject
{
  NSDate *timeoutDate;
}
- (id)initWithTimeout:(NSTimeInterval)timeout;
- (BOOL)hasTimedOut;
@end

@implementation LRTimeout

- (id)initWithTimeout:(NSTimeInterval)timeout
{
  if ((self = [super init])) {
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

@implementation LRProbePoller

- (id)initWithTimeout:(NSTimeInterval)theTimeout delay:(NSTimeInterval)theDelay;
{
  if ((self = [super init])) {
    timeoutInterval = theTimeout;
    delayInterval = theDelay;
  }
  return self;
}

- (BOOL)check:(id<LRProbe>)probe;
{
  LRTimeout *timeout = [[LRTimeout alloc] initWithTimeout:timeoutInterval];
  
  while (![probe isSatisfied]) {
    if ([timeout hasTimedOut]) {
      [timeout release];
      return NO;
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:delayInterval]];
    [probe sample];
  }
  [timeout release];
  
  return YES;
}

@end

void LR_assertEventuallyWithLocationAndTimeout(SenTestCase *testCase, const char* fileName, int lineNumber, id<LRProbe>probe, NSTimeInterval timeout)
{
  LRProbePoller *poller = [[LRProbePoller alloc] initWithTimeout:timeout delay:kDEFAULT_PROBE_DELAY];
  if (![poller check:probe]) {
    NSString *failureMessage = [probe describeToString:[NSString stringWithFormat:@"Probe failed after %d second(s). ", (int)timeout]];
    
    [testCase failWithException:
      [NSException failureInFile:[NSString stringWithUTF8String:fileName] 
                          atLine:lineNumber 
                 withDescription:failureMessage]];
  }
  [poller release];
}

void LR_assertEventuallyWithLocation(SenTestCase *testCase, const char* fileName, int lineNumber, id<LRProbe>probe)
{
  LR_assertEventuallyWithLocationAndTimeout(testCase, fileName, lineNumber, probe, kDEFAULT_PROBE_TIMEOUT);
}

#pragma mark -
#pragma mark Block support

@implementation LRBlockProbe

+ (id)probeWithBlock:(LRBlockProbeBlock)block;
{
  return [[[self alloc] initWithBlock:block] autorelease];
}

- (id)initWithBlock:(LRBlockProbeBlock)aBlock;
{
  if ((self = [super init])) {
    block = [block copy];
    isSatisfied = NO;
    [self sample];
  }
  return self;
}

- (void)dealloc
{
  [block release];
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
            
- (NSString *)describeToString:(NSString *)description;
{
  // FIXME: this is a bit shit and non-descriptive
  return [description stringByAppendingString:@"Block call did not return positive value."];
}

@end

#pragma mark -
#pragma mark Hamcrest support

@implementation LRHamcrestProbe

+ (id)probeWithObjectPointer:(id *)objectPtr matcher:(id<HCMatcher>)matcher;
{
  return [[[self alloc] initWithObjectPointer:objectPtr matcher:matcher] autorelease];
}

- (id)initWithObjectPointer:(id *)objectPtr matcher:(id<HCMatcher>)aMatcher;
{
  if ((self = [super init])) {
    pointerToActualObject = objectPtr;
    matcher = [aMatcher retain];
    [self sample];
  }
  return self;
}

- (void)dealloc
{
  [matcher release];
  [super dealloc];
}

- (BOOL)isSatisfied;
{
  return didMatch;
}

- (void)sample;
{
  didMatch = [matcher matches:[self actualObject]];
}

- (NSString *)describeToString:(NSString *)description;
{
  HCStringDescription* stringDescription = [HCStringDescription stringDescription];
  [[[[stringDescription appendText:@"Expected "]
               appendDescriptionOf:matcher]
                        appendText:@", got "]
                       appendValue:[self actualObject]];
  
  return [description stringByAppendingString:[stringDescription description]];
}

- (id)actualObject
{
  return *pointerToActualObject;
}

@end
