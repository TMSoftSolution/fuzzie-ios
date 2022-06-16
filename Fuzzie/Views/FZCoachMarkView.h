//
//  FZCoachMarkView.h
//  Fuzzie
//
//  Created by mac on 7/19/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FZCoachMarkViewDelegate <NSObject>

@optional
- (void) coachMarkerViewTapped;
@optional
- (void) coachMarkerTapped;

@end

@interface FZCoachMarkView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clubButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) id<FZCoachMarkViewDelegate> delegate;

@end
