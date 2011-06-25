//
//  DomainMatchers.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCMatcher.h"

id<HCMatcher> responseWithStatus(NSUInteger status);
id<HCMatcher> responseWithStatusAndBody(NSUInteger status, NSString *body);
id<HCMatcher> responseWithStatusAndBodyMatching(NSUInteger status, id<HCMatcher>bodyMatcher);
id<HCMatcher> responseWithRequestEcho(NSString *keyPath, NSString *value);
id<HCMatcher> hasHeader(NSString *header, NSString *value);
id<HCMatcher> hasCookie(NSString *key, NSString *value);
id<HCMatcher> isCancelled(void);