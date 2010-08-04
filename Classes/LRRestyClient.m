//
//  LRRestyClient.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient.h"
#import "LRRestyResponse.h"
#import "LRRestyClientDelegate.h"
#import "NSDictionary+QueryString.h"

@interface LRRestyRequest : NSOperation
{
  NSURL *requestURL;
  NSString *requestMethod;
  LRRestyClient *client;
  NSDictionary *requestHeaders;
  id<LRRestyClientDelegate> delegate;
  BOOL _isExecuting;
  BOOL _isFinished;
  NSError *connectionError;
  NSMutableData *responseData;
  NSHTTPURLResponse *response;
  NSData *postData;
}
@property (nonatomic, retain) NSHTTPURLResponse *response;
@property (nonatomic, retain) NSData *responseData;
@property (nonatomic, retain) NSError *connectionError;

- (id)initWithURL:(NSURL *)aURL method:(NSString *)httpMethod client:(LRRestyClient *)theClient delegate:(id<LRRestyClientDelegate>)theDelegate;
- (void)setExecuting:(BOOL)isExecuting;
- (void)setFinished:(BOOL)isFinished;
- (void)finish;
- (void)setQueryParameters:(NSDictionary *)parameters;
- (void)setHeaders:(NSDictionary *)headers;
- (void)setPostData:(NSData *)data;
@end

@interface LRRestyClientBlockDelegate : NSObject <LRRestyClientDelegate>
{
  LRRestyResponseBlock block;
}
+ (id)delegateWithBlock:(LRRestyResponseBlock)block;
- (id)initWithBlock:(LRRestyResponseBlock)theBlock;
@end

@interface LRRestyClient ()
- (LRRestyRequest *)requestForURL:(NSURL *)url method:(NSString *)httpMethod headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
@end

#pragma mark -

@implementation LRRestyClient

- (id)init
{
  if (self = [super init]) {
    operationQueue = [[NSOperationQueue alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [operationQueue release];
  [super dealloc];
}

- (LRRestyRequest *)requestForURL:(NSURL *)url method:(NSString *)httpMethod headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  LRRestyRequest *request = [[LRRestyRequest alloc] initWithURL:url method:httpMethod client:self delegate:delegate];
  [request setHeaders:headers];
  return [request autorelease];
}

#pragma mark -
#pragma mark GET requests

- (void)get:(NSString *)urlString delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self get:urlString parameters:nil delegate:delegate];
}

- (void)get:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self get:urlString parameters:parameters headers:nil delegate:delegate];
}

- (void)get:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self getURL:[NSURL URLWithString:urlString] parameters:parameters headers:headers delegate:delegate];
}

- (void)getURL:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  LRRestyRequest *request = [self requestForURL:url method:@"GET" headers:headers delegate:delegate];
  [request setQueryParameters:parameters];
  [operationQueue addOperation:request];
}

#pragma mark withBlock

- (void)get:(NSString *)urlString withBlock:(LRRestyResponseBlock)block;
{
  [self get:urlString parameters:nil withBlock:block];
}

- (void)get:(NSString *)urlString parameters:(NSDictionary *)parameters withBlock:(LRRestyResponseBlock)block;
{
  [self get:urlString parameters:parameters headers:nil withBlock:block];
}

- (void)get:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self getURL:[NSURL URLWithString:urlString] parameters:parameters headers:headers withBlock:block];
}

- (void)getURL:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self getURL:url parameters:parameters headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

#pragma mark -
#pragma mark POST requests

- (void)post:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self post:urlString parameters:parameters headers:nil delegate:delegate];
}

- (void)post:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  NSMutableDictionary *mergedHeaders = [headers mutableCopy];
  if (mergedHeaders == nil) {
    mergedHeaders = [NSMutableDictionary dictionary];
  }
  [mergedHeaders setObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
  
  [self post:urlString 
        data:[[parameters stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding] 
     headers:mergedHeaders
    delegate:delegate];
}

- (void)post:(NSString *)urlString data:(NSData *)postData delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self post:urlString data:postData headers:nil delegate:delegate];
}

- (void)post:(NSString *)urlString data:(NSData *)postData headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self postURL:[NSURL URLWithString:urlString] data:postData headers:headers delegate:delegate];
}

- (void)postURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  LRRestyRequest *request = [self requestForURL:url method:@"POST" headers:headers delegate:delegate];
  [request setPostData:postData];
  [operationQueue addOperation:request];
}

#pragma mark withBlock

- (void)post:(NSString *)urlString parameters:(NSDictionary *)parameters withBlock:(LRRestyResponseBlock)block;
{
  [self post:urlString parameters:parameters headers:nil withBlock:block];
}

- (void)post:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self post:urlString parameters:parameters headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

- (void)post:(NSString *)urlString data:(NSData *)postData withBlock:(LRRestyResponseBlock)block;
{
  [self post:urlString data:postData headers:nil withBlock:block];
}

- (void)post:(NSString *)urlString data:(NSData *)postData headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self postURL:[NSURL URLWithString:urlString] data:postData headers:headers withBlock:block];
}

- (void)postURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self postURL:url data:postData headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

#pragma mark -
#pragma mark PUT requests

- (void)put:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self put:urlString parameters:parameters headers:nil delegate:delegate];
}

- (void)put:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  NSMutableDictionary *mergedHeaders = [headers mutableCopy];
  if (mergedHeaders == nil) {
    mergedHeaders = [NSMutableDictionary dictionary];
  }
  [mergedHeaders setObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
  
  [self put:urlString 
       data:[[parameters stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding] 
    headers:mergedHeaders
   delegate:delegate];
}

- (void)put:(NSString *)urlString data:(NSData *)postData delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self put:urlString data:postData headers:nil delegate:delegate];
}

- (void)put:(NSString *)urlString data:(NSData *)postData headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  [self putURL:[NSURL URLWithString:urlString] data:postData headers:headers delegate:delegate];
}

- (void)putURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
{
  LRRestyRequest *request = [self requestForURL:url method:@"PUT" headers:headers delegate:delegate];
  [request setPostData:postData];
  [operationQueue addOperation:request];
}

#pragma mark withBlock

- (void)put:(NSString *)urlString parameters:(NSDictionary *)parameters withBlock:(LRRestyResponseBlock)block;
{
  [self put:urlString parameters:parameters headers:nil withBlock:block];
}

- (void)put:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self put:urlString parameters:parameters headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

- (void)put:(NSString *)urlString data:(NSData *)postData withBlock:(LRRestyResponseBlock)block;
{
  [self put:urlString data:postData headers:nil withBlock:block];
}

- (void)put:(NSString *)urlString data:(NSData *)postData headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self putURL:[NSURL URLWithString:urlString] data:postData headers:headers withBlock:block];
}

- (void)putURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
{
  [self putURL:url data:postData headers:headers delegate:[LRRestyClientBlockDelegate delegateWithBlock:block]];
}

@end

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

@implementation LRRestyClientBlockDelegate

+ (id)delegateWithBlock:(LRRestyResponseBlock)block;
{
  return [[[self alloc] initWithBlock:block] autorelease];
}

- (id)initWithBlock:(LRRestyResponseBlock)theBlock;
{
  if (self = [super init]) {
    block = Block_copy(theBlock);
  }
  return self;
}

- (void)dealloc
{
  Block_release(block);
  [super dealloc];
}

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response
{
  block(response);
}

@end
