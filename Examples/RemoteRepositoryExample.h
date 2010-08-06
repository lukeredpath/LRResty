//
//  RemoteRepositoryExample.h
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyResourceDelegate.h"

typedef NSUInteger GithubID;

@interface GithubUser : NSObject
{
  GithubID remoteID;
  NSString *username;
  NSString *fullName;
  NSMutableArray *followers;
}
@property (nonatomic, readonly) GithubID remoteID;
@property (nonatomic, readonly) NSString * username;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSArray *followers;

- (id)initWithUsername:(NSString *)theUsername;
- (id)initWithUsername:(NSString *)theUsername remoteID:(GithubID)theID;
@end

typedef void (^RepositoryCollectionResultBlock)(NSArray *collection);
typedef void (^GithubUserRepositoryResultBlock)(GithubUser *user);

@class RemoteResourceRepository;

@protocol RemoteResourceRepositoryDelegate <NSObject>
@optional
- (void)repositoryDidStartRemoteOperation:(RemoteResourceRepository *)repository;
- (void)repositoryDidFinishRemoteOperation:(RemoteResourceRepository *)repository;
@end

@class LRRestyResource;

@interface RemoteResourceRepository : NSObject <LRRestyResourceDelegate>
{
  LRRestyResource *resource;
  id<RemoteResourceRepositoryDelegate> delegate;
}
@property (nonatomic, assign) id<RemoteResourceRepositoryDelegate> delegate;

- (id)initWithRemoteResource:(LRRestyResource *)aResource;
@end

@interface GithubUserRepository : RemoteResourceRepository
{}

- (void)getUserWithUsername:(NSString *)username 
        andYield:(GithubUserRepositoryResultBlock)resultBlock;

- (void)getUsersMatching:(NSString *)searchString
        andYield:(RepositoryCollectionResultBlock)resultBlock;
@end
