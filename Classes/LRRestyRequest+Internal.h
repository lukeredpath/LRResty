//
//  LRRestyRequest+Internal.h
//  LRResty
//
//  Created by Luke Redpath on 06/07/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyHTTPClient.h"

@interface LRRestyRequest ()

@property (nonatomic, assign, readwrite) NSUInteger numberOfRetries;
@property (nonatomic, assign) id<LRRestyHTTPClient> HTTPClient;

@end

@interface LRRestyRequest (RetrySupport)

- (id)initWithURLRequest:(NSMutableURLRequest *)request delegate:(id<LRRestyRequestDelegate>)theDelegate;

@end
