//
//  BrandGiftPackageTitleTableViewCell.h
//  Fuzzie
//
//  Created by mac on 5/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandGiftPackageTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *brandTitleLabel;

- (void)setBrandInfo:(FZBrand *)brand andPackageInfo:(NSDictionary *)packageInfo;

@end
