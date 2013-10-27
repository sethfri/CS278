//
//  BTAViewController.m
//  Bluetooth App
//
//  Created by Seth Friedman on 10/27/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "BTAViewController.h"

@interface BTAViewController ()

@property (strong, nonatomic) CBCentralManager *centralManager;

@end

@implementation BTAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                               queue:nil
                                                             options:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Central Manager Delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStateUnsupported: {
            UIAlertView *unsupportedAlertView = [[UIAlertView alloc] initWithTitle:@"Bluetooth Unsupported"
                                                                           message:@"Bluetooth is not supported on this device."
                                                                          delegate:self
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil];
            [unsupportedAlertView show];
            break;
        }
            
        case CBCentralManagerStateUnauthorized: {
            UIAlertView *unauthorizedAlertView = [[UIAlertView alloc] initWithTitle:@"Bluetooth Unauthorized"
                                                                            message:@"Bluetooth App is not authorized to use this device's Bluetooth. Please visit Settings and make sure that it is authorized."
                                                                           delegate:self
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
            [unauthorizedAlertView show];
            break;
        }
            
        case CBCentralManagerStatePoweredOff: {
            UIAlertView *poweredOffAlertView = [[UIAlertView alloc] initWithTitle:@"Bluetooth Off"
                                                                          message:@"Bluetooth is currently powered off. Please open the Control Center and turn on Bluetooth."
                                                                         delegate:self
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
            [poweredOffAlertView show];
            break;
        }
            
        default:
            break;
    }
}

@end
