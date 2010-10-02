//
//  GetResourceTests.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRResty.h"

@interface GetResourceTests : SenTestCase <LRRestyClientResponseDelegate>
{
  LRRestyResponse *lastResponse;
  LRRestyClient *client;
}
@end

@implementation GetResourceTests

- (void)setUp
{
  client = [LRResty newClient];
}

- (void)testCanPerformGetRequestToResourceExtractTheResponseAsAString
{
  serviceStubWillServe(@"plain text response", forGetRequestTo(@"/simple/resource"));

  [client get:resourceWithPath(@"/simple/resource") delegate:self];
  
  assertEventuallyThat(&lastResponse, is(responseWithStatusAndBody(200, @"plain text response")));
}

- (void)testCanExtractHeadersFromResponse
{
  serviceStubWillServe(anyResponse(), forGetRequestTo(@"/simple/resource"));
  
  [client get:resourceWithPath(@"/simple/resource") delegate:self];
  
  assertEventuallyThat(&lastResponse, hasHeader(@"Content-Type", @"text/plain"));
}

- (void)testCanPerformGetRequestWithQueryParameters
{
  serviceStubWillServe(anyResponse(), forGetRequestTo(@"/simple/resource?foo=bar"));
  
  [client get:resourceWithPath(@"/simple/resource") 
   parameters:[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"] 
     delegate:self];
  
  assertEventuallyThat(&lastResponse, is(responseWithStatus(200)));
}

- (void)testCanPerformGetRequestWithCustomHeaders
{
  serviceStubWillServe(anyResponse(), [forGetRequestTo(@"/simple/resource") withHeader:@"X-Test-Header" value:@"Resty"]);
  
  [client get:resourceWithPath(@"/simple/resource") 
   parameters:nil
      headers:[NSDictionary dictionaryWithObject:@"Resty" forKey:@"X-Test-Header"]
     delegate:self];
  
  assertEventuallyThat(&lastResponse, is(responseWithStatus(200)));
}

- (void)testCanModifyRequestsBeforeTheyAreSentUsingBlock
{
  serviceStubWillServe(anyResponse(), [forGetRequestTo(@"/simple/resource") withHeader:@"X-Test-Header" value:@"Resty"]);
  
  [client attachRequestModifier:^(LRRestyRequest *request) {
    [request addHeader:@"X-Test-Header" value:@"Resty"];
  }];  
  [client get:resourceWithPath(@"/simple/resource") delegate:self];
  
  assertEventuallyThat(&lastResponse, is(responseWithStatus(200)));
}

- (void)testCanPerformGetRequestAndPassResponseToABlock
{
  __block LRRestyResponse *testLocalResponse = nil;
  
  serviceStubWillServe(anyResponse(), forGetRequestTo(@"/simple/resource"));
  
  [client get:resourceWithPath(@"/simple/resource") withBlock:^(LRRestyResponse *response) {
    testLocalResponse = [response retain];
  }];
  assertEventuallyThat(&testLocalResponse, is(responseWithStatus(200)));
  
  [testLocalResponse release];
}

#pragma mark -

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response;
{
  lastResponse = [response retain];
}

- (void)tearDown
{
  [lastResponse release]; lastResponse = nil;
  clearServiceStubs();
}

@end
