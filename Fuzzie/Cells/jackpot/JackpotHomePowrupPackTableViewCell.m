//
//  JackpotHomePowrupPackTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 2/9/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "JackpotHomePowrupPackTableViewCell.h"

@implementation JackpotHomePowrupPackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSString *colorKey = @"color";
    NSString *locationKey = @"location";
    NSArray *gradientColorsAndLocations = (@[
                                             @{colorKey: [UIColor colorWithHexString:@"#37A7ED"],locationKey: @(0.0f)},
                                             @{colorKey: [UIColor colorWithHexString:@"#4260BB"],locationKey: @(1.0f)}
                                             ]);
    self.packContainerView.fillColor = [UIColor colorWithHexString:@"37A7ED"];
    self.packContainerView.gradientColorsAndLocations = gradientColorsAndLocations;
    self.packContainerView.gradientDirection = TKGradientDirectionHorizontal | TKGradientDirectionDown;
    self.packContainerView.cornerRadius = 4.0f;
}

- (IBAction)powerupPackBannerClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(powerupPackBannerClicked)]) {
        [self.delegate powerupPackBannerClicked];
    }
}

@end
