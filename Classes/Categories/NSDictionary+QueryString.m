//
//  NSDictionary+QueryString.h
//  LROAuth2Client
//
//  Created by Luke Redpath on 14/05/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+QueryString.h"
#import "NSString+QueryString.h"

@interface NSDictionary ()
- (void)formEncodeObject:(id)object usingKey:(NSString *)key subKey:(NSString *)subKey intoArray:(NSArray *)array;
@end

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
  NSMutableArray *arguments = [NSMutableArray array];
  for (NSString *key in self)
  {
    [self formEncodeObject:[self objectForKey:key] usingKey:key subKey:nil intoArray:arguments];
  }
  return [arguments componentsJoinedByString:@"&"];
}

- (void)formEncodeObject:(id)object usingKey:(NSString *)key subKey:(NSString *)subKey intoArray:(NSMutableArray *)array
{
  NSString *objectKey = nil;
  
  if (subKey) {
    objectKey = [NSString stringWithFormat:@"%@[%@]", [key description], [[subKey description] stringByEscapingForURLQuery]];
  } else {
    objectKey = [[key description] stringByEscapingForURLQuery];
  }
  
  if ([object respondsToSelector:@selector(stringByEscapingForURLQuery)]) {
    [array addObject:[NSString stringWithFormat:@"%@=%@", objectKey, [object stringByEscapingForURLQuery]]];
  } 
  else if ([object isKindOfClass:[self class]]) {
    for (NSString *nestedKey in object) {
      [self formEncodeObject:[object objectForKey:nestedKey] usingKey:objectKey subKey:nestedKey intoArray:array];
    } 
  } else {
    [array addObject:[NSString stringWithFormat:@"%@=%@", objectKey, [[object description] stringByEscapingForURLQuery]]];
  }
}

@end
