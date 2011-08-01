//
//  LRRestyResponse.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyResponse.h"
#import "LRRestyRequest.h"

NSDictionary *extractCookiesFromHeaders(NSDictionary *headers, NSURL *url);

NSDictionary *extractCookiesFromHeaders(NSDictionary *headers, NSURL *url)
{
  if (headers == nil) return [NSDictionary dictionary];
  
  NSMutableDictionary *cookies = [NSMutableDictionary dictionary];
  for (NSHTTPCookie *cookie in [NSHTTPCookie cookiesWithResponseHeaderFields:headers forURL:url]) {
    [cookies setObject:cookie forKey:cookie.name];
  }
  return cookies;
}

@implementation LRRestyResponse

@synthesize responseData;
@synthesize headers;
@synthesize status;
@synthesize originalRequest = _originalRequest;

- (id)initWithStatus:(NSInteger)statusCode responseData:(NSData *)data headers:(NSDictionary *)theHeaders originalRequest:(LRRestyRequest *)originalRequest;
{
  if ((self = [super init])) {
    status = statusCode;
    responseData = [data retain];
    headers = [theHeaders copy];
    cookies = [extractCookiesFromHeaders(headers, originalRequest.URL) copy];
    _originalRequest = [originalRequest retain];
  }
  return self;
}

- (void)dealloc
{
  [_originalRequest release];
  [cookies release];
  [headers release];
  [responseData release];
  [super dealloc];
}

- (NSString *)localizedStatusDescription
{
  return [NSHTTPURLResponse localizedStringForStatusCode:self.status];
}

- (NSString *)asString;
{
  return [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%d %@ | text/plain (%d bytes)", 
    self.status, self.localizedStatusDescription, [responseData length]];
}

- (NSHTTPCookie *)cookieNamed:(NSString *)name;
{
  return [cookies objectForKey:name];
}

- (NSString *)valueForHeader:(NSString *)header;
{
  return [headers objectForKey:header];
}

- (NSString *)valueForCookie:(NSString *)cookieNamed;
{
  return [[self cookieNamed:cookieNamed] value];
}

- (BOOL)wasSuccessful
{
  return (status > 0) && !self.originalRequest.error;
}

@end
