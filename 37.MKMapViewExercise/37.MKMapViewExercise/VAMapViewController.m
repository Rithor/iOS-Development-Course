//
//  ViewController.m
//  37.MKMapViewExercise
//
//  Created by Vitaliy on 20/05/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VAMapViewController.h"
#import "UIView+MKAnnotationView.h"
#import "VAInformationTableViewController.h"
#import "VAStudent.h"
#import "VAMeetingPoint.h"
#import "VAStudentsListOnMeetingTableViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, VADistance) {
    VADistanceFiveKm      = 5000,
    VADistanceTenKm       = 10000,
    VADistanceFifteenKm   = 15000,
};

typedef NS_ENUM(NSInteger, VAChance) {
    VAChanceHight   = 90,
    VAChanceMiddle  = 50,
    VAChanceLow     = 10,
};

@interface VAMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) CLGeocoder *geoCoder;
@property (assign, nonatomic) CLLocationCoordinate2D userLocationCoordinate;
@property (strong, nonatomic) NSMutableArray *studentsArray;
@property (assign, nonatomic) MKCoordinateSpan testReginSpan;
@property (strong, nonatomic) NSArray *circleOverlays;
@property (strong, nonatomic) VAMeetingPoint *meetingPoint;
@property (strong, nonatomic) NSMutableArray *fiveKmStudentsArray;
@property (strong, nonatomic) NSMutableArray *tenKmStudentsArray;
@property (strong, nonatomic) NSMutableArray *fifteenKmStudentsArray;
@property (strong, nonatomic) NSMutableArray *studentOnMeetingArray;
@property (strong, nonatomic) MKDirections *directions;
@property (strong, nonatomic) NSMutableArray *polylineDirectionsArray;
@property (strong, nonatomic) NSMutableArray *studentDirectionArray;
@property (weak, nonatomic) IBOutlet UILabel *fiveKmStudentsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenKmStudentsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifteenKmStudentsCountLabel;
@property (weak, nonatomic) IBOutlet UIView *studentsListView;

@end

@implementation VAMapViewController

#pragma mark - View life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.mainMapView.showsScale = YES;
//    self.mainMapView.showsCompass = YES;
//    self.mainMapView.showsTraffic = YES;
//    self.mainMapView.showsBuildings = YES;
//    self.mainMapView.showsPointsOfInterest = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 10;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd)
                                     target:self
                                     action:@selector(actionAddStudents:)];
    UIBarButtonItem *showUserLocationsBarButton = [[UIBarButtonItem alloc]
                                                   initWithBarButtonSystemItem:(UIBarButtonSystemItemSearch)
                                                   target:self
                                                   action:@selector(actionShowUserLocations:)];
    UIBarButtonItem *addMeetingPointBarButton = [[UIBarButtonItem alloc]
                                                   initWithBarButtonSystemItem:(UIBarButtonSystemItemAction)
                                                   target:self
                                                   action:@selector(actionAddMeetingPoint:)];
    
    self.navigationItem.rightBarButtonItems = @[addBarButton, showUserLocationsBarButton, addMeetingPointBarButton];
    
    self.studentsListView.layer.cornerRadius = 10;
    [self.studentsListView setHidden:YES];
    
    self.mainMapView.showsUserLocation = YES;
}

- (void)dealloc {
    
    [self.locationManager stopUpdatingLocation];
    self.mainMapView.showsUserLocation = NO;
    
    if ([self.geoCoder isGeocoding]) {
        [self.geoCoder cancelGeocode];
    }
    
    if ([self.directions isCalculating]) {
        [self.directions cancel];
    }
}

#pragma mark - Auxiliary Methods

//создает три круга с заданными радиусами, добавляет их как овердеи на карту
- (void)addCircleOverlaysWithCenterCoordinate:(CLLocationCoordinate2D)coordinate {

    MKCircle *fiveKmRadius = [MKCircle circleWithCenterCoordinate:(coordinate)
                                                           radius:VADistanceFiveKm];
    MKCircle *tenKmRadius = [MKCircle circleWithCenterCoordinate:(coordinate)
                                                          radius:VADistanceTenKm];
    MKCircle *fifteenKmRadius = [MKCircle circleWithCenterCoordinate:(coordinate)
                                                              radius:VADistanceFifteenKm];
    self.circleOverlays = @[fiveKmRadius, tenKmRadius, fifteenKmRadius];
    
    [self.mainMapView addOverlays:self.circleOverlays level:(MKOverlayLevelAboveRoads)];
}

