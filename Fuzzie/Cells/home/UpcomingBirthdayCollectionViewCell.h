//
//  UpcomingBirthdayCollectionViewCell.h
//  Fuzzie
//
//  Created by mac on 6/26/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpcomingBirthdayCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbBirth;

@property (strong, nonatomic) FZUser *userInfo;

- (void)setCellWithUser:(FZUser*)userInfo;
@end
