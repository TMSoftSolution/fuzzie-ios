//
//  ClubFlashCollectionViewCell.h
//  Fuzzie
//
//  Created by joma on 6/17/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubFlashCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivFlash;
@property (weak, nonatomic) IBOutlet UIImageView *ivCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbCategory;

@property (strong, nonatomic) NSDictionary *offer;

- (void)setCell:(NSDictionary*)offer;

@end
