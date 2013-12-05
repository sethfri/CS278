//
//  FPTaskCreationTableViewController.h
//  Final Project
//
//  Created by Seth Friedman on 12/5/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPTaskCreationDelegate.h"

@import CoreLocation;

@interface FPTaskCreationTableViewController : UITableViewController

@property (nonatomic) CLLocationCoordinate2D coordinateForNewTask;

@property (weak, nonatomic) id<FPTaskCreationDelegate> delegate;

@end
