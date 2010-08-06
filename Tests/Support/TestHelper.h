//
//  TestHelper.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND
#import "OCHamcrest.h"
#import "AssertEventually.h"
#import "TestRequestBuilder.h"
#import "DomainMatchers.h"

#define TEST_HOST @"localhost"
#define TEST_PORT 10090

NSString *anyResponse();
NSString *resourceRoot();
NSString *resourceWithPath(NSString *path);
NSData *encodedString(NSString *aString);
NSData *anyData();
id anyPayload();