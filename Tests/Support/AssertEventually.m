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

@interface NSCondition (BlockAdditions)
- (void)withLock:(void (^)(void))block;
@end

@implementation NSCondition (BlockAdditions)

- (void)withLock:(void (^)(void))block
{
  [self lock];
  block();
  [self unlock];
}

@end

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

//NSCondition *condition = [[NSCondition alloc] init];
//
//block(&result, condition);
//
//[condition lock];
//
//if (timeout > 0) {
//  [condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:timeout]];
//}
//else {
//  [condition wait];
//}
//
//[condition unlock];
//[condition release];

#pragma mark -
#pragma mark Core

@interface LRProbePoller()
@property (nonatomic, retain) id<LRProbe> currentProbe;
@end

@implementation LRProbePoller

@synthesize currentProbe;

- (id)initWithTimeout:(NSTimeInterval)theTimeout delay:(NSTimeInterval)theDelay;
{
  if ((self = [super init])) {
    timeoutInterval = theTimeout;
    delayInterval = theDelay;
    condition = [[NSCondition alloc] init];
  }
  return self;
}

- (void)dealloc 
{
  [condition release];
  [currentProbe release];
  [super dealloc];
}

- (BOOL)check:(id<LRProbe>)probe;
{
  self.currentProbe = probe;

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    while(![self.currentProbe isSatisfied]) {
      @try {
        [self.currentProbe sampleWithCondition:condition];
        sleep(delayInterval);
      }
      @catch (NSException *exception) {
        NSLog(@"Caught exception whilst sampling probe: %@", exception);
      }
    }
  });
  
  [condition withLock:^{
    [condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:timeoutInterval]];
  }];
    
  self.currentProbe = nil;
  
  return YES;
}

@end

void LR_assertEventuallyWithLocationAndTimeout(SenTestCase *testCase, const char* fileName, int lineNumber, id<LRProbe>probe, NSTimeInterval timeout)
{
  dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    LRProbePoller *poller = [[LRProbePoller alloc] initWithTimeout:timeout delay:kDEFAULT_PROBE_DELAY];
    if (![poller check:probe]) {
      NSString *failureMessage = [probe describeToString:[NSString stringWithFormat:@"Probe failed after %d second(s). ", (int)timeout]];
      
      [testCase failWithException:
       [NSException failureInFile:[NSString stringWithUTF8String:fileName] 
                           atLine:lineNumber 
                  withDescription:failureMessage]];
    }
    [poller release];
  });
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
    block = [aBlock copy];
    isSatisfied = NO;
    
    NSAssert(block, @"Block probe requires a block!");
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

- (void)sampleWithCondition:(NSCondition *)condition
{
  isSatisfied = block();
  
  if (isSatisfied) {
    [condition withLock:^{ [condition signal]; }];
  }
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

- (void)sampleWithCondition:(NSCondition *)condition
{
  didMatch = [matcher matches:[self actualObject]];
  
  if (didMatch) {
    [condition withLock:^{ [condition signal]; }];
  }
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
