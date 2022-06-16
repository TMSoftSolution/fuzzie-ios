//
//  PromoCodeSuccessView.h
//  Fuzzie
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZPopButton.h"

@protocol PromoCodeSuccessViewDelegate <NSObject>

- (void)promoCodeSucceeViewDoneButtonPressed;

@end

@interface PromoCodeSuccessView : UIView

@property (weak, nonatomic) id<PromoCodeSuccessViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UILabel *lbCashback;
@property (weak, nonatomic) IBOutlet FZPopButton *btnDone;

- (IBAction)donButtonPressed:(id)sender;

- (void)showCashback:(CGFloat)cashback;

@end
