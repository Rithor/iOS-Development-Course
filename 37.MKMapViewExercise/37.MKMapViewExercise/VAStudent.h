//
//  VAStudent.h
//  31 - 32.UITableViewEditing.Exercise
//
//  Created by Vitaliy on 27/04/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VAStudentGender) {
    VAStudentGenderMale,
    VAStudentGenderFemale,
};

@interface VAStudent : NSObject <MKAnnotation>

@property (strong, nonatomic) NSDate *birthday;
@property (assign, nonatomic) VAStudentGender gender;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) UIImage *avatarImage;
@property (assign, nonatomic) NSTimeInterval studentExpectedTravelTime;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

+ (VAStudent *)randomStudentWithCoordinatesNearby:(CLLocationCoordinate2D)coordinate;

@end

NS_ASSUME_NONNULL_END
