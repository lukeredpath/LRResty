//
//  AuthenticationTests.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "RestyClientAcceptanceTestCase.h"

RESTY_CLIENT_ACCEPTANCE_TEST(AuthenticationTests)

- (void)testGetsUnauthorizedResponseWhenRequestingAuthenticatedResourceWithoutCredentials
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client get:resourceWithPath(@"/requires/auth") withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatus(401)));
}

- (void)testGetsSuccessfulResponseWhenRequestingAuthenticatedResourceWithCorrectCredentials
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client setUsername:@"testuser" password:@"testpass"];
  [client get:resourceWithPath(@"/requires/auth") withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatus(200)));
}

- (void)testGetsUnauthorizedResponseWhenRequestingAuthenticatedResourceWithIncorrectCredentials
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client setUsername:@"testuser" password:@"wrongpass"];
  [client get:resourceWithPath(@"/requires/auth") withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatus(401)));
}

END_ACCEPTANCE_TEST
