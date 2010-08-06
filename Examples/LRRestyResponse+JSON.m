//
//  LRRestyResponse+JSON.m
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyResponse+JSON.h"
#import "CJSONDeserializer.h"

@implementation LRRestyResponse (JSON)

- (id)asJSONObject;
{
  return [[CJSONDeserializer deserializer] deserialize:responseData error:NULL];
}

@end
