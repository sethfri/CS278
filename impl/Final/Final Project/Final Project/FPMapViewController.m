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
        MKCoordinateSpan regionSpan = MKCoordinateSpanMake(0.5, 0.5);
        
        MKCoordinateRegion region = MKCoordinateRegionMake(userLocationCoordinate, regionSpan);
        self.mapView.region = region;
        
        self.mapHasBeenCenteredAroundUser = YES;
    }
}

@end
