//
//  AboutBrandTableViewCell.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/10/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageBrandDetailTableViewCell.h"
#import "FZBrand.h"


@interface PackageBrandDetailTableViewCell : UITableViewCell
- (void)setPackageBrandDetailText:(FZBrand *)brand;

@end
