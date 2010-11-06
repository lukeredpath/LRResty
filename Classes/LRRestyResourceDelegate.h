//
//  LRRestyResourceDelegate.h
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRRestyResource;

@protocol LRRestyResourceDelegate <NSObject>
@optional
- (void)resourceWillPerformRequest:(LRRestyResource *)resource;
- (void)resourceDidPerformRequest:(LRRestyResource *)resource;
@end
