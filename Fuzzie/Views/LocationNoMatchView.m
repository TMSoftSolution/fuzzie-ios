//
//  LocationNoMatchView.m
//  Fuzzie
//
//  Created by joma on 12/13/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "LocationNoMatchView.h"

@implementation LocationNoMatchView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [CommonUtilities setView:self.btnChange withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
}

- (IBAction)changeButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(locationNoMatchViewChangeButtonPressed)]) {
        [self.delegate locationNoMatchViewChangeButtonPressed];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(locationNoMatchViewCancelButtonPressed)]) {
        [self.delegate locationNoMatchViewCancelButtonPressed];
    }
}
@end
