//
//  ClubStoreInfoTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/13/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreInfoTableViewCell.h"

@implementation ClubStoreInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.btnDirection withCornerRadius:2.0f withBorderColor:[UIColor colorWithHexString:HEX_COLOR_RED] withBorderWidth:1.0f];
    [CommonUtilities setView:self.btnCall withCornerRadius:2.0f withBorderColor:[UIColor colorWithHexString:HEX_COLOR_RED] withBorderWidth:1.0f];
}

- (void)setCell:(FZStore *)store{
    
    if (store) {
        
        self.store = store;
        
        self.lbStoreName.text = store.name;
        self.lbAddress.text = store.address;
        self.lbBusinessTime.text = store.businessHours;
        
    }
}

- (IBAction)directionButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(directionButtonPressed:)]) {
        [self.delegate directionButtonPressed:self.store];
    }
}

- (IBAction)callButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(callButtonPressed:)]) {
        [self.delegate callButtonPressed:self.store];
    }
}

@end
