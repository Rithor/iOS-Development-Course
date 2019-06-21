//
//  VAChooseDepartmentTVC.m
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 13/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VAChooseDepartmentTVC.h"

@interface VAChooseDepartmentTVC ()

@end

@implementation VAChooseDepartmentTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddButton:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    if (!self.departmentsArray) {
        self.departmentsArray = [NSMutableArray array];
    }
}

- (void)dealloc {
    NSLog(@"VAChooseDepartmentTVC dealloc");
}

#pragma mark - Actions

- (void)actionAddButton:(UIBarButtonItem *)sender {
    
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"New Department"
                                     message:@"Please enter name for new department"
                              preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    UIAlertAction *alertCanselAction = [UIAlertAction actionWithTitle:@"Cansel"
                                                                style:(UIAlertActionStyleCancel)
                                                              handler:nil];
    
    UIAlertAction *alertNewDepartmentAction = [UIAlertAction actionWithTitle:@"OK"
                                           style:(UIAlertActionStyleDefault)
                                         handler:^(UIAlertAction * _Nonnull action) {
         UITextField *newDepartmentNameTextField = [alertController.textFields objectAtIndex:0];
         NSString *newDepartmentString = newDepartmentNameTextField.text;
         [self.departmentsArray addObject:newDepartmentString];
         [self.tableView reloadData];
                                                                 }];
    [alertController addAction:alertNewDepartmentAction];
    [alertController addAction:alertCanselAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    for (UITableViewCell *cell in tableView.visibleCells) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    NSString *departmentString = cell.textLabel.text;
    
    [self.delegate didChooseDepartment:departmentString withIndexPath:indexPath];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(0.3f * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self.navigationController popViewControllerAnimated:YES];
                   });
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.departmentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentCell"
                                                            forIndexPath:indexPath];
    
    NSString *departmentString = [self.departmentsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = departmentString;
    
    if ([cell.textLabel.text isEqualToString:self.departmentString]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

@end
