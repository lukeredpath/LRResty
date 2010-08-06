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

@implementation GithubUserRepository

- (id)initWithRestClient:(LRRestyClient *)client;
{
  if (self = [super init]) {
    restClient = [client retain];
  }
  return self;
}

- (void)dealloc
{
  [restClient release];
  [super dealloc];
}

- (void)getUserWithUsername:(NSString *)username 
        andYield:(GithubUserRepositoryResultBlock)resultBlock;
{
  [restClient get:[NSString stringWithFormat:@"http://github.com/api/v2/json/user/show/%@", username] withBlock:^(LRRestyResponse *response) {
    NSDictionary *userData = [[response asJSONObject] objectForKey:@"user"];
    GithubUser *user = [[GithubUser alloc] initWithUsername:[userData objectForKey:@"login"] remoteID:[[userData objectForKey:@"id"] integerValue]];
    resultBlock(user);
    [user release];
  }];
}

- (void)getUsersMatching:(NSString *)searchString
        andYield:(RepositoryCollectionResultBlock)resultBlock;
{
  
}

@end

