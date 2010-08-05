//
//  LRRestyRequest.h
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClientDelegate.h"
#import "LRRestyRequestPayload.h"

@class LRRestyClient;

@interface LRRestyRequest : NSOperation
{
  NSMutableURLRequest *URLRequest;
  LRRestyClient *client;
  id<LRRestyClientDelegate> delegate;
  BOOL _isExecuting;
  BOOL _isFinished;
  NSError *connectionError;
  NSMutableData *responseData;
  NSHTTPURLResponse *response;
}
@property (nonatomic, retain) NSHTTPURLResponse *response;
@property (nonatomic, retain) NSData *responseData;
@property (nonatomic, retain) NSError *connectionError;
@property (nonatomic, readonly) NSURL *URL;

- (id)initWithURL:(NSURL *)aURL method:(NSString *)httpMethod client:(LRRestyClient *)theClient delegate:(id<LRRestyClientDelegate>)theDelegate;
- (void)setExecuting:(BOOL)isExecuting;
- (void)setFinished:(BOOL)isFinished;
- (void)finish;
- (void)setQueryParameters:(NSDictionary *)parameters;
- (void)setHeaders:(NSDictionary *)headers;
- (void)addHeader:(NSString *)header value:(NSString *)value;
- (void)setPostData:(NSData *)data;
- (void)setPayload:(id<LRRestyRequestPayload>)thePayload;
@end
