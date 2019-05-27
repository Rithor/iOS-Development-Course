//
//  VAInformationTableViewController.m
//  37.MKMapViewExercise
//
//  Created by Vitaliy on 21/05/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VAInformationTableViewController.h"
#import "VAStudent.h"
#import <Contacts/Contacts.h>

@interface VAInformationTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthday;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end

@implementation VAInformationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone)
                                                                                   target:self
                                                                                   action:@selector(actionDoneBarButton:)];
    self.navigationItem.rightBarButtonItem = doneBarButton;
    
    VAStudent *student = self.student;
    
    self.firstNameLabel.text = student.firstName;
    self.lastNameLabel.text = student.lastName;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    self.birthday.text = [dateFormatter stringFromDate:student.birthday];
    
    NSString *addressString = [NSString stringWithFormat:@"%@, %@, %@, %@",
                               student.placemark.postalAddress.country,
                               student.placemark.postalAddress.postalCode,
                               student.placemark.postalAddress.city,
                               student.placemark.postalAddress.street];
    
    self.address.text = addressString;
    
    switch (student.gender) {
        case VAStudentGenderMale:
            self.gender.text = @"Male";
            break;
        case VAStudentGenderFemale:
            self.gender.text = @"Female";
            break;
        default:
            self.gender.text = @"not specified";
            break;
    }
}

- (void)dealloc {
    NSLog(@"VAInformationTableViewController dealloc");
}

#pragma mark - Actions

- (void)actionDoneBarButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

//метод делегата для автоматической подгонки высоты строки, взависимости от контента внутри. Так же необхожимо правильно настроить констрэйнты в сториборде
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewAutomaticDimension;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
