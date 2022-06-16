//
//  ClubFilterTagCollectionViewCell.m
//  Fuzzie
//
//  Created by joma on 6/25/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubFilterTagCollectionViewCell.h"

@implementation ClubFilterTagCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
}

- (void)setCell:(NSDictionary *)dict{
    
    if (dict) {
        
        self.dict = dict;
        
        self.lbTag.text = [dict[@"name"] uppercaseString];
    }
}

- (IBAction)deleteButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(tagDeleteButtonPressed:)]) {
        [self.delegate tagDeleteButtonPressed:self.dict];
    }
}
@end
