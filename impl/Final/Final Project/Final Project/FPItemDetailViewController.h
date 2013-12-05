//
//  FPItemDetailViewController.h
//  Final Project
//
//  Created by Seth Friedman on 11/21/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPItemDetailDelegate.h"

@class FPPointAnnotation;

@interface FPItemDetailViewController : UIViewController

@property (strong, nonatomic) FPPointAnnotation *annotation;
@property (weak, nonatomic) id<FPItemDetailDelegate> delegate;

@end
