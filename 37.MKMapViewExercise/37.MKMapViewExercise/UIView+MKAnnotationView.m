//
//  UIView+MKAnnotationView.m
//  37.MKMapView
//
//  Created by Vitaliy on 19/05/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "UIView+MKAnnotationView.h"
#import <MapKit/MKAnnotationView.h>

@implementation UIView (MKAnnotationView)

- (MKAnnotationView *)superAnnotationView {
    
    if ([self isKindOfClass:[MKAnnotationView class]]) {
        return (MKAnnotationView *)self;
    }
    
    if (!self.superview) {
        return nil;
    }
    
    return [self.superview superAnnotationView];
}

@end
