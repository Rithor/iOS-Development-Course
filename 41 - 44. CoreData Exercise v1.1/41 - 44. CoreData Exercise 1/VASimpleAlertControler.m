//
//  VASimpleAlertControler.m
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 11/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VASimpleAlertControler.h"

@interface VASimpleAlertControler ()

@end

@implementation VASimpleAlertControler

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (UIAlertController *)showAlertWhithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alertControler =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *doneButton = [UIAlertAction actionWithTitle:@"Ok"
                                                         style:(UIAlertActionStyleCancel)
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
    [alertControler addAction:doneButton];
    return alertControler;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
