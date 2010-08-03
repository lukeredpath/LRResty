//
//  GetResourceTests.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND
#import "OCHamcrest.h"
#import "AssertEventually.h"
#import "LRResty.h"

#define TEST_HOST @"localhost"
#define TEST_PORT 10090

NSString *resourceWithPath(NSString *path)
{
  return [NSString stringWithFormat:@"http://%@:%d%@", TEST_HOST, TEST_PORT, path];
}

@interface GetResourceTests : SenTestCase <LRRestyClientDelegate>
{
  id lastResponse;
}
@end

@implementation GetResourceTests

- (void)testCanPerformGetRequestToResourceAndReceiveAResponse
{
  [[LRResty client] get:resourceWithPath(@"/simple/resource") delegate:self];
  
  assertEventuallyThat(lastResponse, instanceOf([LRRestyResponse class]));
  assertThatInt([lastResponse status], equalToInt(200));
  assertThat([lastResponse asString], equalTo(@"plain text response"));
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
