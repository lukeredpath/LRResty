//
//  TestRequestBuilder.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestRequestBuilder.h"
#import "LRMimic.h"
#import "NSDictionary+QueryString.h"

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

#pragma mark -
#pragma mark LRMimic 

void mimicGET(NSString *path, LRMimicRequestStubBuilder *stubBuilder, MimicStubCallbackBlock callback)
{
  mimic(@"GET", path, stubBuilder, callback);
}

void mimicPOST(NSString *path, LRMimicRequestStubBuilder *stubBuilder, MimicStubCallbackBlock callback)
{
  mimic(@"POST", path, stubBuilder, callback);
}

void mimicPUT(NSString *path, LRMimicRequestStubBuilder *stubBuilder, MimicStubCallbackBlock callback)
{
  mimic(@"PUT", path, stubBuilder, callback);
}

void mimicDELETE(NSString *path, LRMimicRequestStubBuilder *stubBuilder, MimicStubCallbackBlock callback)
{
  mimic(@"DELETE", path, stubBuilder, callback);
}

void mimicHEAD(NSString *path, LRMimicRequestStubBuilder *stubBuilder, MimicStubCallbackBlock callback)
{
  mimic(@"HEAD", path, stubBuilder, callback);
}

void mimic(NSString *method, NSString *path, LRMimicRequestStubBuilder *stubBuilder, MimicStubCallbackBlock callback)
{
  stubBuilder.method = @"GET";

  NSArray *pathComponents = [path componentsSeparatedByString:@"?"];
  if (pathComponents.count == 2) {
    stubBuilder.path = [pathComponents objectAtIndex:0];
    stubBuilder.queryParameters = [NSDictionary dictionaryWithFormEncodedString:[pathComponents objectAtIndex:1]];
  } else {
    stubBuilder.path = path;
  }
  
  [LRMimic setURL:@"http://localhost:11989/api"];
  [LRMimic setAutomaticallyClearsStubs:YES];
  [LRMimic reset];
  
  [LRMimic configure:^(LRMimic *mimic) {
    [mimic addRequestStub:[stubBuilder buildStub]];
  }];
  
  [LRMimic stubAndCall:^(BOOL success) {
    if (success) {
      callback();
    } else {
      [[NSException exceptionWithName:@"STUB ERROR" reason:@"Failure performing mimic stub" userInfo:nil] raise];
    }
  }];
}

LRMimicRequestStubBuilder *andReturnAnything()
{
  return [LRMimicRequestStubBuilder builder];
}

LRMimicRequestStubBuilder *andEchoRequest()
{
  LRMimicRequestStubBuilder *builder = andReturnAnything();
  builder.echoRequest = YES;
  return builder;
}

LRMimicRequestStubBuilder *andReturnBody(NSString *body)
{
  LRMimicRequestStubBuilder *builder = andReturnAnything();
  builder.body = body;
  return builder;
}

LRMimicRequestStubBuilder *andReturnStatusAndBody(NSInteger status, NSString *body)
{
  LRMimicRequestStubBuilder *builder = andReturnAnything();
  builder.code = status;
  builder.body = body;
  return builder;
}

LRMimicRequestStubBuilder *andReturnStatusAndBodyWithHeaders(NSInteger status, NSString *body, NSDictionary *headers)
{
  LRMimicRequestStubBuilder *builder = andReturnAnything();
  builder.code = status;
  builder.body = body;
  builder.headers = headers;
  return builder;
}

LRMimicRequestStubBuilder *andReturnResponseHeader(NSString *key, NSString *value)
{
  LRMimicRequestStubBuilder *builder = andReturnAnything();
  builder.headers = [NSDictionary dictionaryWithObject:value forKey:key];
  return builder;
}
