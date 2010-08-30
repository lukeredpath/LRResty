//
//  LRRestyStreamingClient.h
//  LRResty
//
//  Created by Luke Redpath on 30/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClientResponseDelegate.h"

@class LRRestyResponse;
@class LRRestyStreamingRequestHandler;

typedef void (^LRRestyStreamHandler)(LRRestyResponse *response, NSData *chunk, BOOL *cancel);

@interface LRRestyStreamingClient : NSObject {
  LRRestyClient *client;
  NSMutableArray *requestHandlers;
}
- (id)initWithClient:(LRRestyClient *)theClient;
- (void)get:(NSString *)path receive:(LRRestyStreamHandler)block;
- (void)requestFinished:(LRRestyStreamingRequestHandler *)handler;
@end

@interface LRRestyStreamingRequestHandler : NSObject <LRRestyClientResponseDelegate>
{
  LRRestyStreamHandler handler;
  LRRestyStreamingClient *client;
  BOOL shouldCancel;
}
- (id)initWithStreamingClient:(LRRestyStreamingClient *)streamingClient handler:(LRRestyStreamHandler)block;
@end
