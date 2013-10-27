//
//  BTAViewController.m
//  Bluetooth App
//
//  Created by Seth Friedman on 10/27/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "BTATransferViewController.h"

@interface BTATransferViewController ()

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBUUID *serviceUUID;
@property (strong, nonatomic) CBUUID *characteristicUUID;

@end

@implementation BTATransferViewController

#pragma mark - Custom Getter

- (CBUUID *)serviceUUID {
    if (!_serviceUUID) {
        _serviceUUID = [CBUUID UUIDWithString:@"0D3823F3-7DD5-4B51-A8AB-32AB50D3700C"];
    }
    
    return _serviceUUID;
}

- (CBUUID *)characteristicUUID {
    if (!_characteristicUUID) {
        // TODO - Get an actual characteistic UUID.
        _characteristicUUID = nil;
    }
    
    return _characteristicUUID;
}

#pragma mark - View Controller Lifecycle

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

#pragma mark - IB Actions

- (IBAction)sendPhotoTapped:(UIButton *)sender {
}

- (IBAction)receivePhotoTapped:(UIButton *)sender {
    [self.centralManager scanForPeripheralsWithServices:@[self.serviceUUID]
                                                options:nil];
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
    
    [self.centralManager stopScan];
    [self.centralManager connectPeripheral:peripheral
                                   options:nil];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    
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

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    // We know that the peripheral will only publish a single service
    CBService *imageService = peripheral.services[0];
    [peripheral discoverCharacteristics:@[self.characteristicUUID]
                             forService:imageService];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    // We know that there will only be one characteristic for the UUID searched for
    CBCharacteristic *imageCharacteristic = service.characteristics[0];
    [peripheral readValueForCharacteristic:imageCharacteristic];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSData *imageData = characteristic.value;
    UIImage *image = [UIImage imageWithData:imageData];
}

@end
