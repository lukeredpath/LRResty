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

/** Only the request should be able to set this, it's read-only externally **/
@property (nonatomic, assign, readwrite) NSUInteger numberOfRetries;

/** Used as a back-reference to the client so the request can enqueue it's retry **/
@property (nonatomic, assign) id<LRRestyHTTPClient> HTTPClient;

@end

@interface LRRestyRequest (RetrySupport)

/** Used by a request to create a copy of itself for retrying **/
- (id)initWithURLRequest:(NSMutableURLRequest *)request delegate:(id<LRRestyRequestDelegate>)theDelegate;

@end
