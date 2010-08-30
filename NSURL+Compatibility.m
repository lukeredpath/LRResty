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
  
  NSString *existingPath = [self path];
  if ([existingPath isEqualToString:@""]) {
    existingPath = @"/";
  }  
  if ([self port] > 0) {
    newString = [NSString stringWithFormat:@"%@://%@:%@%@", 
        [self scheme], [self host], [self port], [existingPath stringByAppendingPathComponent:component]]; 
  } else {
    newString = [NSString stringWithFormat:@"%@://%@%@", 
        [self scheme], [self host], [existingPath stringByAppendingPathComponent:component]];
  }
  return [NSURL URLWithString:newString];
}

- (NSURL *)URLByDeletingPathExtension
{
  return [[[NSURL alloc] initWithScheme:[self scheme] host:[self host] path:[[self path] stringByDeletingPathExtension]] autorelease];
}

@end
