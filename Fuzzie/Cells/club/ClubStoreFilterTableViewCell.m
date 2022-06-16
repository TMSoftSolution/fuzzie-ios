//
//  ClubStoreFilterTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/20/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreFilterTableViewCell.h"

@implementation ClubStoreFilterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    [self addGestureRecognizer:tapGuesture];
    
}

- (void)setCell:(NSDictionary*)category checked:(BOOL)checked{
    
    if (category){
        
        self.category = category;
        self.checked = checked;
        
        if (self.checked) {
            
            [CommonUtilities setView:self.vCategory withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:25.0f withBorderColor:[UIColor clearColor] withBorderWidth:0.0f];
            [self.ivCategory sd_setImageWithURL:[NSURL URLWithString:self.category[@"image_white"]]];
            self.ivCategory.alpha = 1.0f;
            
        } else {
            
            [CommonUtilities setView:self.vCategory withBackground:[UIColor whiteColor] withRadius:25.0f withBorderColor:[UIColor colorWithHexString:@"000000" alpha:0.4f] withBorderWidth:1.0f];
             [self.ivCategory sd_setImageWithURL:[NSURL URLWithString:self.category[@"image_black"]]];
            self.ivCategory.alpha = 0.4f;
        }
        
        self.tvCategory.text = self.category[@"name"];
    }
}

- (void)cellTapped{
    
    if ([self.delegate respondsToSelector:@selector(cellTapped:checked:)]) {
        [self.delegate cellTapped:self.category checked:self.checked];
    }
}

@end
