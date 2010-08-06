//
//  UsersViewController.h
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UsersViewController : UITableViewController {
  NSArray *users;
}
@property (nonatomic, retain) NSArray *users;
@end