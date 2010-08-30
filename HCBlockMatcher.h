//
//  HCBlockMatcher.h
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCBaseMatcher.h"

typedef BOOL (^HCBlockMatcherBlock)(id actual);

@interface HCBlockMatcher : HCBaseMatcher {
  HCBlockMatcherBlock block;
  NSString *description;
}
+ (id)matcherWithBlock:(HCBlockMatcherBlock)block description:(NSString *)aDescription;
- (id)initWithBlock:(HCBlockMatcherBlock)aBlock description:(NSString *)aDescription;;
@end

#ifdef __cplusplus
extern "C" {
#endif
  id<HCMatcher> HC_satisfiesBlock(NSString *description, HCBlockMatcherBlock block);  
#ifdef __cplusplus
}
#endif

#ifdef HC_SHORTHAND
#define satisfiesBlock HC_satisfiesBlock
#endif

