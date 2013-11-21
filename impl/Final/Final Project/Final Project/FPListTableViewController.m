//
//  FPListTableViewController.m
//  Final Project
//
//  Created by Seth Friedman on 11/21/13.
//  Copyright (c) 2013 Seth Friedman. All rights reserved.
//

#import "FPListTableViewController.h"
#import "FPItem.h"

@interface FPListTableViewController ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation FPListTableViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    FPItem *item = self.items[indexPath.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:item.deadline];
    
    return cell;
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
