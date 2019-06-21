//
//  VATeachersTVC.m
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 20/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VATeachersTVC.h"
#import "AppDelegate.h"
#import "VAUserDetailTVC.h"

@interface VATeachersTVC ()

@end

@implementation VATeachersTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.managedObjectContext = ((AppDelegate *)[[UIApplication sharedApplication]
                                                 delegate]).persistentContainer.viewContext;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)dealloc {
    NSLog(@"VATeachersTVC dealloc");
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController<Course *> *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest<Course *> *fetchRequest = Course.fetchRequest;
    fetchRequest.fetchBatchSize = 20;
    
    NSSortDescriptor *departmentDescriptor = [[NSSortDescriptor alloc]
                                              initWithKey:@"department"
                                              ascending:YES];
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"name"
                                        ascending:YES];
    fetchRequest.sortDescriptors = @[departmentDescriptor, nameDescriptor];
    
    NSPredicate *courseHavingTeacher = [NSPredicate predicateWithFormat:@"teacher.firstName.length > %d", 0];
    fetchRequest.predicate = courseHavingTeacher;
    
    NSFetchedResultsController<Course *> *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:@"department"
                                                   cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    [NSFetchedResultsController deleteCacheWithName:@"VACourseTVC"];
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withCourse:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withCourse:anObject];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    VAUserDetailTVC *userDetailTVC = [self.navigationController.storyboard
                                          instantiateViewControllerWithIdentifier:@"VAUserDetailTVC"];
    userDetailTVC.managedObjectContext = self.managedObjectContext;

    userDetailTVC.user = course.teacher;
    [self.navigationController pushViewController:userDetailTVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    } else
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections]
                                                    objectAtIndex:section];
    return [[sectionInfo.objects valueForKeyPath:@"@distinctUnionOfObjects.teacher"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"TeacherCell"
                             forIndexPath:indexPath];
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell withCourse:course];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withCourse:(Course *)course {
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                           course.teacher.firstName,
                           course.teacher.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"courses: %ld",
                                 [course.teacher.isTeacher count]];
}

@end
