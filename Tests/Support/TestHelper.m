//
//  TestHelper.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"

NSString *anyResponse()
{
  return @"";
}

NSString *resourceWithPath(NSString *path)
{
  return [NSString stringWithFormat:@"http://%@:%d%@", TEST_HOST, TEST_PORT, path];
}

NSData *encodedString(NSString *aString)
{
  return [aString dataUsingEncoding:NSUTF8StringEncoding];
}

NSData *anyData()
{
  return encodedString(@"");
}

id anyPayload()
{
  return nil;
}
