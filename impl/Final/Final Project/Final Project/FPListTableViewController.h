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

@property (nonatomic, copy) NSArray *annotations;
@property (weak, nonatomic) id<FPListTableViewControllerDelegate> delegate;

@end
