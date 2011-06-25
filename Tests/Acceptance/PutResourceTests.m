//
//  PutResourceTests.m
//  LRResty
//
//  Created by Luke Redpath on 04/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "RestyClientAcceptanceTestCase.h"
#import "CustomJsonObject.h"

RESTY_CLIENT_ACCEPTANCE_TEST(PutResourceTests)

- (void)testCanPostStringToResourceAndHaveThatValueEchoedBack
{
  __block LRRestyResponse *receivedResponse = nil;
  
  mimicPUT(@"/echo/test", andEchoRequest(), ^{  
    [client put:resourceWithPath(@"/echo/test") payload:@"hello world" withBlock:^(LRRestyResponse *response) {
      receivedResponse = [response retain];
    }];
  });
  
  assertEventuallyThat(&receivedResponse, is(responseWithRequestEcho(@"body", @"hello world")));
  
  mimicPUT(@"/echo/test", andEchoRequest(), ^{  
    [client put:resourceWithPath(@"/echo/test") payload:@"Resty rocks!" withBlock:^(LRRestyResponse *response) {
      receivedResponse = [response retain];
    }];
  });
  
  assertEventuallyThat(&receivedResponse, is(responseWithRequestEcho(@"body", @"Resty rocks!")));
}

- (void)testCanPostRawDataToResourceAndHaveThatValueEchoedBack
{
  __block LRRestyResponse *receivedResponse = nil;
  
  mimicPUT(@"/echo/test", andEchoRequest(), ^{  
    [client put:resourceWithPath(@"/echo/test") payload:encodedString(@"hello world") withBlock:^(LRRestyResponse *response) {
      receivedResponse = [response retain];
    }];
  });
  
  assertEventuallyThat(&receivedResponse, is(responseWithRequestEcho(@"body", @"hello world")));
}

- (void)testCanPostCustomPayloadObjects
{
  __block LRRestyResponse *receivedResponse = nil;
  
  id payload = [[[CustomJsonObject alloc] initWithJSONString:@"{'foo':'bar'}"] autorelease];
  
  mimicPUT(@"/echo/json", andEchoRequest(), ^{  
    [client put:resourceWithPath(@"/echo/json") 
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
  
  mimicPUT(@"/simple/resource", andEchoRequest(), ^{  
    [client put:resourceWithPath(@"/simple/resource") 
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
  
  mimicPUT(@"/simple/resource", andEchoRequest(), ^{  
    [client put:resourceWithPath(@"/simple/resource") 
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
  
  mimicPUT(@"/simple/resource", andEchoRequest(), ^{  
    [client put:resourceWithPath(@"/simple/resource") 
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
  
  mimicPUT(@"/simple/resource", andEchoRequest(), ^{  
    [client put:resourceWithPath(@"/simple/resource") 
         payload:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:123] forKey:@"number"]
       withBlock:^(LRRestyResponse *response) {
         
         receivedResponse = [response retain];
       }];
  });
  
  assertEventuallyThat(&receivedResponse, is(responseWithRequestEcho(@"params.number", @"123")));
}

- (void)testCanPerformSynchronousPutRequest
{
  LRRestyResponse *response = [client put:resourceWithPath(@"/synchronous/echo") payload:@"hello world"];
  
  assertThat(response, is(responseWithRequestEcho(@"body", @"hello world")));
}

- (void)testCanPerformSynchronousPutRequestWithCustomHeaders
{
  LRRestyResponse *response = [client put:resourceWithPath(@"/synchronous/echo") payload:@"hello world"
     headers:[NSDictionary dictionaryWithObject:@"Resty" forKey:@"X-Test-Header"]];
  
  assertThat(response, is(responseWithRequestEcho(@"env.HTTP_X_TEST_HEADER", @"Resty")));
}

- (void)tearDown
{
  [lastResponse release]; lastResponse = nil;
}

END_ACCEPTANCE_TEST
