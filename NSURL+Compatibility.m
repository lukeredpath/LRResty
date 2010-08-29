//
//  NSURL+Compatibility.m
//  LRResty
//
//  Created by Luke Redpath on 29/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "NSURL+Compatibility.h"

@implementation NSURL (Compatibility)

- (NSURL *)URLByAppendingPathComponent:(NSString *)component;
{
  NSString *newString;
  if ([self port] > 0) {
   newString = [NSString stringWithFormat:@"%@://%@:%@/%@", 
        [self scheme], [self host], [self port], [[self path] stringByAppendingPathComponent:component]]; 
  } else {
   newString = [NSString stringWithFormat:@"%@://%@/%@", 
        [self scheme], [self host], [[self path] stringByAppendingPathComponent:component]];
  }
  return [NSURL URLWithString:newString];
}

@end
