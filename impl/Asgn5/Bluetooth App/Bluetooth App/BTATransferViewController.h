//
//  BTAViewController.h
//  Bluetooth App
//
//  Created by Seth Friedman on 10/27/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CoreBluetooth;

@interface BTATransferViewController : UIViewController <CBPeripheralDelegate, CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;

@property (weak, nonatomic) IBOutlet UIButton *sendPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *receivePhotoButton;

- (IBAction)sendPhotoTapped:(UIButton *)sender;
- (IBAction)receivePhotoTapped:(UIButton *)sender;

@end
