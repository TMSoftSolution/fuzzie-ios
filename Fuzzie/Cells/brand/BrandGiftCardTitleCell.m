//
//  BrandGiftCardTitleCell.m
//  Fuzzie
//
//  Created by mac on 5/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BrandGiftCardTitleCell.h"

@implementation BrandGiftCardTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBrandInfo:(FZBrand *)brand withGiftCard:(NSDictionary *)giftCardDict{

    if (brand){
        
        //Be careful estimateTitleHeightWith
        self.brandTitleLabel.text = [brand.name stringByAppendingString:@" E-Gift Card"];
        self.brandPriceLabel.attributedText = [CommonUtilities getFormattedValueWithPrice:giftCardDict[@"price"][@"value"] mainFontName:FONT_NAME_LATO_BOLD mainFontSize:18.0f secondFontName:FONT_NAME_LATO_BOLD secondFontSize:14.0f symboFontName:FONT_NAME_LATO_BOLD symbolFontSize:18.0f];
        
    }
}


@end
