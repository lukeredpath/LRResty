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

NSInteger TEST_PORT(void)
{
  NSInteger mimicPort = DEFAULT_TEST_PORT;
  NSString *customPort = [[[NSProcessInfo processInfo] environment] objectForKey:@"MIMIC_PORT"];
  if (customPort) { mimicPort = [customPort integerValue]; }
  return mimicPort;
}

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
  stubBuilder.method = method;

  NSArray *pathComponents = [path componentsSeparatedByString:@"?"];
  if (pathComponents.count == 2) {
    stubBuilder.path = [pathComponents objectAtIndex:0];
    stubBuilder.queryParameters = [NSDictionary dictionaryWithFormEncodedString:[pathComponents objectAtIndex:1]];
  } else {
    stubBuilder.path = path;
  }
  
  [LRMimic setAutomaticallyClearsStubs:YES];
  [LRMimic setURL:[NSString stringWithFormat:@"http://localhost:%d/api", TEST_PORT()]];
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
