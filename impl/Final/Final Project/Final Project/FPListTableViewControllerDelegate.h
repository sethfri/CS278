//
//  FPListTableViewControllerDelegate.h
//  Final Project
//
//  Created by Seth Friedman on 11/21/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FPListTableViewController;
@class FPPointAnnotation;

@protocol FPListTableViewControllerDelegate <NSObject>

- (void)listTableViewController:(FPListTableViewController *)listTableViewController didSelectAnnotation:(FPPointAnnotation *)annotation;

@end
