//
//  VAChooseDepartmentTVC.h
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 13/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VACourseTVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VAChooseDepartmentTVCDelegate;

@interface VAChooseDepartmentTVC : UITableViewController

@property (strong, nonatomic) NSMutableArray *departmentsArray;
@property (strong, nonatomic) id<VAChooseDepartmentTVCDelegate> delegate;
@property (strong, nonatomic) NSString *departmentString;

@end

@protocol VAChooseDepartmentTVCDelegate <NSObject>

- (void)didChooseDepartment:(NSString *)departmentString withIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
