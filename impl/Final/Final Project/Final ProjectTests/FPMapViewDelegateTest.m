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

- (void)testDidUpdateUserLocation {
    id mockUserLocation = [OCMockObject mockForClass:[MKUserLocation class]];
    
    CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:2.0
                                                          longitude:2.0];
    
    [(MKUserLocation *)[[mockUserLocation expect] andReturn:testLocation] location];
    
    MKMapView *mapView = [[MKMapView alloc] init];
    MKCoordinateRegion firstRegion = mapView.region;
    MKCoordinateRegion secondRegion = MKCoordinateRegionMake(testLocation.coordinate, MKCoordinateSpanMake(3.0, 3.0));
    NSValue *secondRegionValue = [NSValue valueWithBytes:&secondRegion
                                                objCType:@encode(MKCoordinateRegion)];
    
    id mockMapView = [OCMockObject partialMockForObject:mapView];
    [[[mockMapView stub] andReturn:mockUserLocation] userLocation];
    [(MKMapView *)[[mockMapView stub] andReturnValue:secondRegionValue] region];
    
    FPMapViewDelegate *mapViewDelegate = [[FPMapViewDelegate alloc] initWithPinSelectedBlock:nil];
    mapView.delegate = mapViewDelegate;
    
    [mapViewDelegate mapView:mapView
       didUpdateUserLocation:mockUserLocation];
    
    XCTAssertEqual(((MKMapView *)mockMapView).region.center.latitude, testLocation.coordinate.latitude, @"Should center the map around the testCoordinate's latitude");
    XCTAssertEqual(((MKMapView *)mockMapView).region.center.longitude, testLocation.coordinate.longitude, @"Should center the map around the testCoordinate's longitude");
    XCTAssertFalse([self region:firstRegion isEqualToOtherRegion:((MKMapView *)mockMapView).region], @"Should update the region from when the map is originally initialized");
    //XCTAssertNotEqual(firstRegion, mapView.region, @"Should update the region from when the map is originally initialized");
    [mockUserLocation verify];
    [mockMapView verify];
}

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

#pragma mark - Helper Methods

- (BOOL)region:(MKCoordinateRegion)region isEqualToOtherRegion:(MKCoordinateRegion)otherRegion {
    CLLocationCoordinate2D center = region.center;
    CLLocationCoordinate2D otherCenter = otherRegion.center;
    
    MKCoordinateSpan span = region.span;
    MKCoordinateSpan otherSpan = otherRegion.span;
    
    return (center.latitude == otherCenter.latitude) && (center.longitude == otherCenter.longitude) && (span.latitudeDelta == otherSpan.latitudeDelta) && (span.longitudeDelta == otherSpan.longitudeDelta);
}

@end
