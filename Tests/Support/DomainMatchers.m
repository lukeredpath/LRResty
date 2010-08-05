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
#import "OCHamcrest.h"
#import "HCStringDescription.h"

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
