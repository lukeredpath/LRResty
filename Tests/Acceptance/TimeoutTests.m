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
     withBlock:nil] timeoutAfter:3 handleWithBlock:^(LRRestyRequest *request) {
      
      timedOutRequest = request;
  }];
  
  assertEventuallyThat(&lastResponse, is(responseWithStatusAndBody(200, @"plain text response")));
}

END_ACCEPTANCE_TEST
