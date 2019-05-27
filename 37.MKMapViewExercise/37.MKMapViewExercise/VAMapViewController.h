//
//  ViewController.h
//  37.MKMapViewExercise
//
//  Created by Vitaliy on 20/05/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView, CLLocationManager;

@interface VAMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;
@property (nonatomic) CLLocationManager *locationManager;

- (IBAction)actionMapTypeSegmentControl:(UISegmentedControl *)sender;

@end

