//
//  VAUserDetailTVC.h
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 10/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

NS_ASSUME_NONNULL_BEGIN

@interface VAUserDetailTVC : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *user;

@end

NS_ASSUME_NONNULL_END
