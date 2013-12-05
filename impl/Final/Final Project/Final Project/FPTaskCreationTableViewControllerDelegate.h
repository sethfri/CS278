//
//  FPTaskCreationTableViewControllerDelegate.h
//  Final Project
//
//  Created by Seth Friedman on 12/5/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPTaskCreationDelegate.h"

@class FPPointAnnotation;

@interface FPTaskCreationTableViewControllerDelegate : NSObject <FPTaskCreationDelegate>

- (instancetype)initWithTaskCreatedBlock:(void (^)(FPPointAnnotation *taskAnnotation))taskCreatedBlock;

+ (instancetype)taskCreationTableViewControllerDelegateWithTaskCreatedBlock:(void (^)(FPPointAnnotation *taskAnnotation))taskCreatedBlock;

@end
