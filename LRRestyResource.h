//
//  LRRestyResource.h
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClient.h"

@interface LRRestyResource : NSObject {
  LRRestyClient *restClient;
  NSURL *URL;
}
- (id)initWithRestClient:(LRRestyClient *)theClient URL:(NSURL *)aURL;
- (LRRestyResource *)at:(NSString *)path;
- (void)get:(LRRestyResponseBlock)responseBlock;
@end
