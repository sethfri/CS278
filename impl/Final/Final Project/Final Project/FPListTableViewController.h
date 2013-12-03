//
//  FPListTableViewController.h
//  Final Project
//
//  Created by Seth Friedman on 11/21/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPListTableViewControllerDelegate.h"

@interface FPListTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *items;
@property (weak, nonatomic) id<FPListTableViewControllerDelegate> delegate;

@end
