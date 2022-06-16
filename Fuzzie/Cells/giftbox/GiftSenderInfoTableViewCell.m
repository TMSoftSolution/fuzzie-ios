//
//  GiftSenderInfoTableViewCell.m
//  Fuzzie
//
//  Created by mac on 6/22/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "GiftSenderInfoTableViewCell.h"

@implementation GiftSenderInfoTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UINib *customNib = [UINib nibWithNibName:@"GiftReceiverAvatarView" bundle:nil];
    self.avatarView = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self.senderView addSubview:self.avatarView];
}

- (void)setGiftSenderInfo:(FZFacebookFriend *)sender withMessage:(NSString *)message{
    
    self.sender = sender;
    self.message = message;
    
    [self.avatarView setReceiverView:self.sender];
    
    self.lbMessage.text = message;
    
}


@end
