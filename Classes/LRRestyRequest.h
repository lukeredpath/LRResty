//
//  LRRestyRequest.h
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClientResponseDelegate.h"
#import "LRRestyRequestPayload.h"

@class LRRestyClient;
@class LRRestyResponse;

@protocol LRRestyRequestDelegate <NSObject>
- (void)restyRequest:(LRRestyRequest *)request didFinishWithResponse:(LRRestyResponse *)response;
@optional
- (void)restyRequestDidStart:(LRRestyRequest *)request;
- (void)restyRequest:(LRRestyRequest *)request didReceiveData:(NSData *)data;
@end

@interface LRRestyRequest : NSOperation
{
  NSMutableURLRequest *URLRequest;
  id<LRRestyRequestDelegate> delegate;
  BOOL _isExecuting;
  BOOL _isFinished;
  NSError *connectionError;
  NSMutableData *responseData;
  NSHTTPURLResponse *response;
  NSURLCredential *credential;
}
@property (nonatomic, retain) NSHTTPURLResponse *response;
@property (nonatomic, retain) NSData *responseData;
@property (nonatomic, retain) NSError *connectionError;
@property (nonatomic, readonly) NSURL *URL;

- (id)initWithURL:(NSURL *)aURL method:(NSString *)httpMethod delegate:(id<LRRestyRequestDelegate>)theDelegate;
- (void)setExecuting:(BOOL)isExecuting;
- (void)setFinished:(BOOL)isFinished;
- (void)finish;
- (void)setQueryParameters:(NSDictionary *)parameters;
- (void)setHeaders:(NSDictionary *)headers;
- (void)addHeader:(NSString *)header value:(NSString *)value;
- (void)setPostData:(NSData *)data;
- (void)setPayload:(id<LRRestyRequestPayload>)thePayload;
- (void)setHandlesCookiesAutomatically:(BOOL)shouldHandleCookies;
- (void)setBasicAuthUsername:(NSString *)username password:(NSString *)password useCredentialSystem:(BOOL)useCredential;
@end
