//
//  LRRestyResource.h
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClient.h"
#import "LRRestyResourceDelegate.h"
#import "LRRestyTypes.h"

typedef void (^LRRestyResourceResponseBlock)(LRRestyResponse *response, LRRestyResource *resource);

@interface LRRestyResource : NSObject <LRRestyClientDelegate> {
  LRRestyResource *parentResource;
  LRRestyClient *restClient;
  NSURL *URL;
  id<LRRestyResourceDelegate> delegate;
}
@property (nonatomic, assign) id<LRRestyResourceDelegate> delegate;
@property (nonatomic, readonly) NSURL *URL;

- (id)initWithRestClient:(LRRestyClient *)theClient URL:(NSURL *)aURL;
- (id)initWithRestClient:(LRRestyClient *)theClient URL:(NSURL *)aURL parent:(LRRestyResource *)parent;
- (LRRestyResource *)root;
- (LRRestyResource *)at:(NSString *)path;
- (LRRestyResource *)on:(NSString *)host;
- (LRRestyResource *)on:(NSString *)host secure:(BOOL)isSecure;
- (LRRestyResource *)withoutPathExtension;
- (LRRestyRequest *)get:(LRRestyResourceResponseBlock)responseBlock;
- (void)post:(LRRestyResourceResponseBlock)responseBlock;
- (void)post:(id)payload callback:(LRRestyResourceResponseBlock)responseBlock;
@end

@interface LRRestyResource (Streaming)
- (LRRestyRequest *)getStream:(LRRestyStreamingDataBlock)dataHandler onError:(LRRestyStreamingErrorBlock)errorHandler;
@end
