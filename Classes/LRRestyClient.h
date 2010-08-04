//
//  LRRestyClient.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClientDelegate.h"

@class LRRestyResponse;

typedef void (^LRRestyResponseBlock)(LRRestyResponse *response);

@interface LRRestyClient : NSObject {
  NSOperationQueue *operationQueue;
}
- (void)getURL:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
- (void)postURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
- (void)putURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
@end

@interface LRRestyClient (Blocks)
- (void)getURL:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
- (void)postURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
- (void)putURL:(NSURL *)url data:(NSData *)postData headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
@end

@interface LRRestyClient (GET)
- (void)get:(NSString *)urlString delegate:(id<LRRestyClientDelegate>)delegate;
- (void)get:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<LRRestyClientDelegate>)delegate;
- (void)get:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
- (void)get:(NSString *)urlString withBlock:(LRRestyResponseBlock)block;
- (void)get:(NSString *)urlString parameters:(NSDictionary *)parameters withBlock:(LRRestyResponseBlock)block;
- (void)get:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
@end

@interface LRRestyClient (POST)
- (void)post:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<LRRestyClientDelegate>)delegate;
- (void)post:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
- (void)post:(NSString *)urlString data:(NSData *)postData delegate:(id<LRRestyClientDelegate>)delegate;
- (void)post:(NSString *)urlString data:(NSData *)postData headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
- (void)post:(NSString *)urlString parameters:(NSDictionary *)parameters withBlock:(LRRestyResponseBlock)block;
- (void)post:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
- (void)post:(NSString *)urlString data:(NSData *)postData withBlock:(LRRestyResponseBlock)block;
- (void)post:(NSString *)urlString data:(NSData *)postData headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
@end

@interface LRRestyClient (PUT)
- (void)put:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<LRRestyClientDelegate>)delegate;
- (void)put:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
- (void)put:(NSString *)urlString data:(NSData *)postData delegate:(id<LRRestyClientDelegate>)delegate;
- (void)put:(NSString *)urlString data:(NSData *)postData headers:(NSDictionary *)headers delegate:(id<LRRestyClientDelegate>)delegate;
- (void)put:(NSString *)urlString parameters:(NSDictionary *)parameters withBlock:(LRRestyResponseBlock)block;
- (void)put:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
- (void)put:(NSString *)urlString data:(NSData *)postData withBlock:(LRRestyResponseBlock)block;
- (void)put:(NSString *)urlString data:(NSData *)postData headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
@end

