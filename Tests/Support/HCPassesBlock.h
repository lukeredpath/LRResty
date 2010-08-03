//
//  HCPassesBlock.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCBaseMatcher.h"

typedef BOOL (^HCPassesBlockBlock)(id object);

@interface HCPassesBlock : HCBaseMatcher {
  HCPassesBlockBlock block;
  NSString *message;
}
+ (id)passesBlock:(HCPassesBlockBlock)block withMessage:(NSString *)message;
- (id)initWithBlock:(HCPassesBlockBlock)theBlock expectationMessage:(NSString *)expectationMessage;
@end

id<HCMatcher> HC_passesBlock(HCPassesBlockBlock theBlock, NSString *expectationMessage);

#ifdef HC_SHORTHAND
#define passesBlock(block, message) HC_passesBlock(block, message)
#endif

