//
//  VACourseDetailTVC.h
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 11/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Course;

NS_ASSUME_NONNULL_BEGIN

@interface VACourseDetailTVC : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Course *course;

@end

NS_ASSUME_NONNULL_END
