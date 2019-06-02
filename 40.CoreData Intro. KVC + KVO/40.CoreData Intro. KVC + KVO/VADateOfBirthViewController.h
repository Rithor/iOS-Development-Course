//
//  VADateOfBirthViewController.h
//  40.CoreData Intro. KVC + KVO
//
//  Created by Vitaliy on 02/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VADateOfBirthDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface VADateOfBirthViewController : UIViewController

@property (weak, nonatomic) id<VADateOfBirthDelegate> delegate;
@property (strong, nonatomic) NSDate *dateOfBirth;

@end

@protocol VADateOfBirthDelegate <NSObject>

- (void)didValueChangedDatePicker:(UIDatePicker *)datePicker;

@end

NS_ASSUME_NONNULL_END
