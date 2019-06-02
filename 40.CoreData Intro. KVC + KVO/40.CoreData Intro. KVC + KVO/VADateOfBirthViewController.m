//
//  VADateOfBirthViewController.m
//  40.CoreData Intro. KVC + KVO
//
//  Created by Vitaliy on 02/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VADateOfBirthViewController.h"

@interface VADateOfBirthViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayDatePicker;

@end

@implementation VADateOfBirthViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.dateOfBirth) {
        self.birthdayDatePicker.date = self.dateOfBirth;
    }
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:(UIBarButtonSystemItemDone)
                                      target:self
                                      action:@selector(actionDoneBarButton:)];
    self.navigationItem.rightBarButtonItem = doneBarButton;
}

- (void)dealloc {
    NSLog(@"VADateOfBirthViewController did dealloc");
}

#pragma mark - Actions

- (void)actionDoneBarButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionBirthdayValueChange:(UIDatePicker *)sender {
    [self.delegate didValueChangedDatePicker:sender];
}

@end
