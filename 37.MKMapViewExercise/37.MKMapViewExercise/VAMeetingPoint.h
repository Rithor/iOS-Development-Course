//
//  VAMeetingPoint.h
//  37.MKMapViewExercise
//
//  Created by Vitaliy on 23/05/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VAMeetingPoint : NSObject <MKAnnotation>

@property (strong, nonatomic) UIImage *image;
// Center latitude and longitude of the annotation view.
// The implementation of this property must be KVO compliant.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

// Title and subtitle for use by selection UI.
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END
