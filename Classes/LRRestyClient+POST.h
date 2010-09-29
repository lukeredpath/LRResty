//
//  LRRestyClient+POST.h
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient.h"

@class LRRestyRequest;

@interface LRRestyClient (POST)
- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload delegate:(id<LRRestyClientResponseDelegate>)delegate;
- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)delegate;
- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload withBlock:(LRRestyResponseBlock)block;
- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
@end
