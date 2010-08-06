//
//  UsersViewController.m
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "UsersViewController.h"
#import "RemoteRepositoryExample.h"

@implementation UsersViewController

@synthesize users;

#pragma mark -
#pragma mark Initialization

- (id)init
{
  return [super initWithStyle:UITableViewStylePlain];
}

- (void)dealloc
{
  [users release];
  [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
  [super viewDidLoad];

  self.tableView.rowHeight = 60;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
  return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
    
  GithubUser *user = [users objectAtIndex:indexPath.row];
  cell.textLabel.text = user.fullName;
  cell.detailTextLabel.text = [user description];
    
  return cell;
}

@end

