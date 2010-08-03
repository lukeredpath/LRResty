//
//  GetResourceTests.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRResty.h"

NSString *anyResponse()
{
  return @"";
}

NSString *resourceWithPath(NSString *path)
{
  return [NSString stringWithFormat:@"http://%@:%d%@", TEST_HOST, TEST_PORT, path];
}

@interface GetResourceTests : SenTestCase <LRRestyClientDelegate>
{
  id lastResponse;
  LRRestyClient *client;
}
@end

@implementation GetResourceTests

- (void)setUp
{
  client = [[LRResty client] retain];
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

#pragma mark -

- (void)restClient:(LRRestyClient *)client receivedResponse:(id)response;
{
  lastResponse = [response retain];
}

- (void)tearDown
{
  [lastResponse release]; lastResponse = nil;
}

@end
