//
//  VACorsesCell.h
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 21/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VACorsesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attentionImage;

@end

NS_ASSUME_NONNULL_END
