//
//  FPTaskCreationTableViewControllerDelegate.m
//  Final Project
//
//  Created by Seth Friedman on 12/5/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "FPTaskCreationTableViewControllerDelegate.h"
#import "FPPointAnnotation.h"

@interface FPTaskCreationTableViewControllerDelegate ()

@property (nonatomic, copy) void (^taskCreatedBlock)(FPPointAnnotation *taskAnnotation);

@end

@implementation FPTaskCreationTableViewControllerDelegate

#pragma mark - Designated Initializer

- (instancetype)initWithTaskCreatedBlock:(void (^)(FPPointAnnotation *))taskCreatedBlock {
    self = [super init];
    
    if (self) {
        _taskCreatedBlock = taskCreatedBlock;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)taskCreationTableViewControllerDelegateWithTaskCreatedBlock:(void (^)(FPPointAnnotation *))taskCreatedBlock {
    return [[self alloc] initWithTaskCreatedBlock:taskCreatedBlock];
}

#pragma mark - Task Creation Table View Controller Delegate

- (void)taskCreationTableViewController:(FPTaskCreationTableViewController *)taskCreationTableViewController didCreatePointAnnotation:(FPPointAnnotation *)taskAnnotation {
    self.taskCreatedBlock(taskAnnotation);
}

@end
