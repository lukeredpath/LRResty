//
//  LRRestyClient+PUT.h
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient.h"

@class LRRestyRequest;

@interface LRRestyClient (PUT)
- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload delegate:(id<LRRestyClientResponseDelegate>)delegate;
- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)delegate;
- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload withBlock:(LRRestyResponseBlock)block;
- (LRRestyRequest *)put:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
@end

