//
//  VACourseDetailTVC.m
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 11/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VACourseDetailTVC.h"
#import "VASimpleAlertControler.h"
#import "VACourseTVCell.h"
#import "VAChooseTeacherTVC.h"
#import "VAChooseDepartmentTVC.h"
#import "VAChooseStudentTVC.h"
#import "VAUserDetailTVC.h"

typedef NS_ENUM(NSInteger, VACourseCellType) {
    VACourseCellTypeName,
    VACourseCellTypeDepartment,
    VACourseCellTypeTeacherName,
};

typedef NS_ENUM(NSInteger, VACourseSectionType) {
    VACourseSectionTypeDetails,
    VACourseSectionTypeStudents,
};

@interface VACourseDetailTVC () <UITextFieldDelegate,
                                    VAChooseTeacherTVCDelegate,
                                    VAChooseDepartmentTVCDelegate,
                                    UINavigationControllerDelegate>

@property (strong, nonatomic) NSArray *allCourseDetailTextFieldsArray;
@property (assign, nonatomic) NSUInteger numberOfTextFilds;
@property (strong, nonatomic) User *teacher;
@property (strong, nonatomic) NSMutableArray<User *> *students;
@property (strong, nonatomic) NSString *choseDepartment;
@property (strong, nonatomic) NSIndexPath *userIsTeacherAtIndexPath;
@property (strong, nonatomic) NSString *createdNameString;

@end

@implementation VACourseDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numberOfTextFilds = 3;
    
    self.title = @"Course Detail";
    
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:(UIBarButtonSystemItemSave)
                                      target:self
                                      action:@selector(actionSaveBarButton:)];
    self.navigationItem.rightBarButtonItem = saveBarButton;
    self.navigationController.delegate = self;
    
    self.allCourseDetailTextFieldsArray = [NSArray array];
    
    if (self.course) {
        self.teacher = self.course.teacher;
    }
}

- (void)dealloc {
    NSLog(@"VACourseDetailTVC dealloc");
}

- (void)showAlertWhithTitle:(NSString *)title andMessage:(NSString *)message {
    
    VASimpleAlertControler *alertControler = [VASimpleAlertControler
                                              showAlertWhithTitle:title
                                              andMessage:message];
    
    [self presentViewController:alertControler animated:YES completion:nil];
}

#pragma mark - Fetched request

