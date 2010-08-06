//
//  ExamplesViewController.h
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRRestyClient;

@interface ExamplesViewController : UITableViewController {
  LRRestyClient *restClient;
}
@property (nonatomic, readonly) LRRestyClient *restClient;

- (void)doRepositoryExample;
@end
