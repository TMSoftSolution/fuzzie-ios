//
//  FZLocationSettingView.m
//  Fuzzie
//
//  Created by mac on 7/20/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FZLocationSettingView.h"

@implementation FZLocationSettingView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [CommonUtilities setView:self.maskView withCornerRadius:15.0f];
}

- (IBAction)settingButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(settingButtonPressed)]) {
        [self.delegate settingButtonPressed];
    }
}

- (IBAction)laterButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(laterButtonPressed)]) {
        [self.delegate laterButtonPressed];
    }
}

@end
