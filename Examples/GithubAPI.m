//
//  GithubAPI.m
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "GithubAPI.h"
#import "LRResty.h"

#define kGITHUB_API_ROOT_URL @"http://github.com/api/v2/json"

NSString *githubUsername(NSString *user);

NSString *githubUsername(NSString *user)
{
  return [NSString stringWithFormat:@"%@/token", user];
}

@implementation GithubAPI

+ (id)apiWithUsername:(NSString *)username key:(NSString *)apiKey;
{
  LRRestyResource *root = [LRResty authenticatedResource:kGITHUB_API_ROOT_URL username:githubUsername(username) password:apiKey];
  return [[[self alloc] initWithRoot:root] autorelease];
}

- (id)initWithRoot:(LRRestyResource *)rootResource;
{
  if (self = [super init]) {
    root = [rootResource retain];
  }
  return self;
}

- (void)dealloc
{
  [root release];
  [super dealloc];
}

- (GithubUserRepository *)users:(id<RemoteResourceRepositoryDelegate>)repositoryDelegate;
{
  if (userRepository == nil) {
    userRepository = [[GithubUserRepository alloc] initWithRemoteResource:root];
  }
  userRepository.delegate = repositoryDelegate;
  return userRepository;
}

@end
