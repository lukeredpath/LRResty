//
//  LRResty.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRResty.h"
#import "LRRestyClient.h"

@implementation LRResty

+ (LRRestyClient *)client;
{
  return [[[LRRestyClient alloc] init] autorelease];
}

@end
