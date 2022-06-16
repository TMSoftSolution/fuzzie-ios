//
//  BagTableViewCell.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 1/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "BagTableViewCell.h"

@implementation BagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [CommonUtilities setView:self.cashbackView withCornerRadius:2.5f];
}

- (void)setCell:(NSDictionary *)giftCardDict{
    
    NSDictionary *brandDict = giftCardDict[@"brand"];
    NSError *error;
    FZBrand *brand;
    brand = [MTLJSONAdapter modelOfClass:FZBrand.class fromJSONDictionary:brandDict error:&error];
    
    NSURL *imageURL = [NSURL URLWithString:giftCardDict[@"brand"][@"background_image_url"]];
    self.brandImageView.layer.cornerRadius = 2.5f;
    self.brandImageView.layer.masksToBounds = YES;
    [self.brandImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
    
    if (giftCardDict[@"item"][@"gift_card"]) {
        self.brandNameLabel.text = [NSString stringWithFormat:@"%@ E-Gift Card", giftCardDict[@"brand"][@"name"]];
        self.giftNameLabel.attributedText = [CommonUtilities getFormattedCashbackValue:giftCardDict[@"selling_price"] fontSize:16.0f smallFontSize:12.0f];
    } else if (giftCardDict[@"item"][@"service"]) {
        self.brandNameLabel.text = [NSString stringWithFormat:@"%@-%@",  giftCardDict[@"brand"][@"name"],giftCardDict[@"item"][@"service"][@"name"]];
        self.giftNameLabel.attributedText = [CommonUtilities getFormattedCashbackValue:giftCardDict[@"selling_price"] fontSize:16.0f smallFontSize:12.0f];
    }
    
    if (brand.percentage && brand.percentage.floatValue > 0) {
        
        self.cashbackView.hidden = NO;
        self.cashbackLabel.attributedText = [CommonUtilities getFormattedCashbackPercentage:brand.percentage fontSize:12 decimalFontSize:12];
        
    } else {
        
        self.cashbackLabel.text = @"";
        self.cashbackView.hidden = YES;
        
    }
    
    if (_isEditing) {
        self.selectImage.hidden = NO;
        self.brandImageLeftAnchor.constant = 47;
    } else {
        self.selectImage.hidden = YES;
        self.brandImageLeftAnchor.constant = 7;
    }
    
    if (_isSelected) {
        [self.selectImage setImage:[UIImage imageNamed:@"bag_selected"]];
    } else {
        [self.selectImage setImage:[UIImage imageNamed:@"bag_deselected"]];
    }
}

@end
