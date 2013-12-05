//
//  FPTaskCreationDelegate.h
//  Final Project
//
//  Created by Seth Friedman on 12/5/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FPTaskCreationTableViewController;
@class FPPointAnnotation;

@protocol FPTaskCreationDelegate <NSObject>

- (void)taskCreationTableViewController:(FPTaskCreationTableViewController *)taskCreationTableViewController didCreatePointAnnotation:(FPPointAnnotation *)taskAnnotation;

@end
