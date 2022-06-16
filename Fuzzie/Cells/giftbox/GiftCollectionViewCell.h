//
//  GiftCollectionViewCell.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 23/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *soldOutIcon;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) NSDictionary *giftDict;
@property (assign, nonatomic) BOOL isActive;

@end
