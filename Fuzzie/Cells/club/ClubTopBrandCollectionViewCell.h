//
//  ClubTopBrandCollectionViewCell.h
//  Fuzzie
//
//  Created by Joma on 11/14/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubTopBrandCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivTopBrand;

- (void)setCell:(FZBrand*)brand;

@end
