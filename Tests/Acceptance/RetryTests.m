//
//  RetryTests.m
//  LRResty
//
//  Created by Luke Redpath on 06/07/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "RestyClientAcceptanceTestCase.h"

RESTY_CLIENT_ACCEPTANCE_TEST(RetryTests)

- (void)testCanRetryFailedRequest
{
  __block LRRestyResponse *receivedResponse = nil;
  __block LRRestyRequest *request = [client get:resourceWithPath(@"/optional/failure") parameters:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"succeed_after"] withBlock:^(LRRestyResponse *response) {

    if (response.status == 200) {
      receivedResponse = [response retain];
    }
    else if (response.status == 500 && request.numberOfRetries < 1) {
      request = [request retry];
    }
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatus(200)));
}

END_ACCEPTANCE_TEST
