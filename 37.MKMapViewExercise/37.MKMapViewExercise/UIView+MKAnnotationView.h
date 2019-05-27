//
//  UIView+MKAnnotationView.h
//  37.MKMapView
//
//  Created by Vitaliy on 19/05/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MKAnnotationView;

@interface UIView (MKAnnotationView)

- (MKAnnotationView *)superAnnotationView;

@end

NS_ASSUME_NONNULL_END
