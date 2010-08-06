//
//  GithubAPI.h
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteRepositoryExample.h"

@class LRRestyResource;
@class GithubUserRepository;

@interface GithubAPI : NSObject {
  LRRestyResource *root;
  GithubUserRepository *userRepository;
}
+ (id)apiWithUsername:(NSString *)username key:(NSString *)apiKey;
- (id)initWithRoot:(LRRestyResource *)rootResource;
- (GithubUserRepository *)users:(id<RemoteResourceRepositoryDelegate>)repositoryDelegate;
@end
