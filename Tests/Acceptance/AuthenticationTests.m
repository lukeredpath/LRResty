//
//  AuthenticationTests.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRResty.h"

@interface AuthenticationTests : SenTestCase
{
  LRRestyClient *client;
}
@end

@implementation AuthenticationTests

- (void)setUp
{
  client = [LRResty newClient];
}

- (void)testGetsUnauthorizedResponseWhenRequestingAuthenticatedResourceWithoutCredentials
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client get:resourceWithPathWithPort(@"/requires/auth", 11989) withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatus(401)));
}

- (void)testGetsSuccessfulResponseWhenRequestingAuthenticatedResourceWithCorrectCredentials
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client setUsername:@"testuser" password:@"testpass"];
  [client get:resourceWithPathWithPort(@"/requires/auth", 11989) withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatus(200)));
}

- (void)testGetsUnauthorizedResponseWhenRequestingAuthenticatedResourceWithIncorrectCredentials
{
  __block LRRestyResponse *receivedResponse = nil;
  
  [client setUsername:@"testuser" password:@"wrongpass"];
  [client get:resourceWithPathWithPort(@"/requires/auth", 11989) withBlock:^(LRRestyResponse *response) {
    receivedResponse = [response retain];
  }];
  
  assertEventuallyThat(&receivedResponse, is(responseWithStatus(401)));
}

@end