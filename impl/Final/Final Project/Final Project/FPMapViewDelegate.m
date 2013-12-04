//
//  FPMapViewDelegate.m
//  Final Project
//
//  Created by Seth Friedman on 12/4/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "FPMapViewDelegate.h"
#import "FPPointAnnotation.h"

@interface FPMapViewDelegate ()

@property (nonatomic, copy) void (^pinSelectedBlock)(MKAnnotationView *view);

@end

@implementation FPMapViewDelegate

#pragma mark - Designated Initializer

- (instancetype)initWithPinSelectedBlock:(void (^)(MKAnnotationView *annotationView))pinSelectedBlock {
    self = [super init];
    
    if (self) {
        _pinSelectedBlock = pinSelectedBlock;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)mapViewDelegateWithPinSelectedBlock:(void (^)(MKAnnotationView *))pinSelectedBlock {
    return [[self alloc] initWithPinSelectedBlock:pinSelectedBlock];
}

#pragma mark - Map View Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CLLocationCoordinate2D userLocationCoordinate = userLocation.location.coordinate;
        MKCoordinateSpan regionSpan = MKCoordinateSpanMake(0.2, 0.2);
        
        MKCoordinateRegion region = MKCoordinateRegionMake(userLocationCoordinate, regionSpan);
        mapView.region = region;
    });
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view isKindOfClass:[MKPinAnnotationView class]]) {
        self.pinSelectedBlock(view);
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *reuseIdentifier = @"PinAnnotationView";
    
    MKAnnotationView *annotationView;
    
    if ([annotation isKindOfClass:[FPPointAnnotation class]]) {
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:reuseIdentifier];
        }
    }
    
    return annotationView;
}

@end
