//
//  BrandPackageTitleTableViewCell.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BrandPackageTitleTableViewCell : UITableViewCell

@property (strong, nonatomic) FZBrand* brand;

- (void)setBrandInfo:(FZBrand *)brand andPackageInfo:(NSDictionary *)packageInfo;

@end
