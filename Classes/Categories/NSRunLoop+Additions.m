//
//  NSRunLoop+Additions.m
//  LRResty
//
//  Created by Luke Redpath on 20/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "NSRunLoop+Additions.h"


@implementation NSRunLoop (Additions)

- (void)runForTimeInterval:(NSTimeInterval)interval;
{
  [self runUntilDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
