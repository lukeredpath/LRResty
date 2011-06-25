//
//  CookiesTest.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "RestyClientAcceptanceTestCase.h"

#define TEST_COOKIE_VALUE @"CookieValue"

RESTY_CLIENT_ACCEPTANCE_TEST(CookieHandlingTests)

- (void)tearDown
{
  [super tearDown];
  
  for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
  }
}

- (void)testCanExtractCookiesFromResponse
{
  __block LRRestyResponse *receivedResponse = nil;

  [client get:resourceWithPath(@"/sets/cookie") withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, hasCookie(@"TestCookie", TEST_COOKIE_VALUE));
}

- (void)testHandlesCookiesAutomaticallyByDefault
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client get:resourceWithPath(@"/sets/cookie") withBlock:^(LRRestyResponse *response) {
    [client get:resourceWithPath(@"/requires/cookie") withBlock:^(LRRestyResponse *response) {
      receivedResponse = [response retain];
    }];
  }];
  
  assertEventuallyThat(&receivedResponse, responseWithStatusAndBody(200, [NSString stringWithFormat:@"Got cookie %@", TEST_COOKIE_VALUE]));
}

- (void)testCanDisableAutomaticCookieHandling
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client setHandlesCookiesAutomatically:NO];
  
  [client get:resourceWithPath(@"/sets/cookie") withBlock:^(LRRestyResponse *response) {
    [client get:resourceWithPath(@"/requires/cookie") withBlock:^(LRRestyResponse *response) {
      receivedResponse = [response retain];
    }];
  }];
  
  assertEventuallyThat(&receivedResponse, responseWithStatusAndBody(403, @"Missing cookie"));
}

END_ACCEPTANCE_TEST
