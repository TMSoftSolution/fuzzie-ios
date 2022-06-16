//
//  FZPopButton.m
//  Fuzzie
//
//  Created by mac on 4/10/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FZPopButton.h"

@implementation FZPopButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor colorWithHexString:HEX_COLOR_RED];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(15.0, 15.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
        self.layer.masksToBounds = YES;

    }
    
    return self;
}


@end
