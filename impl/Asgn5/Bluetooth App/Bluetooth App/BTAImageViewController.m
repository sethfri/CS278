//
//  BTAImageViewController.m
//  Bluetooth App
//
//  Created by Seth Friedman on 10/29/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "BTAImageViewController.h"

@interface BTAImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation BTAImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.imageView.image = self.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
