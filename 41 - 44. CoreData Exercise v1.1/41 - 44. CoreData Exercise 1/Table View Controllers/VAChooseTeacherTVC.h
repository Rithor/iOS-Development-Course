//
//  VAChooseTeacherTVC.h
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 13/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VAUserTVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VAChooseTeacherTVCDelegate;

@interface VAChooseTeacherTVC : VAUserTVC

@property (strong, nonatomic) id<VAChooseTeacherTVCDelegate> delegate;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) NSIndexPath *userIsTeacherAtIndexPath;

@end

@protocol VAChooseTeacherTVCDelegate <NSObject>

- (void)didChooseTeacher:(User *)user withIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
