//
//  InfoBrandTableViewCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/17/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "InfoBrandTableViewCell.h"
#import "CardViewController.h"

@interface InfoBrandTableViewCell()
@end


@implementation InfoBrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellInfoTapped:)];
    pan.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:pan];
}

- (void)cellInfoTapped:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(cellInfoTapped:)]) {
        [self.delegate cellInfoTapped:self.typeCell];
    }
}


@end
