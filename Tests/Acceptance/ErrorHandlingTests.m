//
//  ErrorHandlingTests.m
//  LRResty
//
//  Created by Luke Redpath on 22/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRResty.h"

@interface ErrorHandlingTests : SenTestCase <LRRestyClientResponseDelegate>
{
  LRRestyClient *client;
  NSError *delegateError;
}
@end

@implementation ErrorHandlingTests

- (void)setUp
{
  client = [[LRResty client] retain];
}

- (void)testShouldYieldConnectionErrorsToClientErrorHandlingBlock
{
  __block NSError *clientError = nil;
  
  [client setErrorHandlerBlock:^(NSError *error) {
    clientError = [error retain];
  }];
  
  [client get:@"http://thiswontwork/doesnt/exist" withBlock:nil];
  
  assertEventuallyThat(&clientError, is(instanceOf([NSError class])));
}

- (void)testShouldNotifyDelegatesOfConnectionErrors
{
  delegateError = nil;
  
  [client get:@"http://thiswontwork/doesnt/exist" delegate:self];
  
  assertEventuallyThat(&delegateError, is(instanceOf([NSError class])));
}

#pragma mark -

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response {}

- (void)restClient:(LRRestyClient *)client failedWithError:(NSError *)error;
{
  delegateError = [error retain];
}

@end
