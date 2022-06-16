//
//  NoResultView.m
//  Fuzzie
//
//  Created by joma on 8/29/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "NoResultView.h"

@implementation NoResultView

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
