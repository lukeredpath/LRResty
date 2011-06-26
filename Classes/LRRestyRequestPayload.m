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
  if ([object conformsToProtocol:@protocol(LRRestyRequestPayload)]) {
    return object;
  }
  if ([object respondsToSelector:@selector(dataUsingEncoding:)]) {
    return [[[LRRestyDataPayload alloc] initWithEncodable:object encoding:NSUTF8StringEncoding] autorelease];
  }
  if ([object isKindOfClass:[NSDictionary class]]) {
    return [[[LRRestyFormEncodedPayload alloc] initWithDictionary:object] autorelease];
  }
  if ([object isKindOfClass:[NSData class]]) {
    return [[[LRRestyDataPayload alloc] initWithData:object] autorelease];
  }
  return nil;
}

@end

@implementation LRRestyDataPayload

- (id)initWithData:(NSData *)data;
{
  if ((self = [super init])) {
    requestData = [data copy];
  }
  return self;
}

- (id)initWithEncodable:(id)encodable encoding:(NSStringEncoding)encoding
{
  if (![encodable respondsToSelector:@selector(dataUsingEncoding:)]) {
    [NSException raise:NSInternalInconsistencyException format:@"Expected an object that responds to dataUsingEncoding", nil];
  }
  return [self initWithData:[encodable dataUsingEncoding:encoding]];
}

- (void)dealloc
{
  [requestData release];
  [super dealloc];
}

- (void)modifyRequest:(LRRestyRequest *)request
{
  [request setPostData:requestData];
}

@end

@implementation LRRestyFormEncodedPayload

- (id)initWithDictionary:(NSDictionary *)aDictionary;
{
  if ((self = [super init])) {
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


