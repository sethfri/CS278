//
//  FPViewController.m
//  Final Project
//
//  Created by Seth Friedman on 11/21/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "FPMapViewController.h"

@import MapKit;

@interface FPMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL mapHasBeenCenteredAroundUser;

@end

@implementation FPMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapHasBeenCenteredAroundUser = NO;
    
    MKPointAnnotation *firstAnnotation = [[MKPointAnnotation alloc] init];
    firstAnnotation.coordinate = CLLocationCoordinate2DMake(36.139483, -86.8331);
    MKPinAnnotationView *firstPin = [[MKPinAnnotationView alloc] initWithAnnotation:firstAnnotation
                                                                    reuseIdentifier:@"PinAnnotation"];
    
    MKPointAnnotation *secondAnnotation = [[MKPointAnnotation alloc] init];
    secondAnnotation.coordinate = CLLocationCoordinate2DMake(36.157233, -86.795583);
    MKPinAnnotationView *secondPin = [[MKPinAnnotationView alloc] initWithAnnotation:secondAnnotation
                                                                    reuseIdentifier:@"PinAnnotation"];
    
    MKPointAnnotation *thirdAnnotation = [[MKPointAnnotation alloc] init];
    thirdAnnotation.coordinate = CLLocationCoordinate2DMake(36.133533, -86.760833);
    MKPinAnnotationView *thirdPin = [[MKPinAnnotationView alloc] initWithAnnotation:thirdAnnotation
                                                                    reuseIdentifier:@"PinAnnotation"];
    
    MKPointAnnotation *fourthAnnotation = [[MKPointAnnotation alloc] init];
    fourthAnnotation.coordinate = CLLocationCoordinate2DMake(36.11155, -86.7973);
    MKPinAnnotationView *fourthPin = [[MKPinAnnotationView alloc] initWithAnnotation:fourthAnnotation
                                                                    reuseIdentifier:@"PinAnnotation"];
    
    [self.mapView addAnnotations:@[firstPin,
                                   secondPin,
                                   thirdPin,
                                   fourthPin]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Map View Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!self.mapHasBeenCenteredAroundUser) {
        CLLocationCoordinate2D userLocationCoordinate = userLocation.location.coordinate;
        MKCoordinateSpan regionSpan = MKCoordinateSpanMake(0.2, 0.2);
        
        MKCoordinateRegion region = MKCoordinateRegionMake(userLocationCoordinate, regionSpan);
        self.mapView.region = region;
        
        self.mapHasBeenCenteredAroundUser = YES;
    }
}

@end
