//
//  CookiesTest.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRResty.h"

#define TEST_COOKIE_VALUE @"CookieValue"

@interface CookieHandlingTests : SenTestCase
{
  LRRestyResponse *lastResponse;
  LRRestyClient *client;
}
@end

@implementation CookieHandlingTests

- (void)setUp
{
  client = [LRResty newClient];
}

- (void)tearDown
{
  for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
  }
}

- (void)testCanExtractCookiesFromResponse
{
  __block LRRestyResponse *receivedResponse = nil;

  [client get:resourceWithPathWithPort(@"/sets/cookie", 11988) withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, hasCookie(@"TestCookie", TEST_COOKIE_VALUE));
}

- (void)testHandlesCookiesAutomaticallyByDefault
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client get:resourceWithPathWithPort(@"/sets/cookie", 11989) withBlock:^(LRRestyResponse *response) {
    [client get:resourceWithPathWithPort(@"/requires/cookie", 11989) withBlock:^(LRRestyResponse *response) {
      receivedResponse = [response retain];
    }];
  }];
  
  assertEventuallyThat(&receivedResponse, responseWithStatusAndBody(200, [NSString stringWithFormat:@"Got cookie %@", TEST_COOKIE_VALUE]));
}

- (void)testCanDisableAutomaticCookieHandling
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client setHandlesCookiesAutomatically:NO];
  
  [client get:resourceWithPathWithPort(@"/sets/cookie", 11989) withBlock:^(LRRestyResponse *response) {
    [client get:resourceWithPathWithPort(@"/requires/cookie", 11989) withBlock:^(LRRestyResponse *response) {
      receivedResponse = [response retain];
    }];
  }];
  
  assertEventuallyThat(&receivedResponse, responseWithStatusAndBody(403, @"Missing cookie"));
}

@end
