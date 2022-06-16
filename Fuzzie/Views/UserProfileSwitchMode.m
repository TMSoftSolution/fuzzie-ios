//
//  UserProfileSwitchMode.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/23/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "UserProfileSwitchMode.h"


@interface UserProfileSwitchMode ()<UIGestureRecognizerDelegate>
@end;
@implementation UserProfileSwitchMode

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mode = UserProfileModeLike;
    
    
    UITapGestureRecognizer *tapLike = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapped:)];
    tapLike.delegate = self;
    [self.buttonLike addGestureRecognizer:tapLike];
    self.buttonLike.tag = UserProfileModeLike;
    
    UITapGestureRecognizer *tapWishlisted = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapped:)];
    tapWishlisted.delegate = self;
    [self.buttonWishlist addGestureRecognizer:tapWishlisted];
    self.buttonWishlist.tag = UserProfileModeWhishList;
    
    
}


- (void)setNbLike:(int)nbLike {
    if (nbLike > 0) {
        self.likeLabel.text = [NSString stringWithFormat:@"LIKED (%i)",nbLike];
    } else{
        self.likeLabel.text = @"LIKED";
    }
    
}

- (void)setNbWishlisted:(int)nbWishlisted {
    if (nbWishlisted > 0) {
        self.wishlistLabel.text = [NSString stringWithFormat:@"WISHLISTED (%i)",nbWishlisted];
    } else{
        self.wishlistLabel.text = @"WISHLISTED";
    }
    
}
    
- (void)refreshMode:(NSInteger)mode {
    
    self.mode = mode;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         if (mode == UserProfileModeWhishList) {
                             weakSelf.likeLabel.textColor = [UIColor colorWithHexString:@"#434343"];
                             weakSelf.wishlistLabel.textColor = [UIColor colorWithHexString:@"#FA3E3F"];
                             weakSelf.likeFocusBar.layer.opacity = 0;
                             weakSelf.whishListFocusBar.layer.opacity = 1;
                         } else {
                             weakSelf.likeLabel.textColor = [UIColor colorWithHexString:@"#FA3E3F"];
                             weakSelf.wishlistLabel.textColor = [UIColor colorWithHexString:@"#434343"];
                             weakSelf.likeFocusBar.layer.opacity = 1;
                             weakSelf.whishListFocusBar.layer.opacity = 0;
                         }
                     }
                     completion:nil];
    
}

- (void)buttonTapped:(UITapGestureRecognizer *)sender
{
    if ([sender.view isKindOfClass:[UIView class]]) {

        if ([self.delegate respondsToSelector:@selector(modeChanged:)]) {
            UserProfileMode mode = sender.view.tag;
            if (mode != self.mode) {
                self.mode = mode;
                [self refreshMode:mode];
                if (mode == UserProfileModeWhishList) {
                    [self.delegate modeChanged:UserProfileModeWhishList];
                } else {
                  [self.delegate modeChanged:UserProfileModeLike];
                }
            }
        }
    }
}


@end
