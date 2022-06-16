//
//  InstructionTableViewCell.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 18/3/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "InstructionTableViewCell.h"

@implementation InstructionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bodyLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.bodyLabel.delegate = self;
    self.bodyLabel.linkAttributes = @{ (id)kCTForegroundColorAttributeName: [UIColor colorWithHexString:HEX_COLOR_RED],
                                       (id)kCTUnderlineStyleAttributeName : [NSNumber numberWithInt:NSUnderlineStyleNone] };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
