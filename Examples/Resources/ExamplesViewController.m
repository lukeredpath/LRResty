//
//  ExamplesViewController.m
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "ExamplesViewController.h"
#import "LRResty.h"
#import "GithubCredentials.h"

NSString *githubUsername(NSString *user)
{
  return [NSString stringWithFormat:@"%@/token", user];
}

@implementation ExamplesViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.tableView.rowHeight = 70;
}

- (void)dealloc
{
  [super dealloc];
}

- (LRRestyResource *)rootResource
{
  if (rootResource == nil) {
    rootResource = [[LRResty authenticatedResource:@"http://github.com/api/v2/json" username:githubUsername(GITHUB_USERNAME) password:GITHUB_APIKEY] retain];
  }
  return rootResource;
}

#pragma mark UITableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
  }
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.detailTextLabel.numberOfLines = 2;
  
  switch (indexPath.row) {
    case 0:
      cell.textLabel.text = @"Get Github User";
      cell.detailTextLabel.text = @"An example of an asynchronous REST service-backed repository.";
      break;
    case 1:
      cell.textLabel.text = @"Search Github User";
      cell.detailTextLabel.text = @"An example of an asynchronous REST service-backed repository.";
      break;
    default:
      break;
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row) {
    case 0:
      [self doGetUserExample];
      break;
    case 1:
      [self doSearchUserExample];
    default:
      break;
  }
}

- (GithubUserRepository *)repository
{
  if (repository == nil) {
    repository = [[GithubUserRepository alloc] initWithRemoteResource:self.rootResource];
    repository.delegate = self;
  }  
  return repository;
}

- (void)doGetUserExample
{
  [[self repository] getUserWithUsername:@"lukeredpath" andYield:^(GithubUser *user) {
    NSLog(@"Got user from repository %@", user);
  }];
}

- (void)doSearchUserExample
{
  [[self repository] getUsersMatching:@"luke" andYield:^(NSArray *users) {
    NSLog(@"Got users matching 'luke' from repository %@", users);
  }];
}

#pragma mark RemoteResourceRepositoryDelegate methods

- (void)repositoryWillFetchFromResource:(RemoteResourceRepository *)repository
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)repositoryDidFetchFromResource:(RemoteResourceRepository *)repository
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end

