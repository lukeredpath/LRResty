//
//  RemoteRepositoryExample.m
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "RemoteRepositoryExample.h"
#import "LRResty.h"
#import "LRRestyResponse+JSON.h"

@implementation GithubUser

- (id)initWithUsername:(NSString *)theUsername;
{
  if (self = [super init]) {
    username = [theUsername copy];
  }
  return self;
}

- (id)initWithUsername:(NSString *)theUsername remoteID:(GithubID)theID;
{
  if (self = [super init]) {
    username = [theUsername copy];
    remoteID = theID;
  }
  return self;
}

- (void)dealloc
{
  [username release];
  [super dealloc];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"<GithubUser id:%d username:%@>", remoteID, username];
}

@end

@interface RemoteResourceRepository ()
- (void)willFetchFromResource;
- (void)didFetchFromResource;
@end

@implementation RemoteResourceRepository

@synthesize delegate;

- (id)initWithRemoteResource:(LRRestyResource *)aResource;
{
  if (self = [super init]) {
    resource = [aResource retain];
  }
  return self;
}

- (void)dealloc
{
  [resource release];
  [super dealloc];
}

- (void)willFetchFromResource;
{
  [self.delegate repositoryWillFetchFromResource:self];
}

- (void)didFetchFromResource;
{
  [self.delegate repositoryDidFetchFromResource:self];
}

@end

@implementation GithubUserRepository

GithubID userIDFromString(NSString *userIDString)
{
  // for some reason the search API returns IDs as user-xxxx
  return [[[userIDString componentsSeparatedByString:@"-"] lastObject] integerValue];
}

- (void)getUserWithUsername:(NSString *)username 
        andYield:(GithubUserRepositoryResultBlock)resultBlock;
{
  [self willFetchFromResource];
  
  [[resource at:[NSString stringWithFormat:@"user/show/%@", username]] get:^(LRRestyResponse *response) {
    [self didFetchFromResource];
    
    NSDictionary *userData = [[response asJSONObject] objectForKey:@"user"];
    GithubUser *user = [[GithubUser alloc] initWithUsername:[userData objectForKey:@"login"] remoteID:[[userData objectForKey:@"id"] integerValue]];
    resultBlock(user);
    [user release];
  }];
}

- (void)getUsersMatching:(NSString *)searchString
        andYield:(RepositoryCollectionResultBlock)resultBlock;
{
  [self willFetchFromResource];
  
  [[resource at:[NSString stringWithFormat:@"user/search/%@", searchString]] get:^(LRRestyResponse *response) {
    [self didFetchFromResource];

    NSMutableArray *users = [NSMutableArray array];
    for (NSDictionary *userData in [[response asJSONObject] objectForKey:@"users"]) {
      GithubUser *user = [[GithubUser alloc] initWithUsername:[userData objectForKey:@"username"] remoteID:userIDFromString([userData objectForKey:@"id"])];
      [users addObject:user];
      [user release];
    }
    resultBlock(users);
  }];
}

@end

