//
//  FPViewController.m
//  Final Project
//
//  Created by Seth Friedman on 11/21/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "FPMapViewController.h"
#import "FPItem.h"

@import MapKit;

@interface FPMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL mapHasBeenCenteredAroundUser;

@property (strong, nonatomic) NSArray *items;

@end

@implementation FPMapViewController

#pragma mark - Custom Getter

- (NSArray *)items {
    if (!_items) {
        _items = @[[FPItem itemWithName:@"Install Internet"
                               deadline:[NSDate dateWithTimeIntervalSinceNow:(3.5 * 60 * 60)]
                               location:CLLocationCoordinate2DMake(36.139483, -86.8331)
                             andDetails:@"Install cable box and router at M. King's house."],
                   [FPItem itemWithName:@"Install Television"
                               deadline:[NSDate dateWithTimeIntervalSinceNow:(5 * 60 * 60)]
                               location:CLLocationCoordinate2DMake(36.157233, -86.795583)
                             andDetails:@"A. Brown's house. Needs tv receiver box. Wiring may be necessary."],
                   [FPItem itemWithName:@"Examine Switch Box"
                               deadline:[NSDate dateWithTimeIntervalSinceNow:(8.25 * 60 * 60)]
                               location:CLLocationCoordinate2DMake(36.133533, -86.760833)
                             andDetails:@"Several residents at 1901 18th Ave. S report intermittent outages. Test switching box to ensure problem is further up the line."]];
    }
    
    return _items;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapHasBeenCenteredAroundUser = NO;
    
    NSMutableArray *pins = [NSMutableArray arrayWithCapacity:[self.items count]];
    
    for (FPItem *item in self.items) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = item.location;
        MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                   reuseIdentifier:@"PinAnnotation"];
        
        [pins addObject:pin];
    }
    
    [self.mapView addAnnotations:[pins copy]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PresentList"]) {
        UINavigationController *destinationNavigationController = segue.destinationViewController;
        [[destinationNavigationController.viewControllers firstObject] setItems:self.items];
    }
}

- (IBAction)listTableViewControllerDidFinish:(UIStoryboardSegue *)segue {}

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
