//
//  TimeoutTests.m
//  LRResty
//
//  Created by Luke Redpath on 25/06/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "RestyClientAcceptanceTestCase.h"

RESTY_CLIENT_ACCEPTANCE_TEST(TimeoutTests)

- (void)testCanPerformRequestAndHandleTimeoutAfterGivenTime
{
  __block LRRestyRequest *timedOutRequest = nil;
  
  [[client post:resourceWithPath(@"/long/request") 
       payload:[NSDictionary dictionaryWithObject:@"5" forKey:@"sleep"]
     withBlock:nil] timeoutAfter:1 handleWithBlock:^(LRRestyRequest *request) {
      
      timedOutRequest = request;
  }];
  
  assertEventuallyThat(&timedOutRequest, is(notNilValue()));
}

- (void)testCancelsRequestWhenTimesOut
{
  __block LRRestyRequest *timedOutRequest = nil;
  
  [[client post:resourceWithPath(@"/long/request") 
        payload:[NSDictionary dictionaryWithObject:@"5" forKey:@"sleep"]
      withBlock:nil] timeoutAfter:1 handleWithBlock:^(LRRestyRequest *request) {
    
    timedOutRequest = request;
  }];
  
  assertEventuallyThat(&timedOutRequest, isCancelled());
}

- (void)testTimeoutBlockIsNeverCalledWhenRequestRespondsInTime
{
  __block BOOL timeoutHandlerCalled = NO;
  
  [[client get:@"/simple/resource" withBlock:nil] timeoutAfter:1 handleWithBlock:^(LRRestyRequest *request) {
    timeoutHandlerCalled = YES;
  }];
  
  waitForInterval(1.5);
  assertThatBool(timeoutHandlerCalled, equalToBool(NO));
}

END_ACCEPTANCE_TEST
