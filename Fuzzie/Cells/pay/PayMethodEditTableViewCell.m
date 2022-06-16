//
//  PayMethodEditTableViewCell.m
//  Fuzzie
//
//  Created by mac on 8/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "PayMethodEditTableViewCell.h"

@implementation PayMethodEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    tapGesture.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
}

- (void)setCell:(NSDictionary*)itemDict isSelected:(BOOL)isSelected isEditing:(BOOL)isEditing position:(int)position{
    
    if (itemDict) {
        
        self.itemDict = itemDict;
        self.isSelected = isSelected;
        self.isEditing = isEditing;
        self.position = position;
        
        if ([itemDict[@"card_type"] isEqualToString:@"ENETS"]) {
            
            self.ivCard.image = [UIImage imageNamed:@"icon-nets"];
            self.lbCard.text = @"NETSPay";
            
        } else {
            
            NSURL *imageUrl = [NSURL URLWithString:self.itemDict[@"image_url"]];
            [self.ivCard sd_setImageWithURL:imageUrl];
            
            self.lbCard.text = [NSString stringWithFormat:@"••••••• %@", self.itemDict[@"last_4"]];
        }

        
        if (_isSelected) {
            [self.ivSelect setImage:[UIImage imageNamed:@"bag_selected"]];
        } else {
            [self.ivSelect setImage:[UIImage imageNamed:@"bag_deselected"]];
        }
        
        if (isEditing) {
            
            if ([itemDict[@"card_type"] isEqualToString:@"ENETS"]) {
                
                self.btnDelete.hidden = YES;
                
            } else {
                
                self.btnDelete.hidden = NO;
            }

            self.ivSelect.hidden = YES;
            
        } else{
            
            self.btnDelete.hidden = YES;
            self.ivSelect.hidden = NO;
        }
    }
}

- (IBAction)deleteButtonPressed:(id)sender {
    NSLog(@"Delete Button Clicked");
    if (self.isEditing && ![self.itemDict[@"card_type"] isEqualToString:@"ENETS"]) {
        if ([self.delegate respondsToSelector:@selector(deleteButtonPressed:)]) {
            [self.delegate deleteButtonPressed:self.itemDict];
        }
    }
}

- (void)cellTapped{
    if (!self.isEditing) {
        if([self.delegate respondsToSelector:@selector(cellTapped:position:)]){
            [self.delegate cellTapped:self.itemDict position:self.position];
        }
    }
}



@end
