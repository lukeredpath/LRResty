//
//  DomainMatchers.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "DomainMatchers.h"
#import "HCPassesBlock.h"
#import "LRRestyResponse.h"
#import "LRRestyRequest.h"
#import "OCHamcrest.h"
#import "HCStringDescription.h"

NSString *describeMatcher(id<HCMatcher> matcher);

NSString *describeMatcher(id<HCMatcher> matcher)
{
  HCStringDescription *description = [[[HCStringDescription alloc] init] autorelease];
  [description appendDescriptionOf:matcher];
  return [description description];
}

id<HCMatcher> responseWithStatus(NSUInteger status)
{
  return responseWithStatusAndBodyMatching(status, HC_anythingWithDescription(@"matching anything"));
}

id<HCMatcher> responseWithStatusAndBody(NSUInteger status, NSString *body)
{
  return responseWithStatusAndBodyMatching(status, HC_equalTo(body));
}

id<HCMatcher> responseWithStatusAndBodyMatching(NSUInteger status, id<HCMatcher>bodyMatcher)
{
  return HC_passesBlock(^(id object) {
    if (![object isKindOfClass:[LRRestyResponse class]]) {
      return NO;
    }
    LRRestyResponse *response = object;
    return (BOOL)(response.status == status && [bodyMatcher matches:[response asString]]);
    
  }, [NSString stringWithFormat:@"a %d response with body that is %@", status, describeMatcher(bodyMatcher)]);
}

id<HCMatcher> responseWithRequestEcho(NSString *keyPath, NSString *value)
{
  return HC_passesBlock(^(id object) {
    if (![object isKindOfClass:[LRRestyResponse class]]) {
      return NO;
    }
    LRRestyResponse *response = object;

    if (response.status != 200) {
      return NO;
    }
    NSDictionary *parsedResponse = [NSPropertyListSerialization propertyListWithData:response.responseData options:0 format:NULL error:NULL];
    if (!parsedResponse) {
      return NO;
    }
    NSDictionary *echo = [parsedResponse objectForKey:@"echo"];

    return [[echo valueForKeyPath:keyPath] isEqualToString:value];
    
  }, [NSString stringWithFormat:@"a 200 response with request echo containing value '%@' at key path '%@'", value, keyPath]);
}

id<HCMatcher> hasHeader(NSString *header, NSString *value)
{
  return HC_passesBlock(^(id object) {
    if (![object isKindOfClass:[LRRestyResponse class]]) {
      return NO;
    }
    LRRestyResponse *response = object;
    
    return (BOOL)[[response valueForHeader:header] isEqualToString:value];
    
  }, [NSString stringWithFormat:@"a response containing header {%@ => %@}", header, value]);
}

id<HCMatcher> hasCookie(NSString *key, NSString *value)
{
  return HC_passesBlock(^(id object) {
    if (![object isKindOfClass:[LRRestyResponse class]]) {
      return NO;
    }
    LRRestyResponse *response = object;
    
    return (BOOL)[[response valueForCookie:key] isEqualToString:value];
    
  }, [NSString stringWithFormat:@"a response containing cookie {%@ => %@}", key, value]);
}

id<HCMatcher> isCancelled(void)
{
  return HC_passesBlock(^(id object) {
    if (![object isKindOfClass:[LRRestyRequest class]]) {
      return NO;
    }
    LRRestyRequest *request = object;
    return ([request isFinished] && ![request isExecuting]);
    
  }, @"to be cancelled");
}
