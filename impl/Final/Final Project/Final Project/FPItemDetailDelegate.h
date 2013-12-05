//
//  FPItemDetailDelegate.h
//  Final Project
//
//  Created by Seth Friedman on 12/5/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FPItemDetailViewController;
@class FPPointAnnotation;

@protocol FPItemDetailDelegate <NSObject>

- (void)itemDetailViewController:(FPItemDetailViewController *)itemDetailViewController didCompletePointAnnotation:(FPPointAnnotation *)pointAnnotation;

@end
