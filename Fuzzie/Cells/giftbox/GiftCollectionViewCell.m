//
//  GiftCollectionViewCell.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 23/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "GiftCollectionViewCell.h"
#import "FZGiftPricesLayoutAttributes.h"

@implementation GiftCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.containerView.layer.cornerRadius = 6.0f;
    self.containerView.layer.borderColor = [UIColor colorWithHexString:@"#B5B5B5"].CGColor;
    self.containerView.layer.borderWidth = 2.0f;
    self.containerView.layer.masksToBounds = YES;
    self.priceLabel.textColor = [UIColor colorWithHexString:@"#B5B5B5"];
    self.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
    self.soldOutIcon.hidden = YES;
    
    self.containerView.clipsToBounds = NO;
    self.priceLabel.superview.superview.clipsToBounds = NO;
    self.priceLabel.superview.clipsToBounds = NO;
//    self.soldOutIcon.layer.zPosition = 99999;
}

@end
