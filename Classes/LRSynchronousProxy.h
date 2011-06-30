//
//  LRSynchronousProxy.h
//  LRResty
//
//  Created by Luke Redpath on 20/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LRSynchronousProxyBlock)(__strong id *);

@interface LRSynchronousProxy : NSObject {

}
+ (id)performAsynchronousBlockAndReturnResultWhenReady:(LRSynchronousProxyBlock)block;
@end
