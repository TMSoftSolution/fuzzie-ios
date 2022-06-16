//
//  FZCoachMarkView.m
//  Fuzzie
//
//  Created by mac on 7/19/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FZCoachMarkView.h"
#import "SDVersion.h"

@implementation FZCoachMarkView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [CommonUtilities setView:self.contentView withCornerRadius:3.0f];
    
    UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self addGestureRecognizer:gusture];
    
    if ([SDVersion deviceSize] >= Screen5Dot8inch) {
        
        self.clubButtonBottomConstraint.constant = 22.0f;
        
    } else{
        
        self.clubButtonBottomConstraint.constant = 2.0f;
    }
    
}

- (IBAction)nearbyButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(coachMarkerTapped)]) {
        [self.delegate coachMarkerTapped];
    }
}

- (void)viewTapped:(UITapGestureRecognizer*)gusture{
    if ([self.delegate respondsToSelector:@selector(coachMarkerViewTapped)]) {
        [self.delegate coachMarkerViewTapped];
    }
}



@end
