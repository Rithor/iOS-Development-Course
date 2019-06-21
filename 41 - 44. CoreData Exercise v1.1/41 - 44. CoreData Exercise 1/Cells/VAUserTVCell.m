//
//  VAUserTVCell.m
//  41 - 44. CoreData Exercise 1
//
//  Created by Vitaliy on 10/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VAUserTVCell.h"

@implementation VAUserTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textField.textAlignment = NSTextAlignmentRight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
