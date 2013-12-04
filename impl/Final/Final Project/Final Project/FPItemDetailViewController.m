//
//  FPItemDetailViewController.m
//  Final Project
//
//  Created by Seth Friedman on 11/21/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "FPItemDetailViewController.h"
#import "FPPointAnnotation.h"

@interface FPItemDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation FPItemDetailViewController

#pragma mark - Custom Getter

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    return _dateFormatter;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = self.annotation.title;
    self.deadlineLabel.text = [self.dateFormatter stringFromDate:self.annotation.deadline];
    self.detailsLabel.text = self.annotation.details;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
