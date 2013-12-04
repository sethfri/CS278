//
//  FPViewController.m
//  Final Project
//
//  Created by Seth Friedman on 11/21/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "FPMapViewController.h"
#import "FPPointAnnotation.h"
#import "FPItemDetailViewController.h"
#import "FPListTableViewControllerDelegate.h"

@import MapKit;

@interface FPMapViewController () <MKMapViewDelegate, FPListTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSArray *annotations;

@end

@implementation FPMapViewController

#pragma mark - Custom Getter

- (NSArray *)annotations {
    if (!_annotations) {
        _annotations = @[[FPPointAnnotation pointAnnotationWithTitle:@"Install Internet"
                                                          coordinate:CLLocationCoordinate2DMake(36.139483, -86.8331)
                                                            deadline:[NSDate dateWithTimeIntervalSinceNow:(3.5 * 60 * 60)]
                                                          andDetails:@"Install cable box and router at M. King's house."],
                         [FPPointAnnotation pointAnnotationWithTitle:@"Install Television"
                                                          coordinate:CLLocationCoordinate2DMake(36.157233, -86.795583)
                                                            deadline:[NSDate dateWithTimeIntervalSinceNow:(5 * 60 * 60)]
                                                          andDetails:@"A. Brown's house. Needs tv receiver box. Wiring may be necessary."],
                         [FPPointAnnotation pointAnnotationWithTitle:@"Examine Switch Box"
                                                          coordinate:CLLocationCoordinate2DMake(36.133533, -86.760833)
                                                            deadline:[NSDate dateWithTimeIntervalSinceNow:(8.25 * 60 * 60)]
                                                          andDetails:@"Several residents at 1901 18th Ave. S report intermittent outages. Test switching box to ensure problem is further up the line."]];
    }
    
    return _annotations;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView addAnnotations:self.annotations];
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
        id destinationViewController = [destinationNavigationController.viewControllers firstObject];
        
        [destinationViewController setAnnotations:self.annotations];
        [destinationViewController setDelegate:self];
    } else if ([segue.identifier isEqualToString:@"PushItemDetail"]) {
        MKPinAnnotationView *selectedView = sender;
        FPPointAnnotation *selectedAnnotation = selectedView.annotation;
        
        FPItemDetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.annotation = selectedAnnotation;
    }
}

- (IBAction)listTableViewControllerDone:(UIStoryboardSegue *)segue {}

- (IBAction)listTableViewControllerSelected:(UIStoryboardSegue *)segue {}

#pragma mark - Map View Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CLLocationCoordinate2D userLocationCoordinate = userLocation.location.coordinate;
        MKCoordinateSpan regionSpan = MKCoordinateSpanMake(0.2, 0.2);
        
        MKCoordinateRegion region = MKCoordinateRegionMake(userLocationCoordinate, regionSpan);
        self.mapView.region = region;
    });
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view isKindOfClass:[MKPinAnnotationView class]]) {
        [self performSegueWithIdentifier:@"PushItemDetail"
                                  sender:view];
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

#pragma mark - List Table View Controller Delegate

- (void)listTableViewController:(FPListTableViewController *)listTableViewController didSelectAnnotation:(FPPointAnnotation *)annotation {
    CLLocationCoordinate2D itemCoordinate = annotation.coordinate;
    MKCoordinateSpan regionSpan = MKCoordinateSpanMake(0.2, 0.2);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(itemCoordinate, regionSpan);
    self.mapView.region = region;
}

@end
