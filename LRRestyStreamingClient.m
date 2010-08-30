//
//  LRRestyStreamingClient.m
//  LRResty
//
//  Created by Luke Redpath on 30/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyStreamingClient.h"
#import "LRResty.h"

@implementation LRRestyStreamingClient

- (id)initWithClient:(LRRestyClient *)theClient;
{
  if (self = [super init]) {
    client = [theClient retain];
    requestHandlers = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [requestHandlers release];
  [client release];
  [super dealloc];
}

- (void)get:(NSString *)path receive:(LRRestyStreamHandler)block;
{
  LRRestyStreamingRequestHandler *handler = [[LRRestyStreamingRequestHandler alloc] initWithStreamingClient:self handler:block];
  [requestHandlers addObject:handler];
  [client get:path delegate:handler];
  [handler release];
}

- (void)requestFinished:(LRRestyStreamingRequestHandler *)handler;
{
  [requestHandlers removeObject:handler];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
  if ([client respondsToSelector:aSelector]) {
    return client;
  }
  return nil;
}

@end

@implementation LRRestyStreamingRequestHandler

- (id)initWithStreamingClient:(LRRestyStreamingClient *)streamingClient handler:(LRRestyStreamHandler)block;
{
  if (self = [super init]) {
    client = streamingClient;
    handler = Block_copy(block);
    shouldCancel = NO;
  }
  return self;
}

- (void)dealloc
{
  Block_release(handler);
  [super dealloc];
}

- (void)restClient:(LRRestyClient *)_client receivedResponse:(LRRestyResponse *)response;
{
  handler(response, nil, &shouldCancel);
  [client requestFinished:self];
}

- (void)restClient:(LRRestyClient *)_client request:(LRRestyRequest *)request receivedData:(NSData *)data;
{
  handler(nil, data, &shouldCancel);

  if (shouldCancel) {
    [request cancel];
    [client requestFinished:self];
  }
}

@end
