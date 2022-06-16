//
//  ClubPopluarCategoryCollectionViewCell.h
//  Fuzzie
//
//  Created by joma on 6/24/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubPopluarCategoryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *selectedBackground;
@property (weak, nonatomic) IBOutlet UIImageView *ivCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbCategory;

@property (strong, nonatomic) NSDictionary *category;

- (void)setCell:(NSDictionary *)category;
- (void)setCellWith:(NSDictionary*)category checked:(BOOL)checked;

@end
