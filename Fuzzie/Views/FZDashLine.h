//
//  FZDashLine.h
//  Fuzzie
//
//  Created by joma on 4/7/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface FZDashLine : UIView

@property (nonatomic, assign) IBInspectable CGFloat dashWidth;
@property (nonatomic, assign) IBInspectable CGFloat dashPadding;
@property (nonatomic, strong) IBInspectable UIColor *dashColor;

@end
