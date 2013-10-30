//
//  BTATransferViewControllerTests.m
//  Bluetooth App
//
//  Created by Seth Friedman on 10/29/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BTATransferViewController.h"
#import <OCMock/OCMock.h>

@interface BTATransferViewControllerTests : XCTestCase

@property (strong, nonatomic) BTATransferViewController *transferViewController;
@property (strong, nonatomic) CBUUID *serviceUUID;
@property (strong, nonatomic) CBUUID *characteristicUUID;

@end

@implementation BTATransferViewControllerTests

#pragma mark - Custom Getters

- (CBUUID *)serviceUUID {
    if (!_serviceUUID) {
        _serviceUUID = [CBUUID UUIDWithString:@"0D3823F3-7DD5-4B51-A8AB-32AB50D3700C"];
    }
    
    return _serviceUUID;
}

- (CBUUID *)characteristicUUID {
    if (!_characteristicUUID) {
        _characteristicUUID = [CBUUID UUIDWithString:@"0B51155F-C244-4A81-94F4-B411D830C06F"];
    }
    
    return _characteristicUUID;
}

- (void)setUp {
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.transferViewController = [storyboard instantiateInitialViewController];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testReceivePhoto {
    id mockCentralManager = [OCMockObject mockForClass:[CBCentralManager class]];
    [[mockCentralManager expect] scanForPeripheralsWithServices:@[self.serviceUUID]
                                                        options:nil];
    
    self.transferViewController.centralManager = mockCentralManager;
    
    [self.transferViewController receivePhotoTapped:self.transferViewController.receivePhotoButton];
    
    [mockCentralManager verify];
}

@end
