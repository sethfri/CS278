//
//  FPItem.h
//  Final Project
//
//  Created by Seth Friedman on 11/21/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface FPItem : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSDate *deadline;
@property (nonatomic, readonly) CLLocationCoordinate2D location;
@property (strong, nonatomic, readonly) NSString *details;

- (instancetype)initWithName:(NSString *)name deadline:(NSDate *)deadline location:(CLLocationCoordinate2D)location andDetails:(NSString *)details;

+ (instancetype)itemWithName:(NSString *)name deadline:(NSDate *)deadline location:(CLLocationCoordinate2D)location andDetails:(NSString *)details;

@end
