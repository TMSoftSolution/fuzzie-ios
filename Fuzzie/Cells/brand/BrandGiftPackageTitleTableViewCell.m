//
//  BrandGiftPackageTitleTableViewCell.m
//  Fuzzie
//
//  Created by mac on 5/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BrandGiftPackageTitleTableViewCell.h"
#import "Masonry.h"

@implementation BrandGiftPackageTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBrandInfo:(FZBrand *)brand andPackageInfo:(NSDictionary *)packageInfo {
    
    if (brand){
        self.brandTitleLabel.text = [NSString stringWithFormat:@"%@ - %@",brand.name,packageInfo[@"name"]];
    }
}


@end
