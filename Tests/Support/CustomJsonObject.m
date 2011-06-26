//
//  CustomJsonObject.m
//  LRResty
//
//  Created by Luke Redpath on 18/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "CustomJsonObject.h"
#import "LRResty.h"

@implementation CustomJsonObject

- (id)initWithJSONString:(NSString *)jsonString;
{
  if ((self = [super init])) {
    string = [jsonString copy];
  }
  return self;
}

- (NSData *)dataForRequest
{
  return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)contentTypeForRequest
{
  return @"application/json";
}

- (void)modifyRequestBeforePerforming:(LRRestyRequest *)request
{
  [request addHeader:@"Accept" value:@"application/json"];
}

@end
