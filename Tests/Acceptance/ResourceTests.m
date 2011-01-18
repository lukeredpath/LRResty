//
//  ResourceTests.m
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRResty.h"

@interface ResourceTests : SenTestCase 
{
  LRRestyResponse *lastResponse;
  LRRestyResource *resource;
}
@end

@implementation ResourceTests

- (void)setUp
{
  resource = [[LRResty resource:resourceRoot()] retain];
}

- (void)testCanPerformGetRequests
{
  __block LRRestyResponse *receivedResponse = nil;
  
  mimicGET(@"/simple/resource", andReturnBody(@"plain text response"), ^{
    [[resource at:@"simple/resource"] get:^(LRRestyResponse *response, LRRestyResource *resource) {
      receivedResponse = [response retain];
    }];
  });
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatusAndBody(200, @"plain text response")));
}

@end
