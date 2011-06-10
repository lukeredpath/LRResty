//
//  DeleteResourceTests.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRResty.h"

@interface DeleteResourceTests : SenTestCase <LRRestyClientResponseDelegate>
{
  LRRestyResponse *lastResponse;
  LRRestyClient *client;
}
@end

@implementation DeleteResourceTests

- (void)setUp
{
  client = [LRResty newClient];
}

- (void)testCanPerformDeleteRequestToResourceAndExtractTheResponseAsAString
{
  mimicDELETE(@"/simple/resource", andReturnBody(@"plain text response"), ^{
    [client delete:resourceWithPath(@"/simple/resource") delegate:self];
  });
  
  assertEventuallyThat(&lastResponse, is(responseWithStatusAndBody(200, @"plain text response")));
}

- (void)testCanExtractHeadersFromResponse
{
  mimicDELETE(@"/simple/resource", andReturnResponseHeader(@"Content-Type", @"text/plain"), ^{
    [client delete:resourceWithPath(@"/simple/resource") delegate:self];
  });
  
  assertEventuallyThat(&lastResponse, hasHeader(@"Content-Type", @"text/plain"));
}

- (void)testCanPerformDeleteRequestWithCustomHeaders
{
  mimicDELETE(@"/simple/resource", andEchoRequest(), ^{  
    [client delete:resourceWithPath(@"/simple/resource") 
        headers:[NSDictionary dictionaryWithObject:@"Resty" forKey:@"X-Test-Header"]
       delegate:self];
  });
  
  assertEventuallyThat(&lastResponse, is(responseWithRequestEcho(@"env.HTTP_X_TEST_HEADER", @"Resty")));
}

- (void)testCanModifyRequestsBeforeTheyAreSentUsingBlock
{
  mimicDELETE(@"/simple/resource", andEchoRequest(), ^{  
    [client attachRequestModifier:^(LRRestyRequest *request) {
      [request addHeader:@"X-Test-Header" value:@"Resty"];
    }];  
    [client delete:resourceWithPath(@"/simple/resource") delegate:self];
  });
  
  assertEventuallyThat(&lastResponse, is(responseWithRequestEcho(@"env.HTTP_X_TEST_HEADER", @"Resty")));
}

- (void)testCanPerformDeleteRequestAndPassResponseToABlock
{
  __block LRRestyResponse *testLocalResponse = nil;
  
  mimicDELETE(@"/simple/resource", andReturnAnything(), ^{
    [client delete:resourceWithPath(@"/simple/resource") withBlock:^(LRRestyResponse *response) {
      testLocalResponse = [response retain];
    }];
  });
  assertEventuallyThat(&testLocalResponse, is(responseWithStatus(200)));
  
  [testLocalResponse release];
}

- (void)testCanPerformSynchronousDeleteRequest
{
  LRRestyResponse *response = [client delete:resourceWithPath(@"/synchronous/echo")];
  assertThat(response, is(responseWithStatus(200)));
}

#pragma mark -

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response;
{
  lastResponse = [response retain];
}

- (void)tearDown
{
  [lastResponse release]; lastResponse = nil;
}

@end
