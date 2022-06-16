//
//  PowerUpPackPhotoCoverTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 2/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "PowerUpPackPhotoCoverTableViewCell.h"

@implementation PowerUpPackPhotoCoverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCell:(FZCoupon *)coupon{
    
    self.bgImageView.image = nil;
    
    NSDictionary *powerUpPack = coupon.powerUpPack;
    if (powerUpPack && powerUpPack[@"image"] && ![powerUpPack[@"image"] isKindOfClass:[NSNull class]] && ![powerUpPack[@"image"] isEqualToString:@""]) {
        
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:powerUpPack[@"image"]] placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
    }
    
    if ([coupon.soldOut boolValue]) {
        
        self.ivSoldOut.hidden = NO;
        
    } else {
        
        self.ivSoldOut.hidden = YES;
    }

}

- (void)setCellWith:(NSDictionary*)giftDict{
    
    self.bgImageView.image = nil;
    [self.bgImageView setImage:[UIImage imageNamed:@"bg-power-up-gift"]];
    
    self.ivSoldOut.hidden = YES;
}

@end
