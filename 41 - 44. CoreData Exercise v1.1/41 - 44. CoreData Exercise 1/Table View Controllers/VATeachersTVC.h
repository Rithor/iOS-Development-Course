//
//  VATeachersTVC.h
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 20/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VACourseTVC.h"
#import <CoreData/CoreData.h>
#import "UsersBaseCoreData+CoreDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VATeachersTVC : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController<Course *> *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

NS_ASSUME_NONNULL_END
