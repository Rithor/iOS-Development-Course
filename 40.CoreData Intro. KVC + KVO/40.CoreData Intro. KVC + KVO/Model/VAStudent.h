//
//  VAStudent.h
//  40.CoreData Intro. KVC + KVO
//
//  Created by Vitaliy on 02/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VAStudentGender) {
    VAStudentGenderUnspecified,
    VAStudentGenderFemale,
    VAStudentGenderMale,
};

NS_ASSUME_NONNULL_BEGIN

@interface VAStudent : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (assign, nonatomic) VAStudentGender gender;
@property (strong, nonatomic) NSDate *dateOfBirth;
@property (assign, nonatomic) CGFloat averageGrade;

- (void)clearAllPropertys;
- (NSString *)stringFromGender:(VAStudentGender)gender;

@end

NS_ASSUME_NONNULL_END
