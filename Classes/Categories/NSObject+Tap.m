//
//  NSObject+Tap.m
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "NSObject+Tap.h"


@implementation NSObject (Tap)

- (id)tap:(void (^)(id object))block;
{
  block(self);
  return self;
}

@end
