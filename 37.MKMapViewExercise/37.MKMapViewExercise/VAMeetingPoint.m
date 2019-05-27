//
//  VAMeetingPoint.m
//  37.MKMapViewExercise
//
//  Created by Vitaliy on 23/05/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VAMeetingPoint.h"

@implementation VAMeetingPoint

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(55.79, 37.51);
        
        double latitudeOffset = (double)(arc4random() % 20000 + 10) / 1000000;
        double longitudeOffset = (double)(arc4random() % 20000 + 10) / 1000000;
        
        coordinate.latitude = arc4random() % 2 ? (coordinate.latitude + latitudeOffset) : (coordinate.latitude - latitudeOffset);
        coordinate.longitude = arc4random() % 2 ? (coordinate.longitude + longitudeOffset) : (coordinate.longitude - longitudeOffset);
        
        self.coordinate = coordinate;
    }
    return self;
}

@end
