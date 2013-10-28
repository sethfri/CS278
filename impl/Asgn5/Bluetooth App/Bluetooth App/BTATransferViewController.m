//
//  BTAViewController.m
//  Bluetooth App
//
//  Created by Seth Friedman on 10/27/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "BTATransferViewController.h"

#import "BTACentralManagerDelegate.h"

@interface BTATransferViewController ()

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) BTACentralManagerDelegate *centralManagerDelegate;
@property (strong, nonatomic) CBUUID *serviceUUID;
@property (strong, nonatomic) CBUUID *characteristicUUID;

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBCharacteristic *imageCharacteristic;

@end

@implementation BTATransferViewController

#pragma mark - Custom Getter

- (BTACentralManagerDelegate *)centralManagerDelegate {
    if (!_centralManagerDelegate) {
        _centralManagerDelegate = [BTACentralManagerDelegate centralManagerDelegateWithPeripheralDelegate:self
                                                                                           andServiceUUID:self.serviceUUID];
    }
    
    return _centralManagerDelegate;
}

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

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self.centralManagerDelegate
                                                               queue:nil
                                                             options:nil];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
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
    // Get the photo
    
    NSData *imageData = nil;
    
    // Possibly need to set the value to nil since it may change ("Build Your Tree of Services and Characteristics")
    CBMutableCharacteristic *imageCharacteristic = [[CBMutableCharacteristic alloc] initWithType:self.characteristicUUID
                                                                                      properties:CBCharacteristicPropertyRead
                                                                                           value:imageData
                                                                                     permissions:CBAttributePermissionsReadable];
    self.imageCharacteristic = imageCharacteristic;
    CBMutableService *imageService = [[CBMutableService alloc] initWithType:self.serviceUUID
                                                                    primary:YES];
    imageService.characteristics = @[imageCharacteristic];
    
    [self.peripheralManager addService:imageService];
}

- (IBAction)receivePhotoTapped:(UIButton *)sender {
    [self.centralManager scanForPeripheralsWithServices:@[self.serviceUUID]
                                                options:nil];
}

#pragma mark - Peripheral Delegate

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
    [self.centralManager cancelPeripheralConnection:peripheral];
    
    NSData *imageData = characteristic.value;
    UIImage *image = [UIImage imageWithData:imageData];
    // Do something with the image.
}

#pragma mark - Peripheral Manager Delegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch (peripheral.state) {
        case CBPeripheralManagerStateUnsupported: {
            UIAlertView *unsupportedAlertView = [[UIAlertView alloc] initWithTitle:@"Bluetooth Unsupported"
                                                                           message:@"Bluetooth is not supported on this device."
                                                                          delegate:self
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil];
            [unsupportedAlertView show];
            break;
        }
            
        case CBPeripheralManagerStateUnauthorized: {
            UIAlertView *unauthorizedAlertView = [[UIAlertView alloc] initWithTitle:@"Bluetooth Unauthorized"
                                                                            message:@"Bluetooth App is not authorized to use this device's Bluetooth. Please visit Settings and make sure that it is authorized."
                                                                           delegate:self
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
            [unauthorizedAlertView show];
            break;
        }
            
        case CBPeripheralManagerStatePoweredOff: {
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

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"Error publishing service: %@", error);
    } else {
        [peripheral startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey: @[service.UUID] }];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    if (error) {
        NSLog(@"Error advertising service: %@", error);
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    if ([request.characteristic.UUID isEqual:self.imageCharacteristic.UUID]) {
        if (request.offset > [self.imageCharacteristic.value length]) {
            [peripheral respondToRequest:request
                              withResult:CBATTErrorInvalidOffset];
        } else {
            request.value = [self.imageCharacteristic.value subdataWithRange:NSMakeRange(request.offset, [self.imageCharacteristic.value length] - request.offset)];
            [peripheral respondToRequest:request
                              withResult:CBATTErrorSuccess];
        }
    }
}

@end
