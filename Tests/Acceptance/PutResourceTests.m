//
//  PutResourceTests.m
//  LRResty
//
//  Created by Luke Redpath on 04/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRResty.h"

@interface PutResourceTests : SenTestCase 
{
  LRRestyResponse *lastResponse;
  LRRestyClient *client;
}
@end

@implementation PutResourceTests

- (void)setUp
{
  client = [[LRResty client] retain];
}

- (void)testCanPutStringToResourceAndHaveThatValueEchoedBack
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client put:resourceWithPath(@"/simple/echo") data:encodedString(@"hello world") withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatusAndBody(200, @"you said hello world")));
  
  [client put:resourceWithPath(@"/simple/echo") data:encodedString(@"Resty rocks!") withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatusAndBody(200, @"you said Resty rocks!")));
}

- (void)testCanPutToResourceWithCustomHeaders
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client put:resourceWithPath(@"/simple/accepts_only_json") 
          data:anyData() 
       headers:[NSDictionary dictionaryWithObject:@"application/xml" forKey:@"Accept"] 
     withBlock:^(LRRestyResponse *response) {
       
       receivedResponse = [response retain];
     }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatus(406)));
  
  [client put:resourceWithPath(@"/simple/accepts_only_json") 
          data:anyData() 
       headers:[NSDictionary dictionaryWithObject:@"application/json" forKey:@"Accept"] 
     withBlock:^(LRRestyResponse *response) {
       
       receivedResponse = [response retain];
     }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatus(200)));
}

- (void)testCanPutToResourceWithFormEncodedData
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client put:resourceWithPath(@"/simple/form_handler") 
    parameters:[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"]
     withBlock:^(LRRestyResponse *response) {
       
       receivedResponse = [response retain];
     }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatusAndBody(200, @"PUT params {\"foo\"=>\"bar\"}")));
}

- (void)testCanPutToResourceWithFormEncodedDataWithNestedParameters
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client put:resourceWithPath(@"/simple/form_handler") 
    parameters:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"] forKey:@"payload"]
     withBlock:^(LRRestyResponse *response) {
       
       receivedResponse = [response retain];
     }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatusAndBody(200, @"PUT params {\"payload\"=>{\"foo\"=>\"bar\"}}")));
}

@end
