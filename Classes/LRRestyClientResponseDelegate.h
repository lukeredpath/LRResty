//
//  LRRestClientDelegate.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRRestyClient;
@class LRRestyResponse;

@protocol LRRestyClientResponseDelegate <NSObject>

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response;

@end
