//
//  OrderHistoryEmptyView.m
//  Fuzzie
//
//  Created by mac on 8/9/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "OrderHistoryEmptyView.h"

@implementation OrderHistoryEmptyView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)refreshSize {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    UIView *parentparentView =  self.superview.superview;
    parentparentView.frame = CGRectMake(0, 0,
                                        self.frame.size.width,
                                        screenHeight);
    
    self.frame = CGRectMake(0, 0,
                            self.frame.size.width,
                            screenHeight);
}

@end
