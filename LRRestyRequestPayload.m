//
//  LRRestyRequestPayload.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyRequestPayload.h"
#import "LRRestyRequest.h"
#import "NSDictionary+QueryString.h"

@implementation LRRestyRequestPayloadFactory

+ (id)payloadFromObject:(id)object;
{
  if ([object respondsToSelector:@selector(dataUsingEncoding:)]) {
    return [[[LRRestyRequestEncodablePayload alloc] initWithEncodableObject:object] autorelease];
  }
  if ([object isKindOfClass:[NSDictionary class]]) {
    return [[[LRRestyRequestFormEncodedData alloc] initWithDictionary:object] autorelease];
  }
  return nil;
}

@end

@implementation LRRestyRequestEncodablePayload

- (id)initWithEncodableObject:(id)object;
{
  if (self = [super init]) {
    if ([object conformsToProtocol:@protocol(NSCopying)]) {
      encodable = [object copy];
    } else {
      encodable = [object retain];
    }
  }
  return self;
}

- (void)dealloc
{
  [encodable release];
  [super dealloc];
}

- (void)modifyRequest:(LRRestyRequest *)request
{
  [request setPostData:[encodable dataUsingEncoding:NSUTF8StringEncoding]];
}

@end

@implementation LRRestyRequestFormEncodedData

- (id)initWithDictionary:(NSDictionary *)aDictionary;
{
  if (self = [super init]) {
    dictionary = [aDictionary copy];
  }
  return self;
}

- (void)dealloc
{
  [dictionary release];
  [super dealloc];
}

- (void)modifyRequest:(LRRestyRequest *)request
{
  [request setPostData:[[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
  [request addHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
}

@end


