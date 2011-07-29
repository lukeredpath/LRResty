//
//  GetResourceTests.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "RestyClientAcceptanceTestCase.h"

RESTY_CLIENT_ACCEPTANCE_TEST(GetResourceTests)

- (void)testCanPerformGetRequestToResourceAndExtractTheResponseAsAString
{
  mimicGET(@"/simple/resource", andReturnBody(@"plain text response"), ^{
    [client get:resourceWithPath(@"/simple/resource") delegate:self];
  });
  
  assertEventuallyThat(&lastResponse, is(responseWithStatusAndBody(200, @"plain text response")));
}

- (void)testCanExtractHeadersFromResponse
{
  mimicGET(@"/simple/resource", andReturnResponseHeader(@"Content-Type", @"text/plain"), ^{
    [client get:resourceWithPath(@"/simple/resource") delegate:self];
  });
  
  assertEventuallyThat(&lastResponse, hasHeader(@"Content-Type", @"text/plain"));
}

- (void)testCanPerformGetRequestWithQueryParameters
{
  mimicGET(@"/simple/resource", andEchoRequest(), ^{
    [client get:resourceWithPath(@"/simple/resource") 
     parameters:[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"] 
       delegate:self];
  });
    
  assertEventuallyThat(&lastResponse, is(responseWithRequestEcho(@"params.foo", @"bar")));
}

- (void)testCanPerformGetRequestWithCustomHeaders
{
  mimicGET(@"/simple/resource", andEchoRequest(), ^{  
    [client get:resourceWithPath(@"/simple/resource") 
     parameters:nil
        headers:[NSDictionary dictionaryWithObject:@"Resty" forKey:@"X-Test-Header"]
       delegate:self];
  });
  
  assertEventuallyThat(&lastResponse, is(responseWithRequestEcho(@"env.HTTP_X_TEST_HEADER", @"Resty")));
}

- (void)testCanModifyRequestsBeforeTheyAreSentUsingBlock
{
  mimicGET(@"/simple/resource", andEchoRequest(), ^{  
    [client attachRequestModifier:^(LRRestyRequest *request) {
      [request addHeader:@"X-Test-Header" value:@"Resty"];
    }];  
    [client get:resourceWithPath(@"/simple/resource") delegate:self];
  });
  
  assertEventuallyThat(&lastResponse, is(responseWithRequestEcho(@"env.HTTP_X_TEST_HEADER", @"Resty")));
}

- (void)testCanPerformGetRequestAndPassResponseToABlock
{
  __block LRRestyResponse *testLocalResponse = nil;

  mimicGET(@"/simple/resource", andReturnAnything(), ^{
    [client get:resourceWithPath(@"/simple/resource") withBlock:^(LRRestyResponse *response) {
      testLocalResponse = [response retain];
    }];
  });
  assertEventuallyThat(&testLocalResponse, is(responseWithStatus(200)));
  
  [testLocalResponse release];
}

- (void)testCanPerformSynchronousGetRequest
{
  LRRestyResponse *response = [client get:resourceWithPath(@"/synchronous/echo")];
  assertThat(response, is(responseWithStatus(200)));
}

- (void)testCanPerformSynchronousGetRequestWithParameters
{
  LRRestyResponse *response = [client get:resourceWithPath(@"/synchronous/echo") 
    parameters:[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"]];
  
  assertThat(response, is(responseWithRequestEcho(@"params.foo", @"bar")));
}

- (void)testCanPerformSynchronousGetRequestWithCustomHeaders
{
  LRRestyResponse *response = [client get:resourceWithPath(@"/synchronous/echo") 
       parameters:nil
          headers:[NSDictionary dictionaryWithObject:@"Resty" forKey:@"X-Test-Header"]];
  
  assertThat(response, is(responseWithRequestEcho(@"env.HTTP_X_TEST_HEADER", @"Resty")));
}

END_ACCEPTANCE_TEST
