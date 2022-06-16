//
//  ClubExclusiveView.m
//  Fuzzie
//
//  Created by joma on 12/7/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubExclusiveView.h"

@implementation ClubExclusiveView

- (instancetype)init{
    
    if (self == [super init]) {
        
        [CommonUtilities setView:self.mainView withCornerRadius:13.0f];
        [CommonUtilities setView:self.btnExplore withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
        [CommonUtilities setView:self.btnClose withCornerRadius:self.btnClose.frame.size.width/2];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self == [super initWithCoder:aDecoder]) {
        
        [CommonUtilities setView:self.mainView withCornerRadius:13.0f];
        [CommonUtilities setView:self.btnExplore withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
        [CommonUtilities setView:self.btnClose withCornerRadius:self.btnClose.frame.size.width/2];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        [CommonUtilities setView:self.mainView withCornerRadius:13.0f];
        [CommonUtilities setView:self.btnExplore withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
        [CommonUtilities setView:self.btnClose withCornerRadius:self.btnClose.frame.size.width/2];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
 
    [CommonUtilities setView:self.mainView withCornerRadius:13.0f];
    [CommonUtilities setView:self.btnExplore withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.btnClose withCornerRadius:self.btnClose.frame.size.width/2];
}

- (IBAction)exploreButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clubExclusiveViewExploreButtonPressed)]) {
        [self.delegate clubExclusiveViewExploreButtonPressed];
    }
}

- (IBAction)closeButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clubExclusiveViewCloseButtonPressed)]) {
        [self.delegate clubExclusiveViewCloseButtonPressed];
    }
}
@end
