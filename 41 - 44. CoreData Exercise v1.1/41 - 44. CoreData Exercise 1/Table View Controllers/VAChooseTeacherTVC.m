//
//  VAChooseTeacherTVC.m
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 13/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VAChooseTeacherTVC.h"

@interface VAChooseTeacherTVC ()

@end

@implementation VAChooseTeacherTVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.userIsTeacherAtIndexPath) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.userIsTeacherAtIndexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)dealloc {
    NSLog(@"VAChooseTeacherTVC dealloc");
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    for (UITableViewCell *cell in tableView.visibleCells) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.delegate didChooseTeacher:user withIndexPath:indexPath];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(0.3f * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)configureCell:(UITableViewCell *)cell withUser:(User *)user {
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    cell.detailTextLabel.text = user.email;
    
    if ([user isEqual:self.user]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([user.courses containsObject:self.course]) {
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.f];
        cell.detailTextLabel.text = @"The user is studying this course";
        cell.userInteractionEnabled = NO;
    }
}

@end
