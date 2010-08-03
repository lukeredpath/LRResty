//
//  LRRestyResponse.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyResponse.h"

@interface LRRestyResponse ()
- (NSDictionary *)headers;
@end

@implementation LRRestyResponse

- (id)initWithStatus:(NSInteger)statusCode responseData:(NSData *)data headers:(NSDictionary *)theHeaders;
{
  if (self = [super init]) {
    status = statusCode;
    responseData = [data retain];
    headers = [theHeaders copy];
  }
  return self;
}

- (void)dealloc
{
  [headers release];
  [responseData release];
  [super dealloc];
}

- (NSUInteger)status;
{
  return status;
}

- (NSString *)asString;
{
  return [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%d Response | text/plain (%d bytes)", [self status], [responseData length]];
}

- (NSString *)valueForHeader:(NSString *)header;
{
  return [headers objectForKey:header];
}
@end
