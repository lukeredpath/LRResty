//
//  NSURL+QueryInspector.m
//  LROAuth2Client
//
//  Created by Luke Redpath on 14/05/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "NSURL+QueryInspector.h"
#import "NSDictionary+QueryString.h"

@implementation NSURL (QueryInspector)

- (NSDictionary *)queryDictionary;
{
  return [NSDictionary dictionaryWithFormEncodedString:self.query];
}

@end