- (NSArray *)createAllCoursesArray {
    
    NSFetchRequest *courseRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *courseDescription = [NSEntityDescription
                                              entityForName:@"Course"
                                              inManagedObjectContext:self.managedObjectContext];
    courseRequest.entity = courseDescription;
    
    NSError *requestError = nil;
    NSArray *coursesArray = [self.managedObjectContext
                             executeFetchRequest:courseRequest
                             error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    return coursesArray;
}

#pragma mark - Actions

- (void)actionSaveBarButton:(UIBarButtonItem *)sender {
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    UITextField *nameTextField = [self.allCourseDetailTextFieldsArray
                                  objectAtIndex:VACourseCellTypeName];
    UITextField *departmentTextField = [self.allCourseDetailTextFieldsArray
                                        objectAtIndex:VACourseCellTypeDepartment];
    
    for (UITextView *textField in self.allCourseDetailTextFieldsArray) {
        if ([textField.text length] == 0) {
            [self showAlertWhithTitle:@"Notification"
                           andMessage:@"Please fill in all fields of the form."];
            return;
        }
    }
    if (self.course) {
        self.course.name = nameTextField.text;
        self.course.department = departmentTextField.text;
        self.course.teacher = self.teacher;
        
    } else {
        Course *createdCourse = [[Course alloc] initWithContext:self.managedObjectContext];
        createdCourse.name = nameTextField.text;
        createdCourse.department = departmentTextField.text;
        createdCourse.teacher = self.teacher;
    }
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    UITextField *teacherTextField = [self.allCourseDetailTextFieldsArray
                                     objectAtIndex:VACourseCellTypeTeacherName];
    UITextField *departmentTextField = [self.allCourseDetailTextFieldsArray
                                        objectAtIndex:VACourseCellTypeDepartment];
    
    if ([textField isEqual:teacherTextField]) {
        
        VAChooseTeacherTVC *chooseTeacherVC = [self.storyboard
                                               instantiateViewControllerWithIdentifier:
                                               @"VAChooseTeacherTVC"];
        chooseTeacherVC.delegate = self;
        
        if (self.course) {
            chooseTeacherVC.user = self.teacher;//у курса уже есть учитель, лишнее проперти
            chooseTeacherVC.course = self.course;
            chooseTeacherVC.userIsTeacherAtIndexPath = self.userIsTeacherAtIndexPath;
        }
        
        [self.navigationController pushViewController:chooseTeacherVC animated:YES];
        return NO;
        
    } else if ([textField isEqual:departmentTextField]) {
        
        VAChooseDepartmentTVC *chooseDepartmentVC = [self.storyboard
                                                     instantiateViewControllerWithIdentifier:
                                                     @"VAChooseDepartmentTVC"];
        chooseDepartmentVC.delegate = self;
        
        NSArray *allDepartmentArray = [[self createAllCoursesArray]
                                       valueForKeyPath:@"@distinctUnionOfObjects.department"];
        
        chooseDepartmentVC.departmentsArray = [NSMutableArray arrayWithArray:allDepartmentArray];
        
        if ([departmentTextField.text length] > 0) {
            chooseDepartmentVC.departmentString = departmentTextField.text;
        }
        [self.navigationController pushViewController:chooseDepartmentVC animated:YES];
        return NO;
    } else {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    UITextField *nameTextField = [self.allCourseDetailTextFieldsArray
                                     objectAtIndex:VACourseCellTypeName];
    if ([textField isEqual:nameTextField]) {
        self.createdNameString = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == VACourseSectionTypeDetails) {
        return self.numberOfTextFilds;
    } else if (section == VACourseSectionTypeStudents) {
        return [self.course.students count] + 1;
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == VACourseSectionTypeDetails) {
        return @"Course Details";
    } else if (section == VACourseSectionTypeStudents) {
        return @"Course Students";
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == VACourseSectionTypeDetails) {
        
        VACourseTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseDetailCell"
                                                               forIndexPath:indexPath];
        switch (indexPath.row) {
                
            case VACourseCellTypeName: {
                cell.textField.placeholder = @"course name";
                cell.label.text = @"Course Name";
                cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
                if (self.course) {
                    cell.textField.text = self.course.name;
                } else if (self.createdNameString) {
                    cell.textField.text = self.createdNameString;
                }
            }
                break;
                
            case VACourseCellTypeDepartment: {
                cell.textField.placeholder = @"department";
                cell.label.text = @"Department";
                if (self.course) {
                    cell.textField.text = self.course.department;
                } else if (self.choseDepartment) {
                    cell.textField.text = self.choseDepartment;
                }
            }
                break;
                
            case VACourseCellTypeTeacherName: {
                cell.textField.placeholder = @"choose or add a teacher";
                cell.label.text = @"Teacher";
                if (self.teacher) {
                    cell.textField.text = [NSString stringWithFormat:@"%@ %@",
                                           self.teacher.firstName,
                                           self.teacher.lastName];
                }
            }
                break;
            default:
                break;
        }
        
        if (![self.allCourseDetailTextFieldsArray containsObject:cell.textField]) {
            self.allCourseDetailTextFieldsArray = [self.allCourseDetailTextFieldsArray arrayByAddingObject:cell.textField];
        }
        return cell;
        
    } else if (indexPath.section == VACourseSectionTypeStudents) {
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddStudentCell"
                                                            forIndexPath:indexPath];
            return cell;
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseStudents"
                                                                    forIndexPath:indexPath];
            User *user = [self.students objectAtIndex:indexPath.row - 1];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
            
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == VACourseSectionTypeStudents) {
        
        for (UITextView *textField in self.allCourseDetailTextFieldsArray) {
            if ([textField.text length] == 0) {
                [self showAlertWhithTitle:@"Notification"
                               andMessage:@"Please fill in all fields of the form."];
                return;
            }
        }
        if (indexPath.row == 0) {
            if (!self.course) {
                [self showAlertWhithTitle:@"Notification"
                               andMessage:@"Save the course before adding students"];
                return;
            }
            VAChooseStudentTVC *chooseStudentsVC = [self.storyboard
                                                    instantiateViewControllerWithIdentifier:@"VAChooseStudentTVC"];
            if (self.course) {
                chooseStudentsVC.course = self.course;
            } else if (self.teacher) {
                chooseStudentsVC.teacher = self.teacher;
            }
            
            chooseStudentsVC.managedObjectContext = self.managedObjectContext;
            
            [self.navigationController pushViewController:chooseStudentsVC animated:YES];
            
        } else {
            User *user = [self.students objectAtIndex:indexPath.row - 1];
            VAUserDetailTVC *userDetailTVC = [self.navigationController.storyboard
                                              instantiateViewControllerWithIdentifier:@"VAUserDetailTVC"];
            userDetailTVC.managedObjectContext = self.managedObjectContext;
            
            userDetailTVC.user = user;
            [self.navigationController pushViewController:userDetailTVC animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        User *user = [self.students objectAtIndex:indexPath.row - 1];
        if (self.course) {
            [self.course removeStudentsObject:user];
        }
        [self.students removeObject:user];

        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:(UITableViewRowAnimationAutomatic)];
        [tableView endUpdates];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0 && indexPath.row > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - VAChooseTeacherTVCDelegate

- (void)didChooseTeacher:(User *)user withIndexPath:(NSIndexPath *)indexPath {
    self.teacher = user;
    self.userIsTeacherAtIndexPath = indexPath;
}

#pragma mark - VAChooseDepartmentTVCDelegate

- (void)didChooseDepartment:(NSString *)departmentString withIndexPath:(NSIndexPath *)indexPath {
    self.choseDepartment = departmentString;
    [self.tableView reloadData];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:[VACourseDetailTVC class]]) {
        if (self.course) {
            self.students = [NSMutableArray
                             arrayWithArray:[self.course.students allObjects]];
        }
        [self.tableView reloadData];
    }
}

@end
