//
//  LRRestyClient.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClientDelegate.h"

@interface LRRestyClient : NSObject {
  NSOperationQueue *operationQueue;
}
- (void)get:(NSString *)urlString delegate:(id<LRRestyClientDelegate>)delegate;
- (void)get:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<LRRestyClientDelegate>)delegate;
- (void)getURL:(NSURL *)url parameters:(NSDictionary *)parameters delegate:(id<LRRestyClientDelegate>)delegate;
@end
