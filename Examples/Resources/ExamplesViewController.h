//
//  ExamplesViewController.h
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteRepositoryExample.h"

@class GithubAPI;
@class GithubUserRepository;

@interface ExamplesViewController : UITableViewController <RemoteResourceRepositoryDelegate> {
  GithubAPI *github;
}
@property (nonatomic, readonly) GithubAPI *github;

- (void)doGetUserExample;
- (void)doSearchUserExample;
@end
