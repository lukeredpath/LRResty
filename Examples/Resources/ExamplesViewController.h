//
//  ExamplesViewController.h
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteRepositoryExample.h"

@class LRRestyResource;
@class GithubUserRepository;

@interface ExamplesViewController : UITableViewController <RemoteResourceRepositoryDelegate> {
  LRRestyResource *rootResource;
  GithubUserRepository *repository;
}
@property (nonatomic, readonly) LRRestyResource *rootResource;

- (void)doRepositoryExample;
@end
