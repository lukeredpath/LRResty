//
//  RemoteRepositoryExample.m
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "RemoteRepositoryExample.h"

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

@implementation GithubUserRepository

- (void)getUserWithUsername:(NSString *)username 
                   andYield:(GithubUserRepositoryResultBlock)resultBlock;
{
  GithubUser *user = [[GithubUser alloc] initWithUsername:username];
  resultBlock(user);
  [user release];
}

- (void)getUsersMatching:(NSString *)searchString
                andYield:(RepositoryCollectionResultBlock)resultBlock;
{
  
}

@end

