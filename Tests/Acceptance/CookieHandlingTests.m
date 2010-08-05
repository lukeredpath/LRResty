//
//  CookiesTest.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRResty.h"

@interface CookieHandlingTests : SenTestCase
{
  LRRestyResponse *lastResponse;
  LRRestyClient *client;
}
@end

@implementation CookieHandlingTests

- (void)setUp
{
  client = [[LRResty client] retain];
}

- (void)testCanExtractCookiesFromResponse
{
  __block LRRestyResponse *receivedResponse = nil;
  
  serviceStubWillServe(anyResponse(), forGetRequestTo(@"/simple/resource"));
  
  [client get:resourceWithPath(@"/simple/resource") withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, hasCookie(@"TestCookie", @"CookieValue"));
}

- (void)testHandlesCookiesAutomaticallyByDefault
{
  __block LRRestyResponse *receivedResponse = nil;
  
  serviceStubWillServe(anyResponse(), forGetRequestTo(@"/simple/requires_cookie"));
  
  [client get:resourceWithPath(@"/simple/requires_cookie") withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  assertEventuallyThat(&receivedResponse, responseWithStatus(200));
}

- (void)testCanDisableAutomaticCookieHandling
{
  __block LRRestyResponse *receivedResponse = nil;
  
  serviceStubWillServe(anyResponse(), forGetRequestTo(@"/simple/resource"));
  serviceStubWillServe(anyResponse(), forGetRequestTo(@"/simple/requires_cookie"));
  
  [client setHandlesCookiesAutomatically:NO];
  
  [client get:resourceWithPath(@"/simple/resource") withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, responseWithStatus(200));
  
  [client get:resourceWithPath(@"/simple/requires_cookie") withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  assertEventuallyThat(&receivedResponse, responseWithStatusAndBody(403, @"Missing cookie"));
}

- (void)tearDown
{
  clearServiceStubs();
}

@end
