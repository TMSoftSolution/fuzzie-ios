//
//  JackpotCouponDescriptionTableViewCell.m
//  Fuzzie
//
//  Created by mac on 9/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotCouponDescriptionTableViewCell.h"

@implementation JackpotCouponDescriptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.tvBody.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:HEX_COLOR_RED]};
}

- (void)setCell:(NSString *)description{

    self.tvBody.text = description;

}


@end
