//
//  FPPointAnnotation.m
//  Final Project
//
//  Created by Seth Friedman on 12/4/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "FPPointAnnotation.h"

@implementation FPPointAnnotation

- (instancetype)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate deadline:(NSDate *)deadline andDetails:(NSString *)details {
    self = [super init];
    
    if (self) {
        _title = title;
        _coordinate = coordinate;
        _deadline = deadline;
        _details = details;
    }
    
    return self;
}

+ (instancetype)pointAnnotationWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate deadline:(NSDate *)deadline andDetails:(NSString *)details {
    return [[self alloc] initWithTitle:title
                            coordinate:coordinate
                              deadline:deadline
                            andDetails:details];
}

@end
