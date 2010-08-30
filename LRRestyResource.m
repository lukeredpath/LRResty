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

- (LRRestyResource *)on:(NSString *)host
{
  return [self on:host secure:NO];
}

- (LRRestyResource *)on:(NSString *)host secure:(BOOL)isSecure;
{
  NSString *scheme = isSecure ? @"https" : @"http";
  NSURL *newURL = [[[NSURL alloc] initWithScheme:scheme host:host path:[URL relativePath]] autorelease];
  return [[[LRRestyResource alloc] initWithRestClient:restClient URL:newURL] autorelease];
}

- (LRRestyResource *)at:(NSString *)path;
{
  return [[[LRRestyResource alloc] initWithRestClient:restClient URL:[URL URLByAppendingPathComponent:path] parent:self] autorelease];
}

- (LRRestyResource *)withoutPathExtension;
{
  return [[[LRRestyResource alloc] initWithRestClient:restClient URL:[URL URLByDeletingPathExtension]] autorelease];
}

- (void)get:(LRRestyResourceResponseBlock)responseBlock;
{
  [restClient getURL:URL parameters:nil headers:nil withBlock:^(LRRestyResponse *response){
    responseBlock(response, self);
  }];
}

- (void)post:(LRRestyResourceResponseBlock)responseBlock;
{
  [restClient postURL:URL payload:nil headers:nil withBlock:^(LRRestyResponse *response){
    responseBlock(response, self);
  }];
}

- (void)post:(id)payload callback:(LRRestyResourceResponseBlock)responseBlock;
{
  [restClient postURL:URL payload:payload headers:nil withBlock:^(LRRestyResponse *response){
    responseBlock(response, self);
  }];
}

// forward other methods to the client

- (id)forwardingTargetForSelector:(SEL)aSelector
{
  if ([restClient respondsToSelector:aSelector]) {
    return restClient;
  }
  return nil;
}

@end

@implementation LRRestyResource (Streaming)

- (void)getStream:(LRRestyStreamingDataBlock)dataHandler onError:(LRRestyStreamingErrorBlock)errorHandler;
{
  [restClient getURL:URL parameters:nil headers:nil onData:dataHandler onError:errorHandler];
}

@end

