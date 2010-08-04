//
//  LRRestyClient+Internal.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient+Internal.h"
#import "NSDictionary+QueryString.h"

@implementation LRRestyClient (Internal)

- (NSData *)dataFromFormEncodedParameters:(NSDictionary *)parameters;
{
  return [[parameters stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary *)headersForFormEncodedParameters:(NSDictionary *)otherHeaders
{
  NSMutableDictionary *headers = [otherHeaders mutableCopy];
  if (headers == nil) {
    headers = [NSMutableDictionary dictionary];
  }
  [headers setObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
  return headers;
}


@end
