//
//  DropDownMenuTableViewCell.m
//  Fuzzie
//
//  Created by mac on 9/20/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "DropDownMenuTableViewCell.h"

@implementation DropDownMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    [self addGestureRecognizer:tapGusture];
}

- (void)setCell:(NSString *)date andPosition:(int)position{
    
    self.position = position;
    
    NSDate *drawDate = [[GlobalConstants dateApiFormatter] dateFromString:date];
    NSDateFormatter *dateFormatter1 = [NSDateFormatter new];
    [dateFormatter1 setDateFormat:@"dd.MM.YYYY"];
    self.lbItem.text = [dateFormatter1 stringFromDate:drawDate];
}

- (void)cellTapped{
    if ([self.delegate respondsToSelector:@selector(menuItemSelected:)]) {
        [self.delegate menuItemSelected:self.position];
    }
}

@end
