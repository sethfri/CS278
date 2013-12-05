//
//  FPMapViewDelegateTest.m
//  Final Project
//
//  Created by Seth Friedman on 12/5/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "FPMapViewDelegate.h"
#import "FPPointAnnotation.h"

@import MapKit;

@interface FPMapViewDelegateTest : XCTestCase

@end

@implementation FPMapViewDelegateTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testInitialization {
    __block MKAnnotationView *testAnnotationView;
    
    FPMapViewDelegate *mapViewDelegate = [[FPMapViewDelegate alloc] initWithPinSelectedBlock:^(MKAnnotationView *annotationView) {
        testAnnotationView = annotationView;
    }];
    
    XCTAssertNotNil(mapViewDelegate, @"Failed to initialize");
}

/*- (void)testDidUpdateUserLocation {
    id mockUserLocation = [OCMockObject mockForClass:[MKUserLocation class]];
    CLLocationCoordinate2D testCoordinate = CLLocationCoordinate2DMake(2.0, 2.0);
    [[[mockUserLocation expect] andReturnValue:testCoordinate] coordinate];
    
    MKMapView *mapView = [[MKMapView alloc] init];
    MKCoordinateRegion firstRegion = mapView.region;
    
    FPMapViewDelegate *mapViewDelegate = [[FPMapViewDelegate alloc] initWithPinSelectedBlock:nil];
    [mapViewDelegate mapView:mapView
       didUpdateUserLocation:mockUserLocation];
    
    XCTAssertEqual(mapView.region.center, testCoordinate, @"Should center the map around the testCoordinate");
    XCTAssertNotEqual(firstRegion, mapView.region, @"Should update the region from when the map is originally initialized");
    [mockUserLocation verify];
}*/

- (void)testDidSelectAnnotationView {
    // Test with an MKPinAnnotationView to make sure the block gets called
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:pointAnnotation
                                                                             reuseIdentifier:@"Pin"];
    
    __block MKAnnotationView *testAnnotationView;
    
    MKMapView *mapView = [[MKMapView alloc] init];
    FPMapViewDelegate *mapViewDelegate = [[FPMapViewDelegate alloc] initWithPinSelectedBlock:^(MKAnnotationView *annotationView) {
        testAnnotationView = annotationView;
    }];
    
    [mapViewDelegate mapView:mapView
     didSelectAnnotationView:pinAnnotationView];
    
    XCTAssertEqual(pinAnnotationView, testAnnotationView, @"Pin selected block should get called for a pin");
    
    // Test with something other than an MKPinAnnotationView to make sure the block is not called
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:pointAnnotation
                                                                    reuseIdentifier:@"NonPin"];
    
    [mapViewDelegate mapView:mapView
     didSelectAnnotationView:annotationView];
    
    XCTAssertNotEqual(annotationView, testAnnotationView, @"Pin selected block should not have been called for a non-pin");
}

- (void)testViewForAnnotation {
    FPPointAnnotation *pointAnnotation = [[FPPointAnnotation alloc] initWithTitle:@"title"
                                                                       coordinate:CLLocationCoordinate2DMake(0, 0)
                                                                         deadline:[NSDate date]
                                                                       andDetails:@"details"];
    
    MKMapView *mapView = [[MKMapView alloc] init];
    FPMapViewDelegate *mapViewDelegate = [[FPMapViewDelegate alloc] initWithPinSelectedBlock:nil];
    
    MKAnnotationView *annotationView = [mapViewDelegate mapView:mapView
                                              viewForAnnotation:pointAnnotation];
    
    XCTAssertNotNil(annotationView, @"Annotation view should not be nil");
    XCTAssertTrue([annotationView isKindOfClass:[MKPinAnnotationView class]], @"Annotation view should be a pin");
}

@end
