//
//  ClubStoreOtherLinkTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/13/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreOtherLinkTableViewCell.h"

@implementation ClubStoreOtherLinkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *guesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    [self addGestureRecognizer:guesture];
}

- (void)setCellWithType:(NSUInteger)linkType{
    
    self.linkType = linkType;
    
    if(linkType == kLinkTypMoreLocation) {
        
        self.lbType.text = @"more store locations";
        self.ivType.image = [UIImage imageNamed:@"icon-store-location"];
        
    } else if(linkType == kLinkTypeGrab){
        
        self.lbType.text = @"Book a ride with Grab";
        self.ivType.image = [UIImage imageNamed:@"icon-grab"];
        
    } else if(linkType == kLinkTypeQuandoo){
        
        self.lbType.text = @"Reserve a table with Quandoo";
        self.ivType.image = [UIImage imageNamed:@"icon-quandoo"];
        
    }
}

- (void)cellTapped{
    
    if ([self.delegate respondsToSelector:@selector(otherLinkCellTapped:)]) {
        [self.delegate otherLinkCellTapped:self.linkType];
    }
}

@end
