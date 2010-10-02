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
/**
 Performs a POST request with a payload on URL with delegate response handling.
 @param urlString   The URL to request.
 @param payload     The object to POST.
 @param delegate    The response delegate.
 @returns The request object.
 @see LRRestyRequestPayload
 */
- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload delegate:(id<LRRestyClientResponseDelegate>)delegate;
/**
 Performs a POST request with a payload on URL with delegate response handling.
 @param urlString   The URL to request.
 @param delegate    The response delegate.
 @returns The request object.
 @see LRRestyRequestPayload
 */
- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyClientResponseDelegate>)delegate;
/**
 Performs a POST request with a payload on URL with block response handling.
 @param urlString   The URL to request.
 @param payload     The object to POST.
 @param block       The response block.
 @returns The request object.
 @see LRRestyRequestPayload
 */
- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload withBlock:(LRRestyResponseBlock)block;
/**
 Performs a POST request with a payload on URL with block response handling.
 @param urlString   The URL to request.
 @param block       The response block.
 @returns The request object.
 @see LRRestyRequestPayload
 */
- (LRRestyRequest *)post:(NSString *)urlString payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
@end
