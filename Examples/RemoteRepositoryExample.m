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

#define NULL_GITHUB_ID 0

@implementation GithubUser

@synthesize remoteID, username;
@synthesize fullName;
@synthesize followers;

- (id)initWithUsername:(NSString *)theUsername;
{
  return [self initWithUsername:theUsername remoteID:NULL_GITHUB_ID];
}

- (id)initWithUsername:(NSString *)theUsername remoteID:(GithubID)theID;
{
  if (self = [super init]) {
    username = [theUsername copy];
    remoteID = theID;
    followers = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [followers release];
  [username release];
  [super dealloc];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"<GithubUser id:%d username:%@>", remoteID, username];
}

- (void)setFollowers:(NSArray *)replacementFollowers
{
  [followers removeAllObjects];
  [followers setArray:replacementFollowers];
}

@end

@interface RemoteResourceRepository ()
- (void)startRemoteOperation;
- (void)finishRemoteOperation;
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

- (void)startRemoteOperation
{
  if ([self.delegate respondsToSelector:@selector(repositoryDidStartRemoteOperation:)]) {
    [self.delegate repositoryDidStartRemoteOperation:self];
  }
}

- (void)finishRemoteOperation
{
  if ([self.delegate respondsToSelector:@selector(repositoryDidFinishRemoteOperation:)]) {
    [self.delegate repositoryDidFinishRemoteOperation:self];
  }
}

@end

@implementation GithubUserRepository

GithubID userIDFromString(NSString *userIDString);

GithubID userIDFromString(NSString *userIDString)
{
  // for some reason the search API returns IDs as user-xxxx
  return [[[userIDString componentsSeparatedByString:@"-"] lastObject] integerValue];
}

- (void)getUserWithUsername:(NSString *)username 
        andYield:(GithubUserRepositoryResultBlock)resultBlock;
{
  [self startRemoteOperation];
  
  [[resource at:[NSString stringWithFormat:@"user/show/%@", username]] get:^(LRRestyResponse *response, LRRestyResource *userResource) {
    NSDictionary *userData = [[response asJSONObject] objectForKey:@"user"];
    
    GithubUser *user = [[GithubUser alloc] initWithUsername:[userData objectForKey:@"login"] remoteID:[[userData objectForKey:@"id"] integerValue]];
    user.fullName = [userData objectForKey:@"name"];
    
    [[userResource at:@"followers"] get:^(LRRestyResponse *response, LRRestyResource *followersResource) {
      [user setFollowers:[[response asJSONObject] objectForKey:@"users"]];
      resultBlock(user);

      [user release];
      [self finishRemoteOperation];
    }];
  }];
}

- (void)getUsersMatching:(NSString *)searchString
        andYield:(RepositoryCollectionResultBlock)resultBlock;
{
  [self startRemoteOperation];

  [[resource at:[NSString stringWithFormat:@"user/search/%@", searchString]] get:^(LRRestyResponse *response, LRRestyResource *userResource) {
    NSMutableArray *users = [NSMutableArray array];
    for (NSDictionary *userData in [[response asJSONObject] objectForKey:@"users"]) {
      GithubUser *user = [[GithubUser alloc] initWithUsername:[userData objectForKey:@"username"] remoteID:userIDFromString([userData objectForKey:@"id"])];
      user.fullName = [userData objectForKey:@"fullname"];
      [users addObject:user];

      [user release];
      [self finishRemoteOperation];
    }
    resultBlock(users);
  }];
}

@end

