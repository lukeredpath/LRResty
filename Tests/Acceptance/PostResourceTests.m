//
//  PostResourceTests.m
//  LRResty
//
//  Created by Luke Redpath on 04/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRResty.h"

NSData *encodedString(NSString *aString)
{
  return [aString dataUsingEncoding:NSUTF8StringEncoding];
}

NSData *anyData()
{
  return encodedString(@"");
}

@interface PostResourceTests : SenTestCase 
{
  LRRestyResponse *lastResponse;
  LRRestyClient *client;
}
@end

@implementation PostResourceTests

- (void)setUp
{
  client = [[LRResty client] retain];
}

- (void)testCanPostStringToResourceAndHaveThatValueEchoedBack
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client post:resourceWithPath(@"/simple/echo") data:encodedString(@"hello world") withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatusAndBody(200, @"you said hello world")));
  
  [client post:resourceWithPath(@"/simple/echo") data:encodedString(@"Resty rocks!") withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatusAndBody(200, @"you said Resty rocks!")));
}

- (void)testCanPostToResourceWithCustomHeaders
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client post:resourceWithPath(@"/simple/accepts_only_json") 
          data:anyData() 
       headers:[NSDictionary dictionaryWithObject:@"application/xml" forKey:@"Accept"] 
     withBlock:^(LRRestyResponse *response) {
       
     receivedResponse = [response retain];
   }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatus(406)));
  
  [client post:resourceWithPath(@"/simple/accepts_only_json") 
          data:anyData() 
       headers:[NSDictionary dictionaryWithObject:@"application/json" forKey:@"Accept"] 
     withBlock:^(LRRestyResponse *response) {
       
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatus(200)));
}

- (void)testCanPostToResourceWithFormEncodedData
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client post:resourceWithPath(@"/simple/form_handler") 
    parameters:[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"]
     withBlock:^(LRRestyResponse *response) {
       
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatusAndBody(200, @"posted params {\"foo\"=>\"bar\"}")));
}

- (void)testCanPostToResourceWithFormEncodedDataWithNestedParameters
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client post:resourceWithPath(@"/simple/form_handler") 
    parameters:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"] forKey:@"payload"]
     withBlock:^(LRRestyResponse *response) {
       
       receivedResponse = [response retain];
     }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatusAndBody(200, @"posted params {\"payload\"=>{\"foo\"=>\"bar\"}}")));
}

@end
