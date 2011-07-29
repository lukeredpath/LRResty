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

NSString *resourceRoot()
{
  return resourceRootWithPort(TEST_PORT());
}

NSString *resourceRootWithPort(NSInteger port)
{
  return [NSString stringWithFormat:@"http://%@:%d", TEST_HOST, port];
}

NSString *resourceWithPath(NSString *path)
{
  return [NSString stringWithFormat:@"%@%@", resourceRoot(), path];
}

NSString *resourceWithPathWithPort(NSString *path, NSInteger port)
{
  return [NSString stringWithFormat:@"%@%@", resourceRootWithPort(port), path];
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

void waitForInterval(NSTimeInterval interval)
{
  dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    sleep(interval);
  });
}
