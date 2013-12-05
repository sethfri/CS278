//
//  FPTaskCreationTableViewController.m
//  Final Project
//
//  Created by Seth Friedman on 12/5/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "FPTaskCreationTableViewController.h"

static NSInteger const kDeadlineSection = 1;

@interface FPTaskCreationTableViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *deadlineTableViewCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic) BOOL datePickerIsDisplayed;

@end

@implementation FPTaskCreationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datePickerIsDisplayed = NO;
    self.datePicker.minimumDate = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kDeadlineSection) {
        [self.tableView endEditing:YES];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1
                                                               inSection:kDeadlineSection]]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView deselectRowAtIndexPath:indexPath
                                 animated:YES];
    }
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 1;
    
    if (section == kDeadlineSection && self.deadlineTableViewCell.selected) {
        numberOfRows = 2;
        self.datePickerIsDisplayed = YES;
    }
    
    return numberOfRows;
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self removeDatePickerIfNecessary];
    
    return YES;
}

#pragma mark - Text View Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self removeDatePickerIfNecessary];
    
    return YES;
}

#pragma mark - Helper Methods

- (void)removeDatePickerIfNecessary {
    if (self.datePickerIsDisplayed) {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1
                                                                    inSection:kDeadlineSection]]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        self.datePickerIsDisplayed = NO;
    }
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

*/

@end
