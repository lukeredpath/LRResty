//
//  LRRestyClientProxyDelegate.h
//  LRResty
//
//  Created by Luke Redpath on 29/09/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyRequestDelegate.h"
#import "LRRestyClientResponseDelegate.h"

@class LRRestyClient;

@interface LRRestyClientProxyDelegate : NSObject <LRRestyRequestDelegate> {
  LRRestyClient *restyClient;
  id<LRRestyClientResponseDelegate> responseDelegate;
}
- (id)initWithClient:(LRRestyClient *)client responseDelegate:(id<LRRestyClientResponseDelegate>)delegate;
+ (id)proxyForClient:(LRRestyClient *)client responseDelegate:(id<LRRestyClientResponseDelegate>)delegate;
@end