#pragma mark - Actions

//добавляет массив анотаций на карту
- (void)actionAddStudents:(UIBarButtonItem *)sender {
    
    if (self.studentsArray) {
        [self.mainMapView removeAnnotations:self.studentsArray];
        [self.mainMapView removeOverlays:self.polylineDirectionsArray];
        self.studentOnMeetingArray = nil;
        self.studentsArray = nil;
    }
    
    self.studentsArray = [NSMutableArray array];
    for (int i = 0; i < 30; i ++) {
        VAStudent *student = [VAStudent randomStudentWithCoordinatesNearby:self.userLocationCoordinate];
        [self.studentsArray addObject:student];
    }
    [self.mainMapView addAnnotations:self.studentsArray];
    
    if (self.meetingPoint) {
        [self calculateStudentsForMeetingPoint:self.meetingPoint];
    }
}

//отображает заданый регион на экране
- (void)actionShowUserLocations:(UIBarButtonItem *)sender {
    
    self.testReginSpan = MKCoordinateSpanMake(0.35, 0.35);
    self.mainMapView.region = MKCoordinateRegionMake(self.userLocationCoordinate, self.testReginSpan);
}

//добавляет место встречи на карту
- (void)actionAddMeetingPoint:(UIBarButtonItem *)sender {
    //показывает вью со списком студентов в радиусе
    if ([self.studentsListView isHidden]) {
        [self.studentsListView setHidden:NO];
    }
    //место встречи может быть только одно
    if (self.meetingPoint) {
        [self.mainMapView removeAnnotation:self.meetingPoint];
        [self.mainMapView removeOverlays:self.polylineDirectionsArray];
    }
    self.studentOnMeetingArray = nil;
    
    VAMeetingPoint *meetingPoint = [[VAMeetingPoint alloc] init];
    meetingPoint.image = [UIImage imageNamed:@"meetingPoint.png"];
    meetingPoint.title = @"Go here!";
    self.meetingPoint = meetingPoint;
    [self.mainMapView addAnnotation:self.meetingPoint];
    
    [self calculateStudentsForMeetingPoint:self.meetingPoint];
}

//Запускает определение конкретного экзепляра annotationView по кнопке которого было произведено нажатие. На основе его CLLocation Запускает службу CLGeocoder, в случае если служба возвращает ошибку - запускается метод -showErrorPopoverWithMessage. Иначе запускается метод -showPopoverWithPlacemark:andSender:forStudent:
- (void)actionInformation:(UIButton *)sender {
    
    self.geoCoder = [[CLGeocoder alloc] init];
    
    MKAnnotationView *annotationView = [sender superAnnotationView];
    
    VAStudent *student = annotationView.annotation;
    
    if (!annotationView) {
        return;
    }
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:student.coordinate.latitude
                                                      longitude:student.coordinate.longitude];
    if ([self.geoCoder isGeocoding]) {
        [self.geoCoder cancelGeocode];
    }
    
    [self.geoCoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                            
                            NSString *message = nil;
                            
                            if (error) {
                                message = [error localizedDescription];
                                [self showAlertWithTitle:@"Error" andMessage:message];
                            } else {
                                if ([placemarks count] == 0) {
                                    message = @"No placemarks found";
                                    [self showAlertWithTitle:@"Error" andMessage:message];
                                } else {
                                    CLPlacemark *placemark = [placemarks firstObject];
                                    student.placemark = placemark;
                                    [self showPopoverWithSender:sender forStudent:student];
                                }
                            }
                        }];
}

//переключает тип карты
- (IBAction)actionMapTypeSegmentControl:(UISegmentedControl *)sender {
    self.mainMapView.mapType = (MKMapType)sender.selectedSegmentIndex;
}

