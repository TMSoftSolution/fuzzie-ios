//
//  ClubSettingProfileTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubSettingProfileTableViewCellDelegate <NSObject>

- (void)extendButtonPressed;

@end

@interface ClubSettingProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ClubSettingProfileTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnExtend;
@property (weak, nonatomic) IBOutlet UIImageView *ivAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbDate1;

- (IBAction)extendButtonPressed:(id)sender;

@end
