//
//  TestRequestBuilder.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestRequestBuilder.h"

@implementation TestRequestSpecificationBuilder

- (id)initWithPath:(NSString *)aPath method:(NSString *)theMethod;
{
  if (self = [super init]) {
    method = [theMethod copy];
    path = [aPath copy];
    headers = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [headers release];
  [method release];
  [path release];
  [super dealloc];
}

- (void)writeToFile:(NSString *)filePath object:(id)resultObject;
{
  NSMutableDictionary *serializable = [NSMutableDictionary dictionary];
  [serializable setObject:method forKey:@"method"];
  [serializable setObject:path forKey:@"path"];
  [serializable setObject:headers forKey:@"headers"];
  [serializable setObject:[resultObject description] forKey:@"body"];
  [[NSArray arrayWithObject:serializable] writeToFile:filePath atomically:YES];
  [NSThread sleepForTimeInterval:0.1]; // allow time for the file to be written
}

- (id)withHeader:(NSString *)header value:(NSString *)headerValue;
{
  [headers setValue:headerValue forKey:header];
  return self;
}

@end

TestRequestSpecificationBuilder *forGetRequestTo(NSString *path)
{
  return [[[TestRequestSpecificationBuilder alloc] initWithPath:path method:@"GET"] autorelease];
}

void serviceStubWillServe(id object, TestRequestSpecificationBuilder *requestSpec)
{
  serviceStubWillServeWithHeaders(object, nil, requestSpec);
}

void serviceStubWillServeWithHeaders(id object, NSDictionary *headers, TestRequestSpecificationBuilder *requestSpec)
{
  [requestSpec writeToFile:@"/tmp/resty_request_spec.plist" object:object];
}
