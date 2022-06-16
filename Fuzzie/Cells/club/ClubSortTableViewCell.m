//
//  ClubSortTableViewCell.m
//  Fuzzie
//
//  Created by joma on 8/31/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubSortTableViewCell.h"

@implementation ClubSortTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCell:(BOOL)sortDistance{
    
    self.sortDistance = sortDistance;
    
    if (sortDistance) {
        
        [CommonUtilities setView:self.vDistance withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:25.0f withBorderColor:[UIColor clearColor] withBorderWidth:0.0f];
        self.ivDistance.image = [UIImage imageNamed:@"icon-club-store-location-white"];
        self.lbDistance.textColor = [UIColor whiteColor];
        
        [CommonUtilities setView:self.vRecent withBackground:[UIColor whiteColor] withRadius:25.0f withBorderColor:[UIColor colorWithHexString:@"#939393"] withBorderWidth:1.0f];
        self.ivRecent.image = [UIImage imageNamed:@"icon-recent-grey"];
        self.lbRecent.textColor = [UIColor colorWithHexString:@"#939393"];
        
    } else {
        
        [CommonUtilities setView:self.vDistance withBackground:[UIColor whiteColor] withRadius:25.0f withBorderColor:[UIColor colorWithHexString:@"#939393"] withBorderWidth:1.0f];
        self.ivDistance.image = [UIImage imageNamed:@"icon-club-store-location-grey"];
        self.lbDistance.textColor = [UIColor colorWithHexString:@"#939393"];
        
        [CommonUtilities setView:self.vRecent withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:25.0f withBorderColor:[UIColor clearColor] withBorderWidth:0.0f];
        self.ivRecent.image = [UIImage imageNamed:@"icon-recent-white"];
        self.lbRecent.textColor = [UIColor whiteColor];
        
       
    }
    
}

- (IBAction)distancePressed:(id)sender {
    
    if (!self.sortDistance) {
        
        if ([self.delegate respondsToSelector:@selector(sortSelected:)]) {
            [self.delegate sortSelected:YES];
        }
    }
}

- (IBAction)recentPressed:(id)sender {
    
    if (self.sortDistance) {
        
        if ([self.delegate respondsToSelector:@selector(sortSelected:)]) {
            [self.delegate sortSelected:NO];
        }
    }
}
@end
