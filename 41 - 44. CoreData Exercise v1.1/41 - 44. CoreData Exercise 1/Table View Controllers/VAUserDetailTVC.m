//
//  VAUserDetailTVC.m
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 10/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VAUserDetailTVC.h"
#import "VAUserTVCell.h"
#import "UsersBaseCoreData+CoreDataModel.h"
#import "VASimpleAlertControler.h"

typedef NS_ENUM(NSInteger, VAUserCellType) {
    VAUserCellTypeFirstName,
    VAUserCellTypeLastName,
    VAUserCellTypeEmail,
};

typedef NS_ENUM(NSInteger, VATextFieldFormat) {
    VATextFieldFormatName,
    VATextFieldFormatEmail,
};

typedef NS_ENUM(NSInteger, VAUserSectionType) {
    VAUserSectionTypeUserInfo,
    VAUserSectionTypeTeacher,
    VAUserSectionTypeCourses,
};

@interface VAUserDetailTVC () <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *allUserDetailTextFieldsArray;
@property (assign, nonatomic) NSUInteger numberOfTextFilds;
@property (assign, nonatomic) NSInteger numberOfSections;
@property (strong, nonatomic) NSArray *coursesArray;
@property (strong, nonatomic) NSArray *teacherArray;

@end

@implementation VAUserDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.numberOfTextFilds = 3;
    
    self.title = @"User Detail";
    
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:(UIBarButtonSystemItemSave)
                                      target:self
                                      action:@selector(actionSaveBarButton:)];
    self.navigationItem.rightBarButtonItem = saveBarButton;
    
    self.allUserDetailTextFieldsArray = [NSArray array];
    
    self.coursesArray = [self.user.courses allObjects];
    self.teacherArray = [self.user.isTeacher allObjects];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.numberOfSections = 1;
    
    if ([self.teacherArray count] > 0) {
        self.numberOfSections += 1;
    }
    if ([self.coursesArray count] > 0) {
        self.numberOfSections += 1;
    }
    
    [super viewWillAppear:animated];
}

- (void)dealloc {
    NSLog(@"VAUserDetailTVC dealloc");
}

#pragma mark - Auxiliary Methods

- (void)addSettingForTextField:(UITextField *)textField withFormat:(VATextFieldFormat)format {
    
    if (format == VATextFieldFormatName) {
        
        textField.keyboardType = UIKeyboardTypeAlphabet;
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.returnKeyType = UIReturnKeyNext;
        
    } else if (format == VATextFieldFormatEmail) {
        
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.returnKeyType = UIReturnKeyDone;
    }
}

- (void)showAlertWhithTitle:(NSString *)title andMessage:(NSString *)message {
    
    VASimpleAlertControler *alertControler = [VASimpleAlertControler
                                              showAlertWhithTitle:title
                                              andMessage:message];
    [self presentViewController:alertControler animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView configurateCellFor:(NSArray *)array forIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCourses"
                                                            forIndexPath:indexPath];
    Course *course = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = course.name;
    return cell;
}

#pragma mark - Actions

- (void)actionSaveBarButton:(UIBarButtonItem *)sender {
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    UITextField *firstNameTextField = [self.allUserDetailTextFieldsArray objectAtIndex:VAUserCellTypeFirstName];
    UITextField *lastNameTextField = [self.allUserDetailTextFieldsArray objectAtIndex:VAUserCellTypeLastName];
    UITextField *emailTextField = [self.allUserDetailTextFieldsArray objectAtIndex:VAUserCellTypeEmail];
    
    for (UITextView *textField in self.allUserDetailTextFieldsArray) {
        if ([textField.text length] == 0) {
            [self showAlertWhithTitle:@"Ops" andMessage:@"Please fill in all fields of the form."];
            return;
        }
    }
    
    if (self.user) {
        self.user.firstName = firstNameTextField.text;
        self.user.lastName = lastNameTextField.text;
        self.user.email = emailTextField.text;
        
    } else {
        User *newUser = [[User alloc] initWithContext:context];
        newUser.firstName = firstNameTextField.text;
        newUser.lastName = lastNameTextField.text;
        newUser.email = emailTextField.text;
    }
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == VAUserSectionTypeUserInfo) {
        return self.numberOfTextFilds;
        
    } else if (section == 1) {
        
        if ([self.teacherArray count] > 0) {
            return [self.teacherArray count];
        } else {
            return [self.coursesArray count];
        }
        
    } else {
        return [self.coursesArray count];
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == VAUserSectionTypeUserInfo) {
        return @"User Info";
        
    } else if (section == 1) {
        if ([self.teacherArray count] > 0) {
            return @"Teaching courses";
        } else {
            return @"Learning courses";
        }
        
    } else {
        return @"Learning courses";
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == VAUserSectionTypeUserInfo) {
        
        VAUserTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDetailCell"
                                                             forIndexPath:indexPath];
        switch (indexPath.row) {
                
            case VAUserCellTypeFirstName: {
                cell.textField.placeholder = @"first name";
                cell.label.text = @"First Name";
                [self addSettingForTextField:cell.textField
                                  withFormat:VATextFieldFormatName];
                if (self.user) {
                    cell.textField.text = self.user.firstName;
                }
            }
                break;
                
            case VAUserCellTypeLastName: {
                cell.textField.placeholder = @"last name";
                cell.label.text = @"Last Name";
                [self addSettingForTextField:cell.textField
                                  withFormat:VATextFieldFormatName];
                if (self.user) {
                    cell.textField.text = self.user.lastName;
                }
            }
                break;
                
            case VAUserCellTypeEmail: {
                cell.textField.placeholder = @"email";
                cell.label.text = @"Email";
                [self addSettingForTextField:cell.textField
                                  withFormat:VATextFieldFormatEmail];
                if (self.user) {
                    cell.textField.text = self.user.email;
                }
            }
                break;
            default:
                break;
        }
        
        if (![self.allUserDetailTextFieldsArray containsObject:cell.textField]) {
            self.allUserDetailTextFieldsArray = [self.allUserDetailTextFieldsArray arrayByAddingObject:cell.textField];
        }
        return cell;
        
        
    } else if (indexPath.section == 1) {
        
        if ([self.teacherArray count] > 0) {
            return [self tableView:tableView
                configurateCellFor:self.teacherArray
                      forIndexPath:indexPath];
        } else {
            return [self tableView:tableView
                configurateCellFor:self.coursesArray
                      forIndexPath:indexPath];
        }
        
    } else {
        return [self tableView:tableView
            configurateCellFor:self.coursesArray
                  forIndexPath:indexPath];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:[self.allUserDetailTextFieldsArray lastObject]]) {
        [textField resignFirstResponder];
    } else {
        NSInteger index = [self.allUserDetailTextFieldsArray indexOfObject:textField];
        [[self.allUserDetailTextFieldsArray objectAtIndex:index + 1] becomeFirstResponder];
    }
    return YES;
}

@end
