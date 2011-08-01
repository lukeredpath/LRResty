//
//  LRRestyRequest.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyRequest.h"
#import "LRRestyResponse+Internal.h"
#import "LRRestyRequest+Internal.h"
#import "NSDictionary+QueryString.h"
#import "NSData+Base64.h"
#import "LRResty.h"

#pragma mark -

@implementation LRRestyRequest

@synthesize numberOfRetries;
@synthesize HTTPClient;
@synthesize error = _error;

- (id)initWithURL:(NSURL *)aURL method:(NSString *)httpMethod delegate:(id<LRRestyRequestDelegate>)theDelegate;
{
  if ((self = [super init])) {
    delegate = [theDelegate retain];
    _URLRequest = [[NSMutableURLRequest alloc] initWithURL:aURL];
    [_URLRequest setHTTPMethod:httpMethod];
  }
  return self;
}

- (void)dealloc
{
  [_error release];
  [credential release];
  [delegate release];
  [_URLRequest release];
  [super dealloc];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ %@ <LRRestyRequest>", [_URLRequest HTTPMethod], [_URLRequest URL]];
}

- (NSURL *)URL
{
  return [_URLRequest URL];
}

#pragma mark -
#pragma mark Request manipulation

- (void)setQueryParameters:(NSDictionary *)parameters;
{
  if (parameters == nil) return;
  
  NSURL *URLWithParameters = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [_URLRequest.URL absoluteString], [parameters stringWithFormEncodedComponents]]];
  [_URLRequest setURL:URLWithParameters];
}

- (void)setHeaders:(NSDictionary *)headers
{
  [_URLRequest setAllHTTPHeaderFields:headers];
}

- (void)addHeader:(NSString *)header value:(NSString *)value;
{
  [_URLRequest setValue:value forHTTPHeaderField:header];
}

- (void)setPostData:(NSData *)data;
{
  [_URLRequest setHTTPBody:data];
}

- (void)setPayload:(id<LRRestyRequestPayload>)payload;
{
  [self setPostData:[payload dataForRequest]];
  [self addHeader:@"Content-Type" value:[payload contentTypeForRequest]];
  if ([payload respondsToSelector:@selector(modifyRequestBeforePerforming:)]) {
    [payload modifyRequestBeforePerforming:self];
  }
}

- (void)setHandlesCookiesAutomatically:(BOOL)shouldHandleCookies;
{
  [_URLRequest setHTTPShouldHandleCookies:shouldHandleCookies];
}

- (void)setBasicAuthUsername:(NSString *)username password:(NSString *)password useCredentialSystem:(BOOL)useCredential;
{
  if (useCredential) {
    credential = [[NSURLCredential credentialWithUser:username password:password persistence:NSURLCredentialPersistenceNone] retain];
  } else {
    NSData *credentialData = [[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding];
    [self addHeader:@"Authorization" value:[NSString stringWithFormat:@"Basic %@", [credentialData base64EncodedString]]];
  }
}

#pragma mark -
#pragma mark Timeouts

- (void)timeoutAfter:(NSTimeInterval)delayInSeconds handleWithBlock:(LRRestyRequestTimeoutBlock)block
{
  // by the time this is called, the request has started or is about to start/ so we can just start the timeout now
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (double)delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    if (![self isFinished]) {
      [self cancelImmediately];
      
      dispatch_sync(dispatch_get_main_queue(), ^{
        block(self);
      });
    }
  });
}

#pragma mark - Retry support

- (LRRestyRequest *)retry
{
  LRRestyRequest *retryRequest = [[LRRestyRequest alloc] initWithURLRequest:_URLRequest delegate:delegate];
  retryRequest.numberOfRetries = self.numberOfRetries + 1;
  [self.HTTPClient performRequest:retryRequest];
  return [retryRequest autorelease];
}

#pragma mark -
#pragma mark NSOperation methods

- (void)start
{
  self.URLRequest = _URLRequest;

  [super start];

  if ([delegate respondsToSelector:@selector(restyRequestDidStart:)]) {
    [delegate restyRequestDidStart:self];
  }
  [LRResty log:[NSString stringWithFormat:@"Performing %@ with headers %@", self, [URLRequest allHTTPHeaderFields]]];
}

- (void)finish;
{
  LRRestyResponse *restResponse = [[LRRestyResponse alloc] 
       initWithStatus:[(NSHTTPURLResponse *)self.URLResponse statusCode]
         responseData:self.responseData 
              headers:[(NSHTTPURLResponse *)self.URLResponse allHeaderFields]
       originalRequest:self];
  
  [delegate restyRequest:self didFinishWithResponse:restResponse];
  
  [restResponse release];
  
  [LRResty log:[NSString stringWithFormat:@"Finished request %@", self]];
  
  [super finish];
}

#pragma mark -

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
  if (credential && [challenge previousFailureCount] < 1) {
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
  } else {
    [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  if ([delegate respondsToSelector:@selector(restyRequest:didReceiveData:)]) {
    [delegate restyRequest:self didReceiveData:data];
  }
  [super connection:connection didReceiveData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  _error = [error retain];
  
  if ([delegate respondsToSelector:@selector(restyRequest:didFailWithError:)]) {
    [delegate restyRequest:self didFailWithError:_error];
  }
  
  LRRestyResponse *restResponse = [[LRRestyResponse alloc] initWithStatus:0 responseData:nil headers:nil originalRequest:self];
  [delegate restyRequest:self didFinishWithResponse:restResponse];
  [restResponse release];
  
  [LRResty log:[NSString stringWithFormat:@"Failed with error %@", error]];
  
  [super connection:connection didFailWithError:error];
}

@end

#pragma mark -

@implementation LRRestyRequest (RetrySupport)

- (id)initWithURLRequest:(NSMutableURLRequest *)request delegate:(id<LRRestyRequestDelegate>)theDelegate
{
  if ((self = [super init])) {
    delegate = [theDelegate retain];
    _URLRequest = [request retain];
  }
  return self;
}

@end