//добавляет маршруты на карту. Цель - место встречи. Стартовые точки - случайные студенты определенные в методе - (NSMutableArray *)createArrayWithRandomObject:(NSMutableArray *)array atChance:(VAChance)chance
- (void)actionRoutesCalculate:(UIButton *)sender {
    
    if (!self.studentsArray) {
        [self showAlertWithTitle:@"Упс!" andMessage:@"На карте нет студентов!"];
        return;
    }
    
    self.studentDirectionArray = [NSMutableArray array];
    
    if (self.polylineDirectionsArray) {
        [self.mainMapView removeOverlays:self.polylineDirectionsArray];
    } else {
        self.polylineDirectionsArray = [NSMutableArray array];
    }
    
    NSMutableArray *studentsHightChanceArray = [self createArrayWithRandomObject:self.fiveKmStudentsArray
                                                                        atChance:VAChanceHight];
    NSMutableArray *studentsMiddleChanceArray = [self createArrayWithRandomObject:self.tenKmStudentsArray
                                                                        atChance:VAChanceMiddle];
    NSMutableArray *studentsLowChanceArray = [self createArrayWithRandomObject:self.fifteenKmStudentsArray
                                                                        atChance:VAChanceLow];
    [studentsHightChanceArray addObjectsFromArray:studentsMiddleChanceArray];
    [studentsHightChanceArray addObjectsFromArray:studentsLowChanceArray];
    NSArray *routingStudentsArray = [NSArray arrayWithArray:studentsHightChanceArray];
    self.studentOnMeetingArray = [NSMutableArray arrayWithArray:routingStudentsArray];
    
    if ([self.directions isCalculating]) {
        [self.directions cancel];
    }
    
    MKPlacemark *meetingPointPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.meetingPoint.coordinate
                                                   addressDictionary:nil];
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.destination = [[MKMapItem alloc] initWithPlacemark:meetingPointPlacemark];
    
    for (VAStudent *student in routingStudentsArray) {
        
        MKPlacemark *studentPlacemark = [[MKPlacemark alloc] initWithCoordinate:student.coordinate
                                                                   addressDictionary:nil];
        request.source = [[MKMapItem alloc] initWithPlacemark:studentPlacemark];
        MKDirections *studentDirection = [[MKDirections alloc] initWithRequest:request];
        
        [self.studentDirectionArray addObject:studentDirection];
            
        [studentDirection calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            NSString *errorTitleString = [NSString stringWithFormat:@"Error calculate route for %@ %@",
                                          student.firstName,
                                          student.lastName];
            if (error) {
                
                    [self showAlertWithTitle:errorTitleString
                                  andMessage:[error localizedDescription]];
                    [self.studentOnMeetingArray removeObject:student];
                
               
                
            } else if ([response.routes count] == 0) {
                
                [self showAlertWithTitle:errorTitleString
                              andMessage:@"No routes found"];
                [self.studentOnMeetingArray removeObject:student];
            } else {
                
                NSMutableArray *polylinesArray = [NSMutableArray array];
                
                for (MKRoute *route in response.routes) {
                    [polylinesArray addObject:route.polyline];
                    student.studentExpectedTravelTime = route.expectedTravelTime;
                    [self.polylineDirectionsArray addObject:route.polyline];
                }
                [self.mainMapView addOverlays:polylinesArray level:(MKOverlayLevelAboveRoads)];
            }
        }];
    }
}


#pragma mark - Show other view

