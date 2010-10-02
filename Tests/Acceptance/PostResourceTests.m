//
//  PostResourceTests.m
//  LRResty
//
//  Created by Luke Redpath on 04/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRResty.h"

@interface CustomJsonObject : NSObject <LRRestyRequestPayload>
{
  NSString *string;
}
- (id)initWithJSONString:(NSString *)jsonString;
@end

@implementation CustomJsonObject

- (id)initWithJSONString:(NSString *)jsonString;
{
  if (self = [super init]) {
    string = [jsonString copy];
  }
  return self;
}

- (void)modifyRequest:(LRRestyRequest *)request
{
  [request addHeader:@"Accept" value:@"application/json"];
  [request addHeader:@"Content-Type" value:@"application/json"];
  [request setPostData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

@end


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
  
  [client post:resourceWithPath(@"/simple/echo") payload:@"hello world" withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatusAndBody(200, @"you said hello world")));
  
  [client post:resourceWithPath(@"/simple/echo") payload:@"Resty rocks!" withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatusAndBody(200, @"you said Resty rocks!")));
}

- (void)testCanPostRawDataToResourceAndHaveThatValueEchoedBack
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client put:resourceWithPath(@"/simple/echo") payload:[@"hello world" dataUsingEncoding:NSUTF8StringEncoding] withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatusAndBody(200, @"you said hello world")));
}

- (void)testCanPostCustomPayloadObjects
{
  __block LRRestyResponse *receivedResponse = nil;
  id payload = [[[CustomJsonObject alloc] initWithJSONString:@"{'foo':'bar'}"] autorelease];
  
  [client post:resourceWithPath(@"/simple/accepts_only_json") 
       payload:payload
     withBlock:^(LRRestyResponse *response) {
       
       receivedResponse = [response retain];
     }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatus(200)));
}

- (void)testCanPostToResourceWithCustomHeaders
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client post:resourceWithPath(@"/simple/accepts_only_json") 
       payload:anyPayload()
       headers:[NSDictionary dictionaryWithObject:@"application/xml" forKey:@"Accept"] 
     withBlock:^(LRRestyResponse *response) {
       
     receivedResponse = [response retain];
   }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatus(406)));
  
  [client post:resourceWithPath(@"/simple/accepts_only_json") 
       payload:anyPayload() 
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
       payload:[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"]
     withBlock:^(LRRestyResponse *response) {
       
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatusAndBody(200, @"posted params {\"foo\"=>\"bar\"}")));
}

- (void)testCanPostToResourceWithFormEncodedDataWithNestedParameters
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client post:resourceWithPath(@"/simple/form_handler") 
       payload:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"] forKey:@"payload"]
     withBlock:^(LRRestyResponse *response) {
       
     receivedResponse = [response retain];
  }];

  assertEventuallyThat(&receivedResponse, is(responseWithStatusAndBody(200, @"posted params {\"payload\"=>{\"foo\"=>\"bar\"}}")));
}

- (void)testCanPostToResourceWithFormEncodedDataContainingNumbers
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client post:resourceWithPath(@"/simple/form_handler") 
       payload:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:123] forKey:@"number"]
     withBlock:^(LRRestyResponse *response) {
       
       receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatusAndBody(200, @"posted params {\"number\"=>\"123\"}")));
}

- (void)tearDown
{
  [lastResponse release]; lastResponse = nil;
  clearServiceStubs();
}

@end
