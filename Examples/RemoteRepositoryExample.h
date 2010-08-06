//
//  RemoteRepositoryExample.h
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSUInteger GithubID;

@interface GithubUser : NSObject
{
  GithubID remoteID;
  NSString *username;
}
- (id)initWithUsername:(NSString *)theUsername;
- (id)initWithUsername:(NSString *)theUsername remoteID:(GithubID)theID;
@end

typedef void (^RepositoryCollectionResultBlock)(NSArray *collection);
typedef void (^GithubUserRepositoryResultBlock)(GithubUser *user);

@class LRRestyClient;

@interface GithubUserRepository : NSObject
{
  LRRestyClient *restClient;
}
- (id)initWithRestClient:(LRRestyClient *)client;

- (void)getUserWithUsername:(NSString *)username 
        andYield:(GithubUserRepositoryResultBlock)resultBlock;

- (void)getUsersMatching:(NSString *)searchString
        andYield:(RepositoryCollectionResultBlock)resultBlock;
@end