//показывает UIAlertController, при ошибке поиска Directions-а или GeocodeLocation
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertCanselAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:(UIAlertActionStyleCancel)
                                                              handler:nil];
    [alertController addAction:alertCanselAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//показывает Popover с VAInformationTableViewController, передает через проперти ссылк на student-а
- (void)showPopoverWithSender:(UIButton *)sender forStudent:(VAStudent *)student {
    
    VAInformationTableViewController *informationTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VAInformationTableViewController"];
    UINavigationController *navCon = [[UINavigationController alloc]
                                      initWithRootViewController:informationTVC];
    informationTVC.preferredContentSize = CGSizeMake(300, 300);
    navCon.modalPresentationStyle = UIModalPresentationPopover;
    
    informationTVC.student = student;
    
    [self presentViewController:navCon animated:YES completion:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        UIPopoverPresentationController *popoverController = navCon.popoverPresentationController;
        popoverController.delegate = self;
        
        if (sender) {
            popoverController.sourceView = self.view;
            popoverController.sourceRect = [sender convertRect:sender.bounds toView:self.view];
        }
    }
}

//вызывает поповер с списком студетов, которые едут на встречу
- (void)actionShowStudentList:(UIButton *)sender {
    
    if (!self.studentsArray) {
        [self showAlertWithTitle:@"Упс!" andMessage:@"На карте нет студентов!"];
        return;
    }
    if (!self.studentOnMeetingArray) {
        [self showAlertWithTitle:@"Упс!"
                      andMessage:@"Студенты ещё не знают про встречу! Сначала позови их нажав + слева!"];
        return;
    }
    
    VAStudentsListOnMeetingTableViewController *tableViewControler = [self.storyboard instantiateViewControllerWithIdentifier:@"VAStudentsListOnMeetingTableViewController"];
    
    tableViewControler.preferredContentSize = CGSizeMake(325, 325);
    
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:tableViewControler];
    navCon.modalPresentationStyle = UIModalPresentationPopover;
    
    tableViewControler.studentsAtMeetingArray = self.studentOnMeetingArray;
    
    [self presentViewController:navCon animated:YES completion:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIPopoverPresentationController *popoverController = navCon.popoverPresentationController;
        popoverController.delegate = self;
        
        if (sender) {
            popoverController.sourceView = self.view;
            popoverController.sourceRect = [sender convertRect:sender.bounds toView:self.view];
        }
    }
}

#pragma mark - Models data

//алгоритм - создает массив из случайных элементов другого массива, количество элементов в новом массиве будет равно chance-у в процентах
- (NSMutableArray *)createArrayWithRandomObject:(NSMutableArray *)array atChance:(VAChance)chance {
    
    NSMutableArray *randomStudentsArray = [NSMutableArray array];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
    
    while (([array count] * chance / 100) > [randomStudentsArray count]) {
        NSUInteger randomIndex = arc4random() % [tempArray count];
        [randomStudentsArray addObject:[tempArray objectAtIndex:randomIndex]];
        [tempArray removeObjectAtIndex:randomIndex];
    }
    return randomStudentsArray;
}

//подсчет студентов для отображения их количества в заданных радиусах от места встречи
- (void)calculateStudentsForMeetingPoint:(VAMeetingPoint *)meetingPoint {
    
    NSMutableArray *studentsFiveKmRadiusArray = [NSMutableArray array];
    NSMutableArray *studentsTenKmRadius = [NSMutableArray array];
    NSMutableArray *studentsFifteenKmRadius = [NSMutableArray array];
    
    MKMapPoint meetingMapPoint = MKMapPointForCoordinate(meetingPoint.coordinate);
    
    for (VAStudent *student in self.studentsArray) {
        
        MKMapPoint studentMapPoint = MKMapPointForCoordinate(student.coordinate);
        
        CLLocationDistance distance = MKMetersBetweenMapPoints(meetingMapPoint, studentMapPoint);
        
        if (distance <= VADistanceFiveKm) {
            [studentsFiveKmRadiusArray addObject:student];
        } else if (distance <= VADistanceTenKm) {
            [studentsTenKmRadius addObject:student];
        } else if (distance <= VADistanceFifteenKm) {
            [studentsFifteenKmRadius addObject:student];
        }
    }
    self.fiveKmStudentsCountLabel.text = [NSString stringWithFormat:@"%d", (int)[studentsFiveKmRadiusArray count]];
    self.tenKmStudentsCountLabel.text = [NSString stringWithFormat:@"%d", (int)[studentsTenKmRadius count]];
    self.fifteenKmStudentsCountLabel.text = [NSString stringWithFormat:@"%d", (int)[studentsFifteenKmRadius count]];
    
    self.fiveKmStudentsArray = studentsFiveKmRadiusArray;
    self.tenKmStudentsArray = studentsTenKmRadius;
    self.fifteenKmStudentsArray = studentsFifteenKmRadius;
}

#pragma mark - MKMapViewDelegate

