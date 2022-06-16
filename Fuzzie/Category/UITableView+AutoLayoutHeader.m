//
//  UITableView+AutoLayoutHeader.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 23/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "UITableView+AutoLayoutHeader.h"

@implementation UITableView (AutoLayoutHeader)

- (void)setAndlayoutTableHeaderView:(UIView *)tableHeader {
    
    [tableHeader setNeedsLayout];
    [tableHeader layoutIfNeeded];
    CGFloat height = [tableHeader systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = tableHeader.frame;
    frame.size.height = height;
    tableHeader.frame = frame;
    self.tableHeaderView = tableHeader;
    
    DDLogVerbose(@"Height: %f", height);
}

@end
