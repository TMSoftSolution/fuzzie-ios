//
//  ClubSubCategoryFilterTypeTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/26/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubSubCategoryFilterTypeTableViewCell.h"

@implementation ClubSubCategoryFilterTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    [self addGestureRecognizer:tapGuesture];
    
}

- (void)setCell:(NSDictionary *)component checked:(BOOL)checked{
    
    if (component) {
        
        self.component = component;
        
        self.lbName.text = self.component[@"name"];
    }
    
    if (checked) {
        
        self.ivChecked.image  = [UIImage imageNamed:@"bag_selected"];
        [CommonUtilities setView:self.ivChecked withCornerRadius:0.0f withBorderColor:[UIColor colorWithHexString:@"#939393"] withBorderWidth:0.0f];
        
    } else {
        
        self.ivChecked.image = nil;
        [CommonUtilities setView:self.ivChecked withCornerRadius:8.0f withBorderColor:[UIColor colorWithHexString:@"#939393"] withBorderWidth:1.0f];
    }
}

- (void)cellTapped{

    if ([self.delegate respondsToSelector:@selector(componentSelected:)]) {
        [self.delegate componentSelected:self.component];
    }
}

@end
