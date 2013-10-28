//
//  BTACentralManagerDelegate.h
//  Bluetooth App
//
//  Created by Seth Friedman on 10/27/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreBluetooth;

@interface BTACentralManagerDelegate : NSObject <CBCentralManagerDelegate>

- (instancetype)initWithPeripheralDelegate:(id<CBPeripheralDelegate>)peripheralDelegate andServiceUUID:(CBUUID *)serviceUUID;

+ (instancetype)centralManagerDelegateWithPeripheralDelegate:(id<CBPeripheralDelegate>)peripheralDelegate andServiceUUID:(CBUUID *)serviceUUID;

@end
