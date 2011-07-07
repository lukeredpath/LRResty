//
//  LRRestyHTTPClient.h
//  LRResty
//
//  Created by Luke Redpath on 29/09/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClientResponseDelegate.h"
#import "LRRestyRequestDelegate.h"

@class LRRestyRequest;
@protocol LRRestyHTTPClientDelegate;

@protocol LRRestyHTTPClient <NSObject>
@property (nonatomic, assign) id<LRRestyHTTPClientDelegate> delegate;
- (LRRestyRequest *)GET:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyRequestDelegate>)requestDelegate;
- (LRRestyRequest *)POST:(NSURL *)url payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyRequestDelegate>)requestDelegate;
- (LRRestyRequest *)PUT:(NSURL *)url payload:(id)payload headers:(NSDictionary *)headers delegate:(id<LRRestyRequestDelegate>)requestDelegate;
- (LRRestyRequest *)DELETE:(NSURL *)url headers:(NSDictionary *)headers delegate:(id<LRRestyRequestDelegate>)requestDelegate;
- (LRRestyRequest *)performRequest:(LRRestyRequest *)request;
- (void)cancelAllRequests;
@end

@protocol LRRestyHTTPClientDelegate <NSObject>
@optional
- (void)HTTPClient:(id<LRRestyHTTPClient>)client willPerformRequest:(LRRestyRequest *)request;
@end

@interface LRRestyHTTPClient : NSObject <LRRestyHTTPClient> 
{
  id<LRRestyHTTPClientDelegate> delegate;
  NSOperationQueue *operationQueue;
}
- (id)initWithDelegate:(id<LRRestyHTTPClientDelegate>)aDelegate;
@end
