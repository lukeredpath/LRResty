//
//  TestRequestBuilder.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestRequestBuilder.h"

@implementation TestRequestSpecification

- (id)initWithPath:(NSString *)aPath method:(NSString *)theMethod;
{
  if (self = [super init]) {
    method = [theMethod copy];
    path = [aPath copy];
  }
  return self;
}

- (void)dealloc
{
  [method release];
  [path release];
  [super dealloc];
}

- (void)writeToFile:(NSString *)filePath object:(id)resultObject;
{
  NSMutableDictionary *serializable = [NSMutableDictionary dictionary];
  [serializable setObject:method forKey:@"method"];
  [serializable setObject:path forKey:@"path"];
  [serializable setObject:[resultObject description] forKey:@"body"];
  [[NSArray arrayWithObject:serializable] writeToFile:filePath atomically:NO];
}

@end

TestRequestSpecification *forGetRequestTo(NSString *path)
{
  return [[[TestRequestSpecification alloc] initWithPath:path method:@"GET"] autorelease];
}

void serviceStubWillServe(id object, TestRequestSpecification *requestSpec)
{
  [requestSpec writeToFile:@"/tmp/resty_request_spec.plist" object:object];
}
