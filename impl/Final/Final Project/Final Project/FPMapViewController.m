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
#import "FPMapViewDelegate.h"
#import "FPTaskCreationTableViewControllerDelegate.h"
#import "FPTaskCreationTableViewController.h"
#import "FPItemDetailDelegate.h"

@import MapKit;

@interface FPMapViewController () <FPListTableViewControllerDelegate, FPItemDetailDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSMutableArray *annotations;
@property (strong, nonatomic) FPMapViewDelegate *mapViewDelegate;
@property (strong, nonatomic) FPTaskCreationTableViewControllerDelegate *taskCreationTableViewControllerDelegate;

@end

@implementation FPMapViewController

#pragma mark - Custom Getters

- (NSMutableArray *)annotations {
    if (!_annotations) {
        _annotations = [@[[FPPointAnnotation pointAnnotationWithTitle:@"Install Internet"
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
                                                           andDetails:@"Several residents at 1901 18th Ave. S report intermittent outages. Test switching box to ensure problem is further up the line."]] mutableCopy];
    }
    
    return _annotations;
}

- (FPMapViewDelegate *)mapViewDelegate {
    if (!_mapViewDelegate) {
        __weak typeof(self)weakSelf = self;
        
        _mapViewDelegate = [FPMapViewDelegate mapViewDelegateWithPinSelectedBlock:^(MKAnnotationView *annotationView) {
            [weakSelf performSegueWithIdentifier:@"PushItemDetail"
                                          sender:annotationView];
            [weakSelf.mapView deselectAnnotation:annotationView.annotation
                                        animated:NO];
        }];
    }
    
    return _mapViewDelegate;
}

- (FPTaskCreationTableViewControllerDelegate *)taskCreationTableViewControllerDelegate {
    if (!_taskCreationTableViewControllerDelegate) {
        __weak typeof(self)weakSelf = self;
        
        _taskCreationTableViewControllerDelegate = [FPTaskCreationTableViewControllerDelegate taskCreationTableViewControllerDelegateWithTaskCreatedBlock:^(FPPointAnnotation *taskAnnotation) {
            [weakSelf addNewTaskWithPointAnnotation:taskAnnotation];
        }];
    }
    
    return _taskCreationTableViewControllerDelegate;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self.mapViewDelegate;
    [self.mapView addAnnotations:[self.annotations copy]];
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
        detailViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"PresentTaskCreation"]) {
        UINavigationController *destinationNavigationController = segue.destinationViewController;
        FPTaskCreationTableViewController *destinationViewController = [destinationNavigationController.viewControllers firstObject];
        
        [destinationViewController setCoordinateForNewTask:self.mapView.userLocation.coordinate];
        [destinationViewController setDelegate:self.taskCreationTableViewControllerDelegate];
    }
}

- (IBAction)listTableViewControllerDone:(UIStoryboardSegue *)segue {}

- (IBAction)listTableViewControllerSelected:(UIStoryboardSegue *)segue {}

- (IBAction)taskCreationTableViewControllerDone:(UIStoryboardSegue *)segue {}

- (IBAction)itemDetailViewControllerComplete:(UIStoryboardSegue *)segue {}

#pragma mark - List Table View Controller Delegate

- (void)listTableViewController:(FPListTableViewController *)listTableViewController didSelectAnnotation:(FPPointAnnotation *)annotation {
    CLLocationCoordinate2D itemCoordinate = annotation.coordinate;
    MKCoordinateSpan regionSpan = MKCoordinateSpanMake(0.2, 0.2);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(itemCoordinate, regionSpan);
    self.mapView.region = region;
}

#pragma mark - Item Detail View Controller Delegate

- (void)itemDetailViewController:(FPItemDetailViewController *)itemDetailViewController didCompletePointAnnotation:(FPPointAnnotation *)pointAnnotation {
    [self.mapView removeAnnotation:pointAnnotation];
    [self.annotations removeObject:pointAnnotation];
}

#pragma mark - Helper Functions

- (void)addNewTaskWithPointAnnotation:(FPPointAnnotation *)pointAnnotation {
    [self.mapView addAnnotation:pointAnnotation];
    [self.annotations addObject:pointAnnotation];
}

@end
