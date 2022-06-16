//
//  JackpotHeaderView.h
//  Fuzzie
//
//  Created by mac on 9/8/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JackpotHeaderViewDelegate <NSObject>

- (void)learnMoreButtonPressed;
- (void)liveDrawButtonPressed;

@end

@interface JackpotHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lbDay;
@property (weak, nonatomic) IBOutlet UILabel *lbHour;
@property (weak, nonatomic) IBOutlet UILabel *lbMin;
@property (weak, nonatomic) IBOutlet UILabel *lbSec;
@property (weak, nonatomic) IBOutlet UILabel *lbBody;
@property (weak, nonatomic) IBOutlet UIButton *btnLiveDraw;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeContainerHeightAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnLiveDrawHeightAnchor;

@property (weak, nonatomic) id<JackpotHeaderViewDelegate> delegate;
@property (strong, nonatomic) NSTimer *timer;

+ (CGFloat)estimateHeight;
- (void)startTimer;
- (void)endTimer;
- (void)updateLiveDrawState;
@end
