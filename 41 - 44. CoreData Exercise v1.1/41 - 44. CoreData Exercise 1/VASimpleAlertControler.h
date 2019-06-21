//
//  VASimpleAlertControler.h
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 11/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VASimpleAlertControler : UIAlertController

+ (VASimpleAlertControler *)showAlertWhithTitle:(NSString *)title andMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
