//
//  LRRestyResourceTest.m
//  LRResty
//
//  Created by Luke Redpath on 29/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRResty.h"

@interface LRRestyResource (Testing)
@property (nonatomic, readonly) NSURL *URL;
@end

@implementation LRRestyResource (Testing)
- (NSURL *)URL
{
  return URL;
}
@end

@interface LRRestyResourceTest : SenTestCase
{}
@end

@implementation LRRestyResourceTest

- (void)testTraversingOneLevel
{
  LRRestyResource *resource = [LRResty resource:@"http://www.example.com"];
  assertThat([[resource at:@"somepath"].URL absoluteString], equalTo(@"http://www.example.com/somepath"));
}

- (void)testTraversingTwoLevels
{
  LRRestyResource *resource = [LRResty resource:@"http://www.example.com/"];
  assertThat([[resource at:@"somepath/somesubpath"].URL absoluteString], equalTo(@"http://www.example.com/somepath/somesubpath"));
}

- (void)testTraversingTwoLevelsUsingSubResource
{
  LRRestyResource *resource = [LRResty resource:@"http://www.example.com"];
  assertThat([[[resource at:@"somepath"] at:@"somesubpath"].URL absoluteString], equalTo(@"http://www.example.com/somepath/somesubpath"));
}

@end
