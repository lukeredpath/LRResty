//
//  NSOperation+Compatibility.h
//  LRResty
//
//  Created by Luke Redpath on 29/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSOperation (Compatibility)
- (void)setCompletionBlock:(void (^)(void))block;
@end
