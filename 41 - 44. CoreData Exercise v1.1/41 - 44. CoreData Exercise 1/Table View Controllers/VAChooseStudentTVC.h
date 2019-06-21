//
//  VAChooseStudentTVC.h
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 14/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VAUserTVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface VAChooseStudentTVC : VAUserTVC

@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) User *teacher;

@end

NS_ASSUME_NONNULL_END
