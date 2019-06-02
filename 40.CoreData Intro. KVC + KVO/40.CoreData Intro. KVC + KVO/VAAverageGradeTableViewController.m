//
//  VAAverageGradeTableViewController.m
//  40.CoreData Intro. KVC + KVO
//
//  Created by Vitaliy on 02/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VAAverageGradeTableViewController.h"

@interface VAAverageGradeTableViewController ()

@property (strong, nonatomic) NSArray *averageGradesArray;

@end

@implementation VAAverageGradeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *averageGradesArray = [NSMutableArray array];
    CGFloat averageGrade = 1.f;
    while (averageGrade <= 5) {
        [averageGradesArray addObject:[NSNumber numberWithFloat:averageGrade]];
        averageGrade += 0.1;
    }
    self.averageGradesArray = [NSArray arrayWithArray:averageGradesArray];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.currentAverageGradeIndexPath) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentAverageGradeIndexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.averageGradesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *averageGradeReuseIdentifier = @"averageGradeReuseIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:averageGradeReuseIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                      reuseIdentifier:averageGradeReuseIdentifier];
    }
    
    if (indexPath == self.currentAverageGradeIndexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSNumber *averageGradeNumber = [self.averageGradesArray objectAtIndex:indexPath.row];
    
    CGFloat averageGrade = [averageGradeNumber floatValue];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%1.1f", averageGrade];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    for (UITableViewCell *cell in tableView.visibleCells) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.delegate didAverageGradeSelected:cell.textLabel.text whithIndexPath:indexPath];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
