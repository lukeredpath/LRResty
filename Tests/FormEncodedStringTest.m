//
//  FormEncodedStringTest.m
//  LRResty
//
//  Created by Luke Redpath on 04/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "NSDictionary+QueryString.h"

@interface FormEncodedStringTest : SenTestCase
{}
@end

@implementation FormEncodedStringTest

- (void)testCanEncodeSimpleKeyPair
{
  NSString *encodedString = [[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"] stringWithFormEncodedComponents];
  assertThat(encodedString, equalTo(@"foo=bar"));
}

- (void)testCanEncodeMultipleKeyPairs
{
  NSString *encodedString = [[NSDictionary dictionaryWithObjectsAndKeys:@"bar", @"foo", @"qux", @"baz", nil] stringWithFormEncodedComponents];
  assertThat(encodedString, equalTo(@"foo=bar&baz=qux"));
}

- (void)testCanEncodeNestedKeyPairs
{
  NSDictionary *nested = [NSDictionary dictionaryWithObject:@"baz" forKey:@"qux"];
  NSString *encodedString = [[NSDictionary  dictionaryWithObject:nested forKey:@"nested"] stringWithFormEncodedComponents];
  assertThat(encodedString, equalTo(@"nested[qux]=baz"));
}

@end
