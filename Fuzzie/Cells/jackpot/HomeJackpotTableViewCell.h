//
//  HomeJackpotTableViewCell.h
//  Fuzzie
//
//  Created by mac on 9/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeJackpotTableViewCellDelegate <NSObject>

- (void)liveDrawButtonPressed;
- (void)jackpotEnterButtonPressed;
- (void)jackpotViewAllButtonPressed;

@end

@interface HomeJackpotTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HomeJackpotTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnEnter;
@property (weak, nonatomic) IBOutlet UIButton *btnViewAll;
@property (weak, nonatomic) IBOutlet UILabel *lbDrawTime;
@property (weak, nonatomic) IBOutlet UILabel *lbBody;
@property (weak, nonatomic) IBOutlet UIView *liveView;
@property (weak, nonatomic) IBOutlet UILabel *livePoint;

@property (nonatomic, strong) NSTimer *timer;

+ (CGFloat)estimageHeight;
- (void)startTimer;
- (void)endTimer;
- (void)updateLiveDrawState;

@end
