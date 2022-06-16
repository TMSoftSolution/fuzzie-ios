//
//  GiftSenderInfoTableViewCell.h
//  Fuzzie
//
//  Created by mac on 6/22/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZFacebookFriend.h"
#import "GiftReceiverAvatarView.h"

@interface GiftSenderInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) FZFacebookFriend *sender;
@property (strong, nonatomic) NSString *message;

@property (weak, nonatomic) IBOutlet UIView *senderView;
@property (weak, nonatomic) IBOutlet UILabel *lbMessage;

@property (strong, nonatomic) GiftReceiverAvatarView *avatarView;

- (void)setGiftSenderInfo:(FZFacebookFriend *)sender withMessage:(NSString *)message;


@end
