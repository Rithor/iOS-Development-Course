//
//  VAChooseStudentTVC.m
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 14/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VAChooseStudentTVC.h"

@interface VAChooseStudentTVC ()

@end

@implementation VAChooseStudentTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)dealloc {
    NSLog(@"VAChooseStudentTVC dealloc");
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.course.students containsObject:user]) {
        [self.course removeStudentsObject:user];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [self.course addStudentsObject:user];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)configureCell:(UITableViewCell *)cell withUser:(User *)user {
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                           user.firstName, user.lastName];
    cell.detailTextLabel.text = user.email;
    
    if ([self.course.students containsObject:user]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([user isEqual:self.course.teacher] || [user isEqual:self.teacher]) {
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.f];
        cell.detailTextLabel.text = @"The user is teaching this course";
        cell.userInteractionEnabled = NO;
    }
}

@end
