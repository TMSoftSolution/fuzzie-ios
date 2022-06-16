//
//  FZDashLine.m
//  Fuzzie
//
//  Created by joma on 4/7/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "FZDashLine.h"

@interface FZDashLine()

@property (nonatomic, strong) UIBezierPath *dashPath;

@end

@implementation FZDashLine

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (void)layoutSubviews {
    [self drawDash];
}

- (void)drawDash {

    self.dashWidth = self.dashWidth ? : 1;
    self.dashPadding = self.dashPadding ? : 1;
    self.dashColor = self.dashColor ? : [UIColor grayColor];
    
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    shapeLayer.strokeColor = self.dashColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = self.frame.size.height;
    shapeLayer.geometryFlipped = YES;
    
    shapeLayer.lineDashPattern = @[@(self.dashWidth), @(self.dashPadding)];
    [self.dashPath moveToPoint:CGPointZero];
    [self.dashPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 0)];
    
    shapeLayer.path = self.dashPath.CGPath;
}

- (UIBezierPath *)dashPath {
    if (!_dashPath) {
        _dashPath = [UIBezierPath new];
    }
    
    return _dashPath;
}


@end
