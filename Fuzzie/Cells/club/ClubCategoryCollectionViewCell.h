//
//  ClubCategoryCollectionViewCell.h
//  Fuzzie
//
//  Created by joma on 6/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubCategoryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *vCategory;
@property (weak, nonatomic) IBOutlet UIImageView *ivCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbCategory;

@property (strong, nonatomic) NSDictionary *dict;

- (void)setCell:(NSDictionary*)dict;

@end
