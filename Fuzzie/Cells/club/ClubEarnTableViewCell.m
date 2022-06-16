//
//  ClubEarnTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubEarnTableViewCell.h"

@implementation ClubEarnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:HEX_COLOR_RED];

}


- (IBAction)settingButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(settingButtonPressed)]) {
        [self.delegate settingButtonPressed];
    }
}

@end
