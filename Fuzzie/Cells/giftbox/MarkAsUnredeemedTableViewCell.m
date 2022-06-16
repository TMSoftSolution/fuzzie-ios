//
//  MarkAsUnredeemedTableViewCell.m
//  Fuzzie
//
//  Created by mac on 6/28/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "MarkAsUnredeemedTableViewCell.h"

@implementation MarkAsUnredeemedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unredeemedTapped:)];
    pan.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:pan];
}

- (void)unredeemedTapped:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(unredeemedTapped)]) {
        [self.delegate unredeemedTapped];
    }
}

@end
