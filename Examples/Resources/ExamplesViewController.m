//
//  ExamplesViewController.m
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "ExamplesViewController.h"
#import "RemoteRepositoryExample.h"
#import "LRResty.h"

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
    rootResource = [[LRResty authenticatedResource:@"http://github.com/api/v2/json" username:@"lukeredpath/token" password:@"a4ca1fb79a14ec42b77097794a3572b"] retain];
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
  return 1;
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
      cell.textLabel.text = @"Repository Example";
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
      [self doRepositoryExample];
      break;
    default:
      break;
  }
}

- (void)doRepositoryExample
{
  GithubUserRepository *repository = [[GithubUserRepository alloc] initWithRemoteResource:self.rootResource];
  
  [repository getUserWithUsername:@"lukeredpath" andYield:^(GithubUser *user) {
    NSLog(@"Got user from repository %@", user);
  }];
}

@end

