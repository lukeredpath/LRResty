//
//  LRRestyRequest.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyRequest.h"
#import "LRRestyResponse.h"
#import "LRRestyClient.h"
#import "NSDictionary+QueryString.h"

@implementation LRRestyRequest

@synthesize connectionError;
@synthesize responseData;
@synthesize response;

- (id)initWithURL:(NSURL *)aURL method:(NSString *)httpMethod client:(LRRestyClient *)theClient delegate:(id<LRRestyClientDelegate>)theDelegate;
{
  if (self = [super init]) {
    requestURL = [aURL retain];
    requestMethod = [httpMethod copy];
    delegate = [theDelegate retain];
    client = theClient;
  }
  return self;
}

- (void)dealloc
{
  [postData release];
  [requestHeaders release];
  [requestURL release];
  [requestMethod release];
  [delegate release];
  [super dealloc];
}

- (void)setQueryParameters:(NSDictionary *)parameters;
{
  if (parameters == nil) return;
  
  NSURL *URLWithParameters = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [requestURL absoluteString], [parameters stringWithFormEncodedComponents]]];
  [requestURL release];
  requestURL = [URLWithParameters retain];
}

- (void)setHeaders:(NSDictionary *)headers
{
  if (headers == nil) return;
  
  [requestHeaders release];
  requestHeaders = [headers copy];
}

- (void)setPostData:(NSData *)data;
{
  postData = [data retain];
}

- (void)setPayload:(id<LRRestyRequestPayload>)payload;
{
  [payload modifyRequest:self];
}

- (BOOL)isConcurrent
{
  return YES;
}

- (BOOL)isExecuting
{
  return _isExecuting;
}

- (BOOL)isFinished
{
  return _isFinished;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ %@ <LRRestyRequest>", requestMethod, requestURL];
}

- (void)start
{
  if (![NSThread isMainThread]) {
    return [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:YES];
  }
  [self setExecuting:YES];
  
  NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:requestURL];
  [requestHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
    [URLRequest addValue:value forHTTPHeaderField:key];
  }];
  
  [URLRequest setHTTPBody:postData];
  [URLRequest setHTTPMethod:requestMethod];
  
  NSURLConnection *connection = [NSURLConnection 
                                 connectionWithRequest:URLRequest
                                 delegate:self];
  
  if (connection == nil) {
    [self setFinished:YES]; 
  }
}

#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)theResponse
{
  if (responseData == nil) {
    responseData = [[NSMutableData alloc] init];
  }
  self.response = (NSHTTPURLResponse *)theResponse;
  
  if ([self isCancelled]) {
    [connection cancel];
    [self finish];
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [responseData appendData:data]; 
  
  if ([self isCancelled]) {
    [connection cancel];
    [self finish];
  }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  [self finish];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  self.connectionError = error;
  
  [self setFinished:YES];
}

- (void)finish;
{
  LRRestyResponse *restResponse = [[LRRestyResponse alloc] 
                                   initWithStatus:self.response.statusCode 
                                   responseData:self.responseData 
                                   headers:[self.response allHeaderFields]];
  
  [delegate restClient:client receivedResponse:restResponse];
  
  [restResponse release];
  [self setFinished:YES];
}

#pragma mark Private methods

- (void)setExecuting:(BOOL)isExecuting;
{
  [self willChangeValueForKey:@"isExecuting"];
  _isExecuting = isExecuting;
  [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)isFinished;
{
  [self willChangeValueForKey:@"isFinished"];
  [self setExecuting:NO];
  _isFinished = isFinished;
  [self didChangeValueForKey:@"isFinished"];
}

@end


