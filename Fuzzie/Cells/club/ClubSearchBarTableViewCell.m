//
//  ClubSearchBarTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/24/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubSearchBarTableViewCell.h"

@implementation ClubSearchBarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.searchView withBackground:[UIColor colorWithHexString:@"#F1F1F1"] withRadius:2.5f];
}

- (IBAction)searchButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(searchButtonPressed)]) {
        [self.delegate searchButtonPressed];
    }
}

@end
