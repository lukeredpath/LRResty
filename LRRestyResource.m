//
//  LRRestyResource.m
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyResource.h"

@interface LRRestyResource ()
- (void)becomeClientDelegate;
@end

@implementation LRRestyResource

@synthesize delegate;

- (id)initWithRestClient:(LRRestyClient *)theClient URL:(NSURL *)aURL;{
  if (self = [super init]) {
    restClient = [theClient retain];
    restClient.delegate = self;
    URL = [aURL copy];
  }
  return self;
}

- (id)initWithRestClient:(LRRestyClient *)theClient URL:(NSURL *)aURL parent:(LRRestyResource *)parent;
{
  if (self = [self initWithRestClient:theClient URL:aURL]) {
    parentResource = [parent retain];
    delegate = parentResource.delegate;
  }
  return self;
}

- (void)dealloc
{
  [parentResource becomeClientDelegate];
  [parentResource release];
  [URL release];
  [restClient release];
  [super dealloc];
}

- (void)becomeClientDelegate
{
  restClient.delegate = self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ <LRRestyResource>", [URL absoluteString]];
}

- (void)restyClientWillPerformRequest:(LRRestyClient *)client
{
  if ([self.delegate respondsToSelector:@selector(resourceWillPerformRequest:)]) {
    [self.delegate resourceWillPerformRequest:self];
  }
}

- (void)restyClientDidPerformRequest:(LRRestyClient *)client
{
  if ([self.delegate respondsToSelector:@selector(resourceDidPerformRequest:)]) {
    [self.delegate resourceDidPerformRequest:self];
  }  
}

- (LRRestyResource *)at:(NSString *)path;
{
  return [[[LRRestyResource alloc] initWithRestClient:restClient URL:[URL URLByAppendingPathComponent:path] parent:self] autorelease];
}

- (void)get:(LRRestyResponseBlock)responseBlock;
{
  [restClient getURL:URL parameters:nil headers:nil withBlock:responseBlock];
}

@end
