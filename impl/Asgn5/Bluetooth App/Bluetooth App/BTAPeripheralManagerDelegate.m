//
//  BTAPeripheralManagerDelegate.m
//  Bluetooth App
//
//  Created by Seth Friedman on 10/30/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "BTAPeripheralManagerDelegate.h"

@implementation BTAPeripheralManagerDelegate

#pragma mark - Designated Initializer

- (instancetype)initWithCharacteristic:(CBCharacteristic *)characteristic {
    self = [super init];
    
    if (self) {
        _characteristic = characteristic;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)peripheralManagerDelegateWithCharacteristic:(CBCharacteristic *)characteristic {
    return [[self alloc] initWithCharacteristic:characteristic];
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
    if ([request.characteristic.UUID isEqual:self.characteristic.UUID]) {
        if (request.offset > [self.characteristic.value length]) {
            [peripheral respondToRequest:request
                              withResult:CBATTErrorInvalidOffset];
        } else {
            request.value = [self.characteristic.value subdataWithRange:NSMakeRange(request.offset, [self.characteristic.value length] - request.offset)];
            [peripheral respondToRequest:request
                              withResult:CBATTErrorSuccess];
        }
    }
}

@end
