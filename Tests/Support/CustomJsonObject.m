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
  if (self = [super init]) {
    string = [jsonString copy];
  }
  return self;
}

- (void)modifyRequest:(LRRestyRequest *)request
{
  [request addHeader:@"Accept" value:@"application/json"];
  [request addHeader:@"Content-Type" value:@"application/json"];
  [request setPostData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
