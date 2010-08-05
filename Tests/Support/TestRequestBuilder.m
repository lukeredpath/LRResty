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
  [resultObject release];
  [headers release];
  [method release];
  [path release];
  [super dealloc];
}

- (NSDictionary *)asDictionary
{
  NSMutableDictionary *serializable = [NSMutableDictionary dictionary];
  [serializable setObject:method forKey:@"method"];
  [serializable setObject:path forKey:@"path"];
  [serializable setObject:headers forKey:@"headers"];
  [serializable setObject:[resultObject description] forKey:@"body"];
  return serializable;
}

- (id)withHeader:(NSString *)header value:(NSString *)headerValue;
{
  [headers setValue:headerValue forKey:header];
  return self;
}

- (void)setResult:(id)object;
{
  resultObject = [object retain];
}

@end

@implementation TestRequestSpecification

- (id)init
{
  if (self = [super init]) {
    specs = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [specs release];
  [super dealloc];
}

- (void)addSpec:(TestRequestSpecificationBuilder *)spec;
{
  [specs addObject:[spec asDictionary]];
}

- (void)writeToFile:(NSString *)filePath;
{
  [specs writeToFile:filePath atomically:YES];
  [NSThread sleepForTimeInterval:0.1]; // allow time for the file to be written
}

@end

static TestRequestSpecification *__requestSpecification = nil;

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
  if (__requestSpecification == nil) {
    __requestSpecification = [[TestRequestSpecification alloc] init];
  }  
  [requestSpec setResult:object];
  [__requestSpecification addSpec:requestSpec];
  [__requestSpecification writeToFile:@"/tmp/resty_request_spec.plist"];
}

void clearServiceStubs()
{
  __requestSpecification = nil;
}
