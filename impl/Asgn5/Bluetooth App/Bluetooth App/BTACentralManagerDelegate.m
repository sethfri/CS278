//
//  BTACentralManagerDelegate.m
//  Bluetooth App
//
//  Created by Seth Friedman on 10/27/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "BTACentralManagerDelegate.h"

@interface BTACentralManagerDelegate ()

@property (strong, nonatomic) id<CBPeripheralDelegate> peripheralDelegate;
@property (strong, nonatomic) CBUUID *serviceUUID;

@end

@implementation BTACentralManagerDelegate

#pragma mark - NSObject

- (instancetype)initWithPeripheralDelegate:(id<CBPeripheralDelegate>)peripheralDelegate andServiceUUID:(CBUUID *)serviceUUID {
    self = [super init];
    
    if (self) {
        _peripheralDelegate = peripheralDelegate;
        _serviceUUID = serviceUUID;
    }
    
    return self;
}

+ (instancetype)centralManagerDelegateWithPeripheralDelegate:(id<CBPeripheralDelegate>)peripheralDelegate andServiceUUID:(CBUUID *)serviceUUID {
    return [[self alloc] initWithPeripheralDelegate:peripheralDelegate
                                     andServiceUUID:serviceUUID];
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

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    // There is only one possible peripheral we could have found, since this is not a mainstream app. So, we will use
    // the trivial implementation of stopping the search as soon as we've found a single peripheral advertising the
    // service UUID.
    
    [central stopScan];
    [central connectPeripheral:peripheral
                       options:nil];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self.peripheralDelegate;
    
    [peripheral discoverServices:@[self.serviceUUID]];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Error: %@", error);
    
    UIAlertView *failToConnectAlertView = [[UIAlertView alloc] initWithTitle:@"Failed to Connect"
                                                                     message:@"The app failed to connect with another device. Please try again."
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
    [failToConnectAlertView show];
}

@end
