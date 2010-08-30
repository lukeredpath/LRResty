//
//  OSCompatibilityTests.m
//  LRResty
//
//  Created by Luke Redpath on 29/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND
#import "OCHamcrest.h"
#import "NSURL+Compatibility.h"

@interface OSCompatibilityTests : SenTestCase
@end

@implementation OSCompatibilityTests

- (void)testURLByAppendingPath
{
  NSURL *URL = [NSURL URLWithString:@"http://www.example.com"];
  assertThat([[URL URLByAppendingPathComponent:@"foo"] absoluteString], equalTo(@"http://www.example.com/foo"));
}

- (void)testURLByAppendingPathWithPort
{
  NSURL *URL = [NSURL URLWithString:@"http://www.example.com:80"];
  assertThat([[URL URLByAppendingPathComponent:@"foo"] absoluteString], equalTo(@"http://www.example.com:80/foo"));
}

- (void)testURLByAppendingPathTwice
{
  NSURL *URL = [NSURL URLWithString:@"http://www.example.com"];
  NSURL *subURL = [URL URLByAppendingPathComponent:@"foo"];
  assertThat([[subURL URLByAppendingPathComponent:@"bar"] absoluteString], equalTo(@"http://www.example.com/foo/bar"));
}

- (void)testURLByDeletingPathExtension
{
  NSURL *URL = [NSURL URLWithString:@"http://www.example.com/foo.json"];
  assertThat([[URL URLByDeletingPathExtension] absoluteString], equalTo(@"http://www.example.com/foo"));
}

@end
