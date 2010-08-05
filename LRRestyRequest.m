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
    client = theClient;
    delegate = [theDelegate retain];
    
    URLRequest = [[NSMutableURLRequest alloc] initWithURL:aURL];
    [URLRequest setHTTPMethod:httpMethod];
  }
  return self;
}

- (void)dealloc
{
  [URLRequest release];
  [delegate release];
  [super dealloc];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ %@ <LRRestyRequest>", [URLRequest HTTPMethod], [URLRequest URL]];
}

- (NSURL *)URL
{
  return [URLRequest URL];
}

#pragma mark -
#pragma mark Request manipulation

- (void)setQueryParameters:(NSDictionary *)parameters;
{
  if (parameters == nil) return;
  
  NSURL *URLWithParameters = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [URLRequest.URL absoluteString], [parameters stringWithFormEncodedComponents]]];
  [URLRequest setURL:URLWithParameters];
}

- (void)setHeaders:(NSDictionary *)headers
{
  [URLRequest setAllHTTPHeaderFields:headers];
}

- (void)addHeader:(NSString *)header value:(NSString *)value;
{
  [URLRequest addValue:value forHTTPHeaderField:header];
}

- (void)setPostData:(NSData *)data;
{
  [URLRequest setHTTPBody:data];
}

- (void)setPayload:(id<LRRestyRequestPayload>)payload;
{
  [payload modifyRequest:self];
}

#pragma mark -
#pragma mark NSOperation methods

- (void)start
{
  if (![NSThread isMainThread]) {
    return [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:YES];
  }
  [self setExecuting:YES];
  
  NSURLConnection *connection = [NSURLConnection connectionWithRequest:URLRequest delegate:self];
  
  if (connection == nil) {
    [self setFinished:YES]; 
  }
}

- (void)finish;
{
  LRRestyResponse *restResponse = [[LRRestyResponse alloc] 
       initWithStatus:self.response.statusCode 
         responseData:self.responseData 
              headers:[self.response allHeaderFields]
       originalRequest:self];
  
  [delegate restClient:client receivedResponse:restResponse];
  
  [restResponse release];
  [self setFinished:YES];
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

#pragma mark -
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

#pragma mark -
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


