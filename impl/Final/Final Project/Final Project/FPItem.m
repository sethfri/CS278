//
//  FPItem.m
//  Final Project
//
//  Created by Seth Friedman on 11/21/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "FPItem.h"

@implementation FPItem

- (instancetype)initWithName:(NSString *)name deadline:(NSDate *)deadline location:(CLLocationCoordinate2D)location andDetails:(NSString *)details {
    self = [super init];
    
    if (self) {
        _name = name;
        _deadline = deadline;
        _location = location;
        _details = details;
    }
    
    return self;
}

+ (instancetype)itemWithName:(NSString *)name deadline:(NSDate *)deadline location:(CLLocationCoordinate2D)location andDetails:(NSString *)details {
    return [[self alloc] initWithName:name
                             deadline:deadline
                             location:location
                           andDetails:details];
}

@end
