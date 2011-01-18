//
//  PostResourceTests.m
//  LRResty
//
//  Created by Luke Redpath on 04/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRResty.h"
#import "CustomJsonObject.h"

@interface PostResourceTests : SenTestCase 
{
  LRRestyResponse *lastResponse;
  LRRestyClient *client;
}
@end

@implementation PostResourceTests

- (void)setUp
{
  client = [LRResty newClient];
}

- (void)testCanPostStringToResourceAndHaveThatValueEchoedBack
{
  __block LRRestyResponse *receivedResponse = nil;
  
  mimicPOST(@"/echo/test", andEchoRequest(), ^{  
    [client post:resourceWithPath(@"/echo/test") payload:@"hello world" withBlock:^(LRRestyResponse *response) {
      receivedResponse = [response retain];
    }];
  });
  
  assertEventuallyThat(&receivedResponse, is(responseWithRequestEcho(@"body", @"hello world")));
  
  mimicPOST(@"/echo/test", andEchoRequest(), ^{  
    [client post:resourceWithPath(@"/echo/test") payload:@"Resty rocks!" withBlock:^(LRRestyResponse *response) {
      receivedResponse = [response retain];
    }];
  });
  
  assertEventuallyThat(&receivedResponse, is(responseWithRequestEcho(@"body", @"Resty rocks!")));
}

- (void)testCanPostRawDataToResourceAndHaveThatValueEchoedBack
{
  __block LRRestyResponse *receivedResponse = nil;
  
  mimicPOST(@"/echo/test", andEchoRequest(), ^{  
    [client post:resourceWithPath(@"/echo/test") payload:encodedString(@"hello world") withBlock:^(LRRestyResponse *response) {
      receivedResponse = [response retain];
    }];
  });
  
  assertEventuallyThat(&receivedResponse, is(responseWithRequestEcho(@"body", @"hello world")));
}

- (void)testCanPostCustomPayloadObjects
{
  __block LRRestyResponse *receivedResponse = nil;

  id payload = [[[CustomJsonObject alloc] initWithJSONString:@"{'foo':'bar'}"] autorelease];
  
  mimicPOST(@"/echo/json", andEchoRequest(), ^{  
    [client post:resourceWithPath(@"/echo/json") 
         payload:payload
       withBlock:^(LRRestyResponse *response) {
         
         receivedResponse = [response retain];
       }];
  });
  
  assertEventuallyThat(&receivedResponse, is(responseWithRequestEcho(@"body", @"{'foo':'bar'}")));
  assertEventuallyThat(&receivedResponse, is(responseWithRequestEcho(@"env.HTTP_ACCEPT", @"application/json")));
  assertEventuallyThat(&receivedResponse, is(responseWithRequestEcho(@"env.CONTENT_TYPE", @"application/json")));
}

- (void)testCanPostToResourceWithCustomHeaders
{
  __block LRRestyResponse *receivedResponse = nil;
  
  mimicPOST(@"/simple/resource", andEchoRequest(), ^{  
    [client post:resourceWithPath(@"/simple/resource") 
         payload:@""
         headers:[NSDictionary dictionaryWithObject:@"Resty" forKey:@"X-Test-Header"]
       withBlock:^(LRRestyResponse *response) {
         
         receivedResponse = [response retain];
       }];
  });
  
  assertEventuallyThat(&receivedResponse, is(responseWithRequestEcho(@"env.HTTP_X_TEST_HEADER", @"Resty")));  
}

- (void)testCanPostToResourceWithFormEncodedData
{
  __block LRRestyResponse *receivedResponse = nil;
  
  mimicPOST(@"/simple/resource", andEchoRequest(), ^{  
    [client post:resourceWithPath(@"/simple/resource") 
         payload:[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"]
       withBlock:^(LRRestyResponse *response) {
         
         receivedResponse = [response retain];
       }];
  });
  
  assertEventuallyThat(&receivedResponse, is(responseWithRequestEcho(@"params.foo", @"bar")));
}

- (void)testCanPostToResourceWithFormEncodedDataWithNestedParameters
{
  __block LRRestyResponse *receivedResponse = nil;
  
  mimicPOST(@"/simple/resource", andEchoRequest(), ^{  
    [client post:resourceWithPath(@"/simple/resource") 
         payload:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"] forKey:@"payload"]
       withBlock:^(LRRestyResponse *response) {
         
         receivedResponse = [response retain];
       }];
  });
  
  assertEventuallyThat(&receivedResponse, is(responseWithRequestEcho(@"params.payload.foo", @"bar")));
}

- (void)testCanPostToResourceWithFormEncodedDataContainingNumbers
{
  __block LRRestyResponse *receivedResponse = nil;
  
  mimicPOST(@"/simple/resource", andEchoRequest(), ^{  
    [client post:resourceWithPath(@"/simple/resource") 
         payload:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:123] forKey:@"number"]
       withBlock:^(LRRestyResponse *response) {
         
         receivedResponse = [response retain];
       }];
  });
  
  assertEventuallyThat(&receivedResponse, is(responseWithRequestEcho(@"params.number", @"123")));
}

- (void)tearDown
{
  [lastResponse release]; lastResponse = nil;
}

@end
