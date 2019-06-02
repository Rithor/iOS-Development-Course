//
//  VAAverageGradeTableViewController.h
//  40.CoreData Intro. KVC + KVO
//
//  Created by Vitaliy on 02/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VAAverageGradeTableViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface VAAverageGradeTableViewController : UITableViewController

@property (weak, nonatomic) id<VAAverageGradeTableViewControllerDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *currentAverageGradeIndexPath;

@end

@protocol VAAverageGradeTableViewControllerDelegate <NSObject>

- (void)didAverageGradeSelected:(NSString *)averageGradeString whithIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
