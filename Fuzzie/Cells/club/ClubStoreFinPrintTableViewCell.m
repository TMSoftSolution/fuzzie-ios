//
//  ClubStoreFinPrintTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/13/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreFinPrintTableViewCell.h"

@implementation ClubStoreFinPrintTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.markView withCornerRadius:2.0f];
}

@end
