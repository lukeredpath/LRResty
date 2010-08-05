//
//  LRRestyClient+POST.h
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClient.h"

@interface LRRestyClient (POST)
- (void)post:(NSString *)urlString payload:(id)payload delegate:(id<LRRestyClientDelegate>)delegate;
- (void)post:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
- (void)post:(NSString *)urlString payload:(id)payload withBlock:(LRRestyResponseBlock)block;
- (void)post:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
@end
