//
//  BTAPeripheralManagerDelegate.h
//  Bluetooth App
//
//  Created by Seth Friedman on 10/30/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreBluetooth;

@interface BTAPeripheralManagerDelegate : NSObject <CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBCharacteristic *characteristic;

- (instancetype)initWithCharacteristic:(CBCharacteristic *)characteristic;

+ (instancetype)peripheralManagerDelegateWithCharacteristic:(CBCharacteristic *)characteristic;

@end
