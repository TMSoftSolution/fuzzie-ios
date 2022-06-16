//
//  ClubSubscibeTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/16/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubSubscibeTableViewCell.h"

@implementation ClubSubscibeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.lbJoin withCornerRadius:4.0f withBorderColor:[UIColor whiteColor] withBorderWidth:1.0f];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(join)];
    [self addGestureRecognizer:gesture];
}

- (void)join{
    
    if ([self.delegate respondsToSelector:@selector(subscribeButtonPressed)]) {
        [self.delegate subscribeButtonPressed];
    }
}

@end
