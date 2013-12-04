//
//  FPPointAnnotation.h
//  Final Project
//
//  Created by Seth Friedman on 12/4/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;

@interface FPPointAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic, readonly) NSDate *deadline;
@property (nonatomic, readonly, copy) NSString *details;

- (instancetype)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate deadline:(NSDate *)deadline andDetails:(NSString *)details;

+ (instancetype)pointAnnotationWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate deadline:(NSDate *)deadline andDetails:(NSString *)details;

@end
