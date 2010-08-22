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

- (void)testCanEncodeNestedKeyPairsMoreThanOneLevelDeep
{
  NSDictionary *bottom = [NSDictionary dictionaryWithObject:@"baz" forKey:@"qux"];
  NSDictionary *nested = [NSDictionary dictionaryWithObject:bottom forKey:@"bottom"];
  NSString *encodedString = [[NSDictionary  dictionaryWithObject:nested forKey:@"nested"] stringWithFormEncodedComponents];

  assertThat(encodedString, equalTo(@"nested[bottom][qux]=baz"));
}

- (void)testURLEncodesSpecialCharactersInValues
{
  NSString *encodedString = [[NSDictionary dictionaryWithObject:@"bar baz" forKey:@"foo"] stringWithFormEncodedComponents];
  assertThat(encodedString, equalTo(@"foo=bar+baz"));
}

- (void)testURLEncodesSpecialCharactersInKeys
{
  NSString *encodedString = [[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo qux"] stringWithFormEncodedComponents];
  assertThat(encodedString, equalTo(@"foo+qux=bar"));
}

- (void)testURLEncodesSpecialCharactersWithNestedKeyPairs
{
  NSDictionary *nested = [NSDictionary dictionaryWithObject:@"baz foo" forKey:@"qux baz"];
  NSString *encodedString = [[NSDictionary  dictionaryWithObject:nested forKey:@"nested object"] stringWithFormEncodedComponents];
  assertThat(encodedString, equalTo(@"nested+object[qux+baz]=baz+foo"));
}

- (void)testCanEncodeNonStringObjectsByEncodingTheirDescription
{
  NSString *encodedString = [[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:123] forKey:@"foo"] stringWithFormEncodedComponents];
  assertThat(encodedString, equalTo(@"foo=123"));
}

@end
