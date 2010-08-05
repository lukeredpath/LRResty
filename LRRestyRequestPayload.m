//
//  LRRestyRequestPayload.m
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyRequestPayload.h"
#import "LRRestyRequest.h"

@implementation LRRestyRequestPayloadFactory

+ (id)payloadFromObject:(id)object;
{
  if ([object respondsToSelector:@selector(dataUsingEncoding:)]) {
    return [[[LRRestyRequestEncodablePayload alloc] initWithEncodableObject:object] autorelease];
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

