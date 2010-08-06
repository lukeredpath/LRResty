//
//  LRRestyResource.m
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyResource.h"


@implementation LRRestyResource

- (id)initWithRestClient:(LRRestyClient *)theClient URL:(NSURL *)aURL;{
  if (self = [super init]) {
    restClient = [theClient retain];
    URL = [aURL copy];
  }
  return self;
}

- (void)dealloc
{
  [URL release];
  [restClient release];
  [super dealloc];
}

- (void)setClientDelegate:(id<LRRestyClientDelegate>)clientDelegate;
{
  restClient.delegate = clientDelegate;
}

- (LRRestyResource *)at:(NSString *)path;
{
  return [[[LRRestyResource alloc] initWithRestClient:restClient URL:[URL URLByAppendingPathComponent:path]] autorelease];
}

- (void)get:(LRRestyResponseBlock)responseBlock;
{
  [restClient getURL:URL parameters:nil headers:nil withBlock:responseBlock];
}

@end
