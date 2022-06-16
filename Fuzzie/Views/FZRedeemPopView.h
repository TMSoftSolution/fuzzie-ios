//
//  FZRedeemPopView.h
//  Fuzzie
//
//  Created by mac on 5/11/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZPopButton.h"

@protocol FZRedeemPopViewDelegate <NSObject>

- (void)redeemButtonPressed;
- (void)cancelButtonPressed;

@end

@interface FZRedeemPopView : UIView
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet FZPopButton *redeemButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *body;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maskViewHeightAnchor;
@property (weak, nonatomic) IBOutlet UIImageView *bearImage;

@property (weak, nonatomic) id <FZRedeemPopViewDelegate> delegate;

- (void)setGeneralStyle:(NSString*)title body:(NSString*)body image:(NSString*)image buttonTitle1:(NSString*)buttonTitle1 buttonTitle2:(NSString*)buttonTitle2;
- (void)setRedeemNormalStyle;
- (void)setRedeemSuccessStyle;
- (void)setResetPasswordStyle;
- (void)setDeliveryMethodDoneStyle;
- (void)setGiftItBackConfirmStyle;
- (void)setGiftEditBackConfirmStyle;
- (void)setPromoCodeDeleteStyle;
- (void)setPaymentMethodDeleteStyle;
- (void)setApplePaySetupStyle;
- (void)setTopUpPurchaseStyle;

@end
