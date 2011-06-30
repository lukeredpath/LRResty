//
//  LRRestyResource.m
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyResource.h"
#import "LRRestyClient+GET.h"
#import "LRRestyClient+POST.h"
#import "LRRestyClient+PUT.h"

@interface LRRestyResource ()
- (void)becomeClientDelegate;
@end

@implementation LRRestyResource

@synthesize delegate, URL;

- (id)initWithRestClient:(LRRestyClient *)theClient URL:(NSURL *)aURL
{
  if ((self = [super init])) {
    restClient = theClient;
    restClient.delegate = self;
    URL = [aURL copy];
  }
  return self;
}

- (id)initWithRestClient:(LRRestyClient *)theClient URL:(NSURL *)aURL parent:(LRRestyResource *)parent;
{
  if ((self = [self initWithRestClient:theClient URL:aURL])) {
    parentResource = parent;
    delegate = parentResource.delegate;
  }
  return self;
}

- (void)dealloc
{
  if (parentResource == nil) {
    restClient.delegate = nil;
  } else {
    [parentResource becomeClientDelegate];
  }
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

- (LRRestyResource *)root;
{
  NSURL *rootURL = [[NSURL alloc] initWithScheme:[URL scheme] host:[URL host] path:@"/"];
  return [[LRRestyResource alloc] initWithRestClient:restClient URL:rootURL];
}

- (LRRestyResource *)on:(NSString *)host
{
  return [self on:host secure:NO];
}

- (LRRestyResource *)on:(NSString *)host secure:(BOOL)isSecure;
{
  NSString *scheme = isSecure ? @"https" : @"http";
  NSURL *newURL = [[NSURL alloc] initWithScheme:scheme host:host path:[URL relativePath]];
  return [[LRRestyResource alloc] initWithRestClient:restClient URL:newURL];
}

- (LRRestyResource *)at:(NSString *)path;
{
  return [[LRRestyResource alloc] initWithRestClient:restClient URL:[URL URLByAppendingPathComponent:path] parent:self];
}

- (LRRestyResource *)withoutPathExtension;
{
  return [[LRRestyResource alloc] initWithRestClient:restClient URL:[URL URLByDeletingPathExtension]];
}

- (LRRestyRequest *)get:(LRRestyResourceResponseBlock)responseBlock;
{
  return [restClient get:[URL absoluteString] parameters:nil headers:nil withBlock:^(LRRestyResponse *response){
    responseBlock(response, self);
  }];
}

- (void)post:(LRRestyResourceResponseBlock)responseBlock;
{
  [restClient post:[URL absoluteString] payload:nil headers:nil withBlock:^(LRRestyResponse *response){
    responseBlock(response, self);
  }];
}

- (void)post:(id)payload callback:(LRRestyResourceResponseBlock)responseBlock;
{
  [restClient put:[URL absoluteString] payload:payload headers:nil withBlock:^(LRRestyResponse *response){
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

- (LRRestyRequest *)getStream:(LRRestyStreamingDataBlock)dataHandler onError:(LRRestyStreamingErrorBlock)errorHandler;
{
  return [restClient get:[URL absoluteString] onData:dataHandler onError:errorHandler];
}

@end

