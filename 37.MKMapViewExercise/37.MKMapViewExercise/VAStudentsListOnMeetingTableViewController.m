//
//  VAStudentsListOnMeetingTableViewController.m
//  37.MKMapViewExercise
//
//  Created by Vitaliy on 24/05/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VAStudentsListOnMeetingTableViewController.h"
#import "VAInformationTableViewController.h"
#import "VAStudent.h"

@interface VAStudentsListOnMeetingTableViewController () <UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) CLGeocoder *geoCoder;
@property (strong, nonatomic) NSArray *sortedStudentsAtMeetingArray;
@end

@implementation VAStudentsListOnMeetingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone)
                                                                                   target:self
                                                                                   action:@selector(actionDoneBarButton:)];
    self.navigationItem.rightBarButtonItem = doneBarButton;
    
    self.sortedStudentsAtMeetingArray = [NSArray array];
    NSSortDescriptor *sortByExpectedTravelTime = [[NSSortDescriptor alloc]
                                                  initWithKey:@"studentExpectedTravelTime"
                                                  ascending:YES];
    self.sortedStudentsAtMeetingArray = [self.studentsAtMeetingArray
                                         sortedArrayUsingDescriptors:@[sortByExpectedTravelTime]];
}

- (void)dealloc {
    NSLog(@"VAStudentsListOnMeetingTableViewController dealloc");
}

#pragma mark - Auxiliary Methods

- (void)showInformationAboutStudent:(VAStudent *)student {
    
    self.geoCoder = [[CLGeocoder alloc] init];
    
    VAInformationTableViewController *informationTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VAInformationTableViewController"];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:student.coordinate.latitude
                                                      longitude:student.coordinate.longitude];
    
    if ([self.geoCoder isGeocoding]) {
        [self.geoCoder cancelGeocode];
    }
    
    [self.geoCoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                            
                            NSString *message = nil;
                            
                            if (error) {
                                message = [error localizedDescription];
                                [self showAlertWithTitle:@"Error" andMessage:message];
                            } else {
                                if ([placemarks count] == 0) {
                                    message = @"No placemarks found";
                                    [self showAlertWithTitle:@"Error" andMessage:message];
                                } else {
                                    CLPlacemark *placemark = [placemarks firstObject];
                                    student.placemark = placemark;
                                    informationTVC.student = student;
                                    
                                    [self.navigationController pushViewController:informationTVC animated:YES];
                                }
                            }
                        }];
}

#pragma mark - Actions

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertCanselAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:(UIAlertActionStyleCancel)
                                                              handler:nil];
    
    [alertController addAction:alertCanselAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)actionDoneBarButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sortedStudentsAtMeetingArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"studentCell"];
    
    VAStudent *student = [self.sortedStudentsAtMeetingArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.0fhr:%dmin",
                                 student.studentExpectedTravelTime / 60 / 60,
                                 (int)(student.studentExpectedTravelTime / 60) % 60];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VAStudent *student = [self.sortedStudentsAtMeetingArray objectAtIndex:indexPath.row];
    
    [self showInformationAboutStudent:student];
}

@end
