//
//  LRRestyResponse.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyResponse.h"


@implementation LRRestyResponse

- (NSUInteger)status;
{
  return 200;
}

- (NSString *)asString;
{
  return @"plain text response";
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%d Response", [self status]];
}

@end
