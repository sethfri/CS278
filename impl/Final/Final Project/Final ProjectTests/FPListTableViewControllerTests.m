//
//  FPListTableViewControllerTests.m
//  Final Project
//
//  Created by Seth Friedman on 12/7/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "FPListTableViewController.h"
#import "FPListTableViewControllerDelegate.h"
#import "FPPointAnnotation.h"

@interface FPListTableViewControllerTests : XCTestCase

@end

@implementation FPListTableViewControllerTests

- (void)setUp {
    [super setUp];
}

- (void)testNumberOfRowsInSection {
    FPListTableViewController *listTableViewController = [[FPListTableViewController alloc] init];
    
    id mockListTableViewController = [OCMockObject partialMockForObject:listTableViewController];
    
    NSArray *testAnnotations = @[@"one", @"two", @"three"];
    id mockTestAnnotations = [OCMockObject partialMockForObject:testAnnotations];
    [[[mockTestAnnotations expect] andReturn:testAnnotations] sortedArrayUsingDescriptors:OCMOCK_ANY];
    
    [[[mockListTableViewController expect] andReturn:testAnnotations] annotations];
    
    NSUInteger numberOfRows = [listTableViewController tableView:listTableViewController.tableView
                                           numberOfRowsInSection:0];
    
    XCTAssertEqual(numberOfRows, [testAnnotations count], @"The number of rows should be equal to the number of annotations");
    [mockListTableViewController verify];
}

- (void)testDidSelectRowAtIndexPath {
    FPListTableViewController *listTableViewController = [[FPListTableViewController alloc] init];
    
    id mockListTableViewControllerDelegate = [OCMockObject mockForProtocol:@protocol(FPListTableViewControllerDelegate)];
    [[mockListTableViewControllerDelegate expect] listTableViewController:listTableViewController
                                                      didSelectAnnotation:OCMOCK_ANY];
    listTableViewController.delegate = mockListTableViewControllerDelegate;
    
    [listTableViewController tableView:listTableViewController.tableView
               didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                          inSection:0]];
    
    [mockListTableViewControllerDelegate verify];
}

@end
