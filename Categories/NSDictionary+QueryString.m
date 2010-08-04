//
//  NSDictionary+QueryString.h
//  LROAuth2Client
//
//  Created by Luke Redpath on 14/05/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "NSDictionary+QueryString.h"
#import "NSString+QueryString.h"

@implementation NSDictionary (QueryString)

+ (NSDictionary *)dictionaryWithFormEncodedString:(NSString *)encodedString
{
  NSMutableDictionary* result = [NSMutableDictionary dictionary];
  NSArray* pairs = [encodedString componentsSeparatedByString:@"&"];

  for (NSString* kvp in pairs)
  {
    if ([kvp length] == 0)
      continue;

    NSRange pos = [kvp rangeOfString:@"="];
    NSString *key;
    NSString *val;

    if (pos.location == NSNotFound) 
    {
      key = [kvp stringByUnescapingFromURLQuery];
      val = @"";
    }
    else
    {
      key = [[kvp substringToIndex:pos.location] stringByUnescapingFromURLQuery];
      val = [[kvp substringFromIndex:pos.location + pos.length] stringByUnescapingFromURLQuery];
    }

    if (!key || !val)
      continue; // I'm sure this will bite my arse one day

    [result setObject:val forKey:key];
  }
  return result;
}

- (NSString *)stringWithFormEncodedComponents
{
  NSMutableArray* arguments = [NSMutableArray array];
  for (NSString* key in self)
  {
    id object = [self objectForKey:key];
    if ([object respondsToSelector:@selector(stringByEscapingForURLQuery)]) {
      [arguments addObject:[NSString stringWithFormat:@"%@=%@",
        [key stringByEscapingForURLQuery],
        [[[self objectForKey:key] description] stringByEscapingForURLQuery]]]; 
    } 
    else if ([object isKindOfClass:[self class]]) {
      for (NSString *subKey in object) {
        [arguments addObject:[NSString stringWithFormat:@"%@[%@]=%@",
          [key stringByEscapingForURLQuery],
          [subKey stringByEscapingForURLQuery],
          [[[object objectForKey:subKey] description] stringByEscapingForURLQuery]]];
      } 
    }
  }
  return [arguments componentsJoinedByString:@"&"];
}

@end
