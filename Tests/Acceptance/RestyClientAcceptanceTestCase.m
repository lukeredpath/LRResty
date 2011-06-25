//
//  RestyClientAcceptanceTestCase.m
//  LRResty
//
//  Created by Luke Redpath on 25/06/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "RestyClientAcceptanceTestCase.h"

@implementation RestyClientAcceptanceTestCase

@synthesize client;
@synthesize lastResponse;

- (void)setUp
{
  client = [LRResty newClient];
}

- (void)tearDown
{
  self.lastResponse = nil;
}

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response;
{
  self.lastResponse = response;
}

@end
