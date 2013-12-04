//
//  FPMapViewDelegate.h
//  Final Project
//
//  Created by Seth Friedman on 12/4/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;

@interface FPMapViewDelegate : NSObject <MKMapViewDelegate>

- (instancetype)initWithPinSelectedBlock:(void (^)(MKAnnotationView *annotationView))pinSelectedBlock;

+ (instancetype)mapViewDelegateWithPinSelectedBlock:(void (^)(MKAnnotationView *annotationView))pinSelectedBlock;

@end
