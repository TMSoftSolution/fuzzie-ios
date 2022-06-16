//
//  GiftBoxTableViewCell.h
//  Fuzzie
//
//  Created by mac on 5/6/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GiftBoxTableViewCellDelegate <NSObject>

- (void)cellTapped:(NSDictionary*)giftDict isSent:(BOOL)isSent;

@end

@interface GiftBoxTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *sendInfoView;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderName;
@property (weak, nonatomic) IBOutlet UILabel *sendStateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *senderInfoHeightAnchor;

@property (strong, nonatomic) IBOutlet UIImageView *giftImage;
@property (strong, nonatomic) IBOutlet UILabel *giftName;
@property (strong, nonatomic) IBOutlet UILabel *giftPrice;
@property (strong, nonatomic) IBOutlet UILabel *giftBoughtDay;
@property (weak, nonatomic) IBOutlet UIImageView *imageNew;
@property (weak, nonatomic) IBOutlet UIImageView *imageGift;
@property (weak, nonatomic) IBOutlet UIImageView *imageGifting;

@property (weak, nonatomic) id<GiftBoxTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSDictionary *giftDict;
- (void)setCell:(NSDictionary*)dict;
@end
