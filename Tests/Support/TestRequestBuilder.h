//
//  TestRequestBuilder.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TEST_HOST @"localhost"
#define DEFAULT_TEST_PORT 11988

typedef void (^MimicStubCallbackBlock)(void);

@class LRMimicRequestStubBuilder;

NSInteger TEST_PORT(void);

void mimicGET(NSString *path, LRMimicRequestStubBuilder *stubBuilder, MimicStubCallbackBlock callback);
void mimicPOST(NSString *path, LRMimicRequestStubBuilder *stubBuilder, MimicStubCallbackBlock callback);
void mimicPUT(NSString *path, LRMimicRequestStubBuilder *stubBuilder, MimicStubCallbackBlock callback);
void mimicDELETE(NSString *path, LRMimicRequestStubBuilder *stubBuilder, MimicStubCallbackBlock callback);
void mimicHEAD(NSString *path, LRMimicRequestStubBuilder *stubBuilder, MimicStubCallbackBlock callback);
void mimic(NSString *method, NSString *path, LRMimicRequestStubBuilder *stubBuilder, MimicStubCallbackBlock callback);

LRMimicRequestStubBuilder *andReturnAnything(void);
LRMimicRequestStubBuilder *andEchoRequest(void);
LRMimicRequestStubBuilder *andReturnBody(NSString *body);
LRMimicRequestStubBuilder *andReturnStatusAndBody(NSInteger status, NSString *body);
LRMimicRequestStubBuilder *andReturnStatusAndBodyWithHeaders(NSInteger, NSString *body, NSDictionary *headers);
LRMimicRequestStubBuilder *andReturnResponseHeader(NSString *key, NSString *value);

