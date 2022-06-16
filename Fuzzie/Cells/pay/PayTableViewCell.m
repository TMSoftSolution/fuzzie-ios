//
//  PayTableViewCell.m
//  Fuzzie
//
//  Created by mac on 8/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "PayTableViewCell.h"

@implementation PayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(int) estimateHeigthWithBrand:(FZBrand *)brand andItem:(NSDictionary*)itemDict{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    CGFloat width = screenWidth - 90;
    NSString *string = [NSString stringWithFormat:@"%@ - %@", brand.name,itemDict[@"name"]];
    
    NSDictionary *fontAttributes = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_REGULAR size:14]};
    CGRect rect = [string  boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:fontAttributes
                                        context:nil];
    CGFloat height;
    if ([itemDict[@"cash_back"][@"value"] floatValue] <= 0) {
        height =  rect.size.height + 40;
    } else{
        height =  rect.size.height + 60;
    }
    
    if (height > 80) {
        return 80.0f;
    } else {
        return height;
    }
}

- (void)setCellWithBrand:(FZBrand *)brand andItem:(NSDictionary *)itemDict withLast:(BOOL)isLast{
    
    NSString *itemName = [NSString stringWithFormat:@"%@ %@",brand.name, itemDict[@"name"]];
    [self.lbName setText:itemName];
   
    self.lbPrice.attributedText = [CommonUtilities getFormattedCashbackValue:itemDict[@"discounted_price"] fontSize:14.0f smallFontSize:10.0f];
    
    if ([itemDict[@"cash_back"][@"value"] floatValue] <= 0) {
        self.lbCashback.hidden = YES;
    } else{
        self.lbCashback.hidden = NO;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[CommonUtilities getFormattedCashbackValue:itemDict[@"cash_back"][@"value"] fontSize:12.0f smallFontSize:9.0f]];
        NSAttributedString *cashbackString = [[NSAttributedString alloc] initWithString:@" cashback" attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:12.0f]}];
        [attributedString appendAttributedString:cashbackString];
        self.lbCashback.attributedText = attributedString;
    }
    
    if (isLast) {
        self.dividerLeftAnchor.constant = 0.0f;
    } else{
        self.dividerLeftAnchor.constant = 15.0f;
    }
    
}


@end
