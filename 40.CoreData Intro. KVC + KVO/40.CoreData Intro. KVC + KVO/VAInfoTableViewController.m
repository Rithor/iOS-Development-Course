//
//  ViewController.m
//  40.CoreData Intro. KVC + KVO
//
//  Created by Vitaliy on 02/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VAInfoTableViewController.h"
#import "VADateOfBirthViewController.h"
#import "VAAverageGradeTableViewController.h"
#import "VAStudent.h"

@interface VAInfoTableViewController () <UITableViewDelegate, UITableViewDataSource,
                                            UITextFieldDelegate, VADateOfBirthDelegate,
                                            VAAverageGradeTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *averageGradeTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *interfaceButtonCollection;

@property (strong, nonatomic) NSDateFormatter *birhtdayFormatter;
@property (strong, nonatomic) NSIndexPath *currentAverageGradeIndexPath;
@property (strong, nonatomic) VAStudent *student;

@end

@implementation VAInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.birhtdayFormatter = [[NSDateFormatter alloc] init];
    self.birhtdayFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    self.student = [[VAStudent alloc] init];
    
    for (UIButton *button in self.interfaceButtonCollection) {
        button.layer.cornerRadius = 5;
    }
}

#pragma mark - Actions

//действие кнопки "Clear", очищает все текстфилды и проперти у студента
- (IBAction)actionClearAllPropertys:(UIButton *)sender {
    [self.student clearAllPropertys];
    self.firstNameTextField.text = @"";
    self.lastNameTextField.text = @"";
    self.averageGradeTextField.text = @"";
    self.dateOfBirthTextField.text = @"";
    self.genderSegmentedControl.selectedSegmentIndex = 0;
}

//устанавливает проперти student.gender, значения в enum списке соответсвует значениям SegmentIndex
- (IBAction)actionGenderSegmentedControl:(UISegmentedControl *)sender {
    self.student.gender = sender.selectedSegmentIndex;
}

//действие кнопки Log, показывает алёрт с распечаткой всех проперти студента
- (IBAction)actionLogButton:(UIButton *)sender {
    
    NSString *studentGenderString = [self.student stringFromGender:self.student.gender];
    
    NSString *studentInfo = [NSString stringWithFormat:@"First Name: %@\n"
                                                        "Last Name: %@\n"
                                                        "Average Grade: %1.1f\n"
                                                        "Birhtday: %@\n"
                                                        "Gender: %@",
                            self.student.firstName,
                            self.student.lastName,
                            self.student.averageGrade,
                            [self.birhtdayFormatter stringFromDate:self.student.dateOfBirth],
                            studentGenderString];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Student Info"
                                                            message:studentInfo preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertCanselAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:(UIAlertActionStyleCancel)
                                                              handler:nil];
    [alertController addAction:alertCanselAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Show other view controller

//показывает VADateOfBirthViewController, передает текущее значение dateOfBirthTextField в дейтпикер VADateOfBirthViewController-а
- (void)showVADateOfBirthViewController {
    
    VADateOfBirthViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VADateOfBirthViewController"];
    UINavigationController *navC = [[UINavigationController alloc]
                                    initWithRootViewController:vc];
    vc.delegate = self;
    if (self.dateOfBirthTextField.text) {
        vc.dateOfBirth = [self.birhtdayFormatter
                          dateFromString:self.dateOfBirthTextField.text];
    }
    [self presentViewController:navC animated:YES completion:nil];
}

//показывает VAAverageGradeTableViewController, передает текущее значение AverageGrade-а в таблицу, для отображения текущей чекмарки
- (void)showVAAverageGradeTableViewController {
    
    VAAverageGradeTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VAAverageGradeTableViewController"];
    UINavigationController *navC = [[UINavigationController alloc]
                                    initWithRootViewController:vc];
    vc.delegate = self;
    if (self.currentAverageGradeIndexPath) {
        vc.currentAverageGradeIndexPath = self.currentAverageGradeIndexPath;
    }
    [self presentViewController:navC animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

//перехватывает нажатие на текстфилды с dateOfBirthTextField и averageGradeTextField, чтобы показать соответствующие вьюконтроллеры
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.dateOfBirthTextField]) {
        [self showVADateOfBirthViewController];
        return NO;
        
    } else if ([textField isEqual:self.averageGradeTextField]) {
        [self showVAAverageGradeTableViewController];
        return NO;
    }
    return YES;
}

//переход между полями firstNameTextFild и lastNameTextFild по кнопке Return на клавиатуре
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.firstNameTextField]) {
        [self.lastNameTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

//записывает значения текстфилдов в соответствующие проперти студента
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.firstNameTextField]) {
        self.student.firstName = textField.text;
    } else if ([textField isEqual:self.lastNameTextField]) {
        self.student.lastName = textField.text;
    }
}

#pragma mark - VADateOfBirthDelegate

- (void)didValueChangedDatePicker:(UIDatePicker *)datePicker {
    self.dateOfBirthTextField.text = [self.birhtdayFormatter stringFromDate:datePicker.date];
    self.student.dateOfBirth = datePicker.date;
}

#pragma mark - VAAverageGradeTableViewControllerDelegate

- (void)didAverageGradeSelected:(NSString *)averageGradeString whithIndexPath:(NSIndexPath *)indexPath {
    self.averageGradeTextField.text = averageGradeString;
    self.student.averageGrade = [averageGradeString floatValue];
    self.currentAverageGradeIndexPath = indexPath;
}

@end
