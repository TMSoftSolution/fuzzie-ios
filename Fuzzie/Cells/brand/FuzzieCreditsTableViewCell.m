//
//  FuzzieCreditsTableViewCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 3/8/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FuzzieCreditsTableViewCell.h"

@implementation FuzzieCreditsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)topUpButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(topUpPressed)]) {
        [self.delegate topUpPressed];
    }
}


@end
