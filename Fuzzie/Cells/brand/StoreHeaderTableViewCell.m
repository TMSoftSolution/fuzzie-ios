//
//  StoreHeaderTableViewCell.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 24/3/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "StoreHeaderTableViewCell.h"

@implementation StoreHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
    [self.storeAddressLabel addGestureRecognizer:gestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Gestures
- (void)longPressGestureRecognizer:(UIGestureRecognizer *)recognizer
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect:recognizer.view.frame inView:recognizer.view.superview];
    [menuController setMenuVisible:YES animated:YES];
    [recognizer.view becomeFirstResponder];
}

@end
