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

id<HCMatcher> responseWithStatusAndBody(NSUInteger status, NSString *stringBody)
{
  return HC_passesBlock(^(id object) {
    if (![object isKindOfClass:[LRRestyResponse class]]) {
      return NO;
    }
    LRRestyResponse *response = object;
    return (BOOL)(response.status == status && [[response asString] isEqualToString:stringBody]);
    
  }, [NSString stringWithFormat:@"a %d response with body \"%@\"", status, stringBody]);
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
