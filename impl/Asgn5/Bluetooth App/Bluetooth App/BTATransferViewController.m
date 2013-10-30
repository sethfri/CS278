//
//  BTAViewController.m
//  Bluetooth App
//
//  Created by Seth Friedman on 10/27/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "BTATransferViewController.h"

#import "BTACentralManagerDelegate.h"
#import "BTAImageViewController.h"

@interface BTATransferViewController () <UINavigationControllerDelegate>

@property (strong, nonatomic) BTACentralManagerDelegate *centralManagerDelegate;
@property (strong, nonatomic) CBUUID *serviceUUID;
@property (strong, nonatomic) CBUUID *characteristicUUID;

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBCharacteristic *imageCharacteristic;

@property (strong, nonatomic) UIImage *image;

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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PresentImage"]) {
        BTAImageViewController *imageViewController = segue.destinationViewController;
        imageViewController.image = self.image;
    }
}

#pragma mark - IB Actions

- (IBAction)sendPhotoTapped:(UIButton *)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController
                       animated:YES
                     completion:nil];
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
    self.image = [UIImage imageWithData:imageData];
    
    [self performSegueWithIdentifier:@"PresentImage"
                              sender:self];
}

#pragma mark - Peripheral Manager Delegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {}

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

#pragma mark - Image Picker Controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 // Possibly need to set the value to nil since it may change (See "Build Your Tree of Services and Characteristics")
                                 CBMutableCharacteristic *imageCharacteristic = [[CBMutableCharacteristic alloc] initWithType:self.characteristicUUID
                                                                                                                   properties:CBCharacteristicPropertyRead
                                                                                                                        value:imageData
                                                                                                                  permissions:CBAttributePermissionsReadable];
                                 self.imageCharacteristic = imageCharacteristic;
                                 CBMutableService *imageService = [[CBMutableService alloc] initWithType:self.serviceUUID
                                                                                                 primary:YES];
                                 imageService.characteristics = @[imageCharacteristic];
                                 
                                 [self.peripheralManager addService:imageService];
                             }];
}

@end
