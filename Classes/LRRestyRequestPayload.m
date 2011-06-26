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

#pragma mark -
#pragma mark Private Headers

@interface LRRestyDataPayload : NSObject <LRRestyRequestPayload>
{
  NSData *requestData;
  NSString *contentType;
}
- (id)initWithData:(NSData *)data;
- (id)initWithEncodable:(id)encodable encoding:(NSStringEncoding)encoding;
@end

@interface LRRestyFormEncodedPayload : NSObject <LRRestyRequestPayload>
{
  NSDictionary *dictionary;
}
- (id)initWithDictionary:(NSDictionary *)aDictionary;
@end

#pragma mark -

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

#pragma mark -
#pragma mark Native payloads

@implementation LRRestyDataPayload

- (id)initWithData:(NSData *)data;
{
  if ((self = [super init])) {
    requestData = [data copy];
    contentType = [@"application/octet-stream" copy];
  }
  return self;
}

- (id)initWithEncodable:(id)encodable encoding:(NSStringEncoding)encoding
{
  if (![encodable respondsToSelector:@selector(dataUsingEncoding:)]) {
    [NSException raise:NSInternalInconsistencyException format:@"Expected an object that responds to dataUsingEncoding", nil];
  }
  if ((self = [self init])) {
    requestData = [[encodable dataUsingEncoding:encoding] copy];
    contentType = [@"text/plain" copy];
  }
  return self;
}

- (void)dealloc
{
  [contentType release];
  [requestData release];
  [super dealloc];
}

- (NSData *)dataForRequest
{
  return requestData;
}

- (NSString *)contentTypeForRequest
{
  return contentType;
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

- (NSData *)dataForRequest
{
  return [[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)contentTypeForRequest
{
  return @"application/x-www-form-urlencoded";
}

@end
