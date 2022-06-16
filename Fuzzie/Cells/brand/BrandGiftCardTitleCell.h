//
//  BrandGiftCardTitleCell.h
//  Fuzzie
//
//  Created by mac on 5/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandGiftCardTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *brandTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandPriceLabel;

- (void)setBrandInfo:(FZBrand *)brand withGiftCard:(NSDictionary*) giftCardDict;

@end
