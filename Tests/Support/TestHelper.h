//
//  TestHelper.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HC_SHORTHAND
#import "OCHamcrest.h"
#import "AssertEventually.h"
#import "LRMimic.h"
#import "TestRequestBuilder.h"
#import "DomainMatchers.h"

NSString *anyResponse(void);
NSString *resourceRoot(void);
NSString *resourceRootWithPort(NSInteger port);
NSString *resourceWithPath(NSString *path);
NSString *resourceWithPathWithPort(NSString *path, NSInteger port);
NSData *encodedString(NSString *aString);
NSData *anyData(void);
id anyPayload(void);
void waitForInterval(NSTimeInterval interval);
