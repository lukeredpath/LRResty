//
//  NSObject+SynchronousProxy.h
//  LRResty
//
//  Created by Luke Redpath on 20/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRSynchronousProxy.h"

@interface NSObject (SynchronousProxy)

- (id)performAsynchronousBlockAndReturnResultWhenReady:(LRSynchronousProxyBlock)block;

@end
