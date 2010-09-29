//
//  LRRestyClient.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClientResponseDelegate.h"
#import "LRRestyClientDelegate.h"
#import "LRRestyTypes.h"
#import "LRRestyHTTPClient.h"

@class LRRestyResponse;
@class LRRestyRequest;

typedef void (^LRRestyResponseBlock)(LRRestyResponse *response);
typedef void (^LRRestyRequestBlock)(LRRestyRequest *request);

@interface LRRestyClient : NSObject <LRRestyHTTPClientDelegate>
{
  id<LRRestyHTTPClient> HTTPClient;
  NSMutableArray *requestModifiers;
  id<LRRestyClientDelegate> clientDelegate;
}
@property (nonatomic, assign) id<LRRestyClientDelegate> delegate;


- (void)setHandlesCookiesAutomatically:(BOOL)shouldHandleCookies;
- (NSInteger)attachRequestModifier:(LRRestyRequestBlock)block;
- (void)removeRequestModifierAtIndex:(NSInteger)index;
- (void)setUsername:(NSString *)username password:(NSString *)password;
@end

@interface LRRestyClient (Blocks)
- (LRRestyRequest *)getURL:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
- (void)postURL:(NSURL *)url payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
- (void)putURL:(NSURL *)url payload:(id)payload headers:(NSDictionary *)headers withBlock:(LRRestyResponseBlock)block;
@end

@interface LRRestyClient (Streaming)
- (LRRestyRequest *)getURL:(NSURL *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers 
        onData:(LRRestyStreamingDataBlock)dataHandler onError:(LRRestyStreamingErrorBlock)errorHandler;
@end