//вызывается при добавлении анотаций на карту.
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //для MKUserLocation
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    //анотации для объектов VAStudent
    if ([annotation isKindOfClass:[VAStudent class]]) {
        
        static NSString *identifier = @"VAStudentAnnotation";
        
        MKAnnotationView *studentAnotationView = (MKAnnotationView *)[mapView
                                                    dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!studentAnotationView) {
            studentAnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                        reuseIdentifier:identifier];
            studentAnotationView.canShowCallout = YES;
            studentAnotationView.draggable = NO;
            
            VAStudent *student = annotation;
            studentAnotationView.image = student.avatarImage;
            
            UIButton *descriptionButton = [UIButton buttonWithType:(UIButtonTypeDetailDisclosure)];
            [descriptionButton addTarget:self
                                  action:@selector(actionInformation:)
                        forControlEvents:(UIControlEventTouchUpInside)];
            studentAnotationView.rightCalloutAccessoryView = descriptionButton;
            
        } else {
            studentAnotationView.annotation = annotation;
        }
        
        return studentAnotationView;
        
        //анотация для точки встречи
    } else if ([annotation isKindOfClass:[VAMeetingPoint class]]) {
        
        static NSString *identifier = @"VAMeetingPointAnnotation";
        MKAnnotationView *meetingPointAnotationView = (MKAnnotationView *)[mapView
                                                    dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!meetingPointAnotationView) {
            meetingPointAnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:identifier];
            meetingPointAnotationView.canShowCallout = YES;
            meetingPointAnotationView.draggable = YES;
            
            VAMeetingPoint *meetingPoint = annotation;
            meetingPointAnotationView.image = meetingPoint.image;
            
            UIButton *routesCalculate = [UIButton buttonWithType:(UIButtonTypeContactAdd)];
            [routesCalculate addTarget:self
                                  action:@selector(actionRoutesCalculate:)
                        forControlEvents:(UIControlEventTouchUpInside)];
            
            UIButton *showStudentListButton = [UIButton buttonWithType:(UIButtonTypeDetailDisclosure)];
            [showStudentListButton addTarget:self
                                  action:@selector(actionShowStudentList:)
                        forControlEvents:(UIControlEventTouchUpInside)];
            meetingPointAnotationView.rightCalloutAccessoryView = showStudentListButton;
            meetingPointAnotationView.leftCalloutAccessoryView = routesCalculate;
            
        } else {
            meetingPointAnotationView.annotation = annotation;
        }
        
        return meetingPointAnotationView;
    }
    return nil;
}

//вызывется при добавлении любой анотации на карту.
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    
    //если анотация - точка встречи, определяем круги с заданым радиусом
    if ([[views firstObject].annotation isKindOfClass:[VAMeetingPoint class]]) {
        
        if ([self.circleOverlays count] > 0) {
            [self.mainMapView removeOverlays:self.circleOverlays];
        }
        
        CLLocationCoordinate2D meetingPointCenterCoordinate = [views firstObject].annotation.coordinate;
        
        [self addCircleOverlaysWithCenterCoordinate:meetingPointCenterCoordinate];
    }
}

//отрисовывает Overlays-ы
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
        
        MKCircleRenderer *render = [[MKCircleRenderer alloc] initWithCircle:overlay];
        render.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
        
        return render;
        
    } else if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        renderer.lineWidth = 4.f;
        renderer.strokeColor = [UIColor blueColor];
        renderer.alpha = 0.8f;
        return renderer;
    }
    
    return nil;
}

//запускается при переносе места встречи, убирает старые оверлеи и посылает запрос на отрисовку новых. Посылает запрос на перерасчет студентов в новых радиусах. Обнуляет массив студентов которые едут на встречу
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    if ([view.annotation isKindOfClass:[VAMeetingPoint class]]) {
        
        if (newState == MKAnnotationViewDragStateStarting) {
            
            [self.mainMapView removeOverlays:self.circleOverlays];
            [self.mainMapView removeOverlays:self.polylineDirectionsArray];
            self.studentOnMeetingArray = nil;
            
        } else if (newState == MKAnnotationViewDragStateEnding) {
            
            self.meetingPoint = view.annotation;
            
            view.dragState = MKAnnotationViewDragStateNone;
            [self addCircleOverlaysWithCenterCoordinate:self.meetingPoint.coordinate];
            [self calculateStudentsForMeetingPoint:self.meetingPoint];
        }
    }
}

#pragma mark - CLLocationManagerDelegate

//для определения координат userLocationCoordinate, и в дальнейшем для определения отображаемого региона на карте
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    self.userLocationCoordinate = [locations firstObject].coordinate;
}

@end
