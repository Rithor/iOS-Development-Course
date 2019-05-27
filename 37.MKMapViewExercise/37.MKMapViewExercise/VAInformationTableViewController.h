//
//  VAInformationTableViewController.h
//  37.MKMapViewExercise
//
//  Created by Vitaliy on 21/05/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VAStudent, CLPlacemark;

NS_ASSUME_NONNULL_BEGIN

@interface VAInformationTableViewController : UITableViewController

@property (strong, nonatomic) VAStudent *student;

@end

NS_ASSUME_NONNULL_END
