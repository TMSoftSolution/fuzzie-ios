//
//  FZRedeemPopView.m
//  Fuzzie
//
//  Created by mac on 5/11/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FZRedeemPopView.h"

@implementation FZRedeemPopView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.maskView.backgroundColor = [UIColor whiteColor];
    self.maskView.layer.masksToBounds = YES;
    self.maskView.layer.cornerRadius = 15;
    
}

- (CGFloat)estimateBodyHeightWith:(NSString*)string{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_REGULAR size:14] range: NSMakeRange(0, string.length)];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.lineHeightMultiple = 1.1;
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
    CGFloat width = 220;
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height + 20;
}

- (CGFloat)estimateBodyHeight:(NSMutableAttributedString*)string{
    CGFloat width = 220;
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height + 20;
}

- (void)setGeneralStyle:(NSString *)title body:(NSString *)body image:(NSString *)image buttonTitle1:(NSString *)buttonTitle1 buttonTitle2:(NSString *)buttonTitle2{
    
    self.title.text = title;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:body];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.lineHeightMultiple = 1.3;
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [string addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
    self.body.attributedText = string;
    
    [self.redeemButton setTitle:buttonTitle1 forState:UIControlStateNormal];
    [self.cancelButton setTitle:buttonTitle2 forState:UIControlStateNormal];
    [self.bearImage setImage:[UIImage imageNamed:image]];
    
    self.maskViewHeightAnchor.constant = [self estimateBodyHeight:string] + 240;
}

- (void)setRedeemNormalStyle{
    
    [self.title setText:@"READY TO REDEEM?"];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"After redeeming, your item will be marked as used in 24 hours. You can still access your code anytime later from your Gift Box"];
    
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:14] range: NSMakeRange(53, 9)];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.lineHeightMultiple = 1.3;
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [string addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
    
    [self.body setAttributedText:string];
    [self.redeemButton setTitle:@"YES, REDEEM NOW" forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"No, cancel" forState:UIControlStateNormal];
    self.maskViewHeightAnchor.constant = 350;
}

- (void)setRedeemSuccessStyle{
    [self.title setText:@"READY TO LEAVE?"];
    [self.body setText:@"Are you ready to leave this page?"];
    [self.redeemButton setTitle:@"YES, LEAVE PAGE" forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"No, cancel" forState:UIControlStateNormal];
    self.maskViewHeightAnchor.constant = 290;
}

- (void)setResetPasswordStyle{
    [self.title setText:@"RESET PASSWORD?"];
    [self.body setText:@"Would you like to reset your password? We will send you a reset link to your account email."];
    [self.redeemButton setTitle:@"YES, SEND RESET LINK" forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"No, cancel" forState:UIControlStateNormal];
    self.maskViewHeightAnchor.constant = 320;
}

- (void)setDeliveryMethodDoneStyle{
    [self.title setText:@"HAVE YOU SENT YOUR GIFT?"];
    [self.body setText:@"If you leave this page, you will not be able to return to it later to send your gift."];
    [self.redeemButton setTitle:@"YES, LEAVE PAGE" forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"No, cancel" forState:UIControlStateNormal];
    [self.bearImage setImage:[UIImage imageNamed:@"bear-mustache"]];
    self.maskViewHeightAnchor.constant = 320;
}

- (void)setGiftItBackConfirmStyle{
    [self.title setText:@"DISCARD GIFT?"];
    [self.body setText:@"Sure you would like to discard this gift?"];
    [self.redeemButton setTitle:@"YES, DISCARD GIFT" forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"No, cancel" forState:UIControlStateNormal];
    [self.bearImage setImage:[UIImage imageNamed:@"bear-mustache"]];
    self.maskViewHeightAnchor.constant = 300;
}

- (void)setGiftEditBackConfirmStyle{
    [self.title setText:@"DISCARD CHANGES?"];
    [self.body setText:@"Sure you would like to discard your changes on your gift?"];
    [self.redeemButton setTitle:@"DISCARD" forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.bearImage setImage:[UIImage imageNamed:@"bear-mustache"]];
    self.maskViewHeightAnchor.constant = 300;
}

- (void)setPromoCodeDeleteStyle{
    [self.title setText:@"ARE YOU SURE?"];
    [self.body setText:@"Are you sure you want to delete this promo code?"];
    [self.redeemButton setTitle:@"YES, DELETE" forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"No, cancel" forState:UIControlStateNormal];
    [self.bearImage setImage:[UIImage imageNamed:@"bear-baby"]];
    self.maskViewHeightAnchor.constant = 300;
}

- (void)setPaymentMethodDeleteStyle{
    [self.title setText:@"ARE YOU SURE?"];
    [self.body setText:@"Are you sure you want to delete this payment method?"];
    [self.redeemButton setTitle:@"YES, DELETE" forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"No, cancel" forState:UIControlStateNormal];
    [self.bearImage setImage:[UIImage imageNamed:@"bear-baby"]];
    self.maskViewHeightAnchor.constant = 300;
}

- (void)setApplePaySetupStyle{
    [self.title setText:@"SET UP APPLE PAY"];
    [self.body setText:@"Would you like to set up an Apple Pay account now?"];
    [self.redeemButton setTitle:@"YES, SET UP NOW" forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"No, cancel" forState:UIControlStateNormal];
    [self.bearImage setImage:[UIImage imageNamed:@"bear-baby"]];
    self.maskViewHeightAnchor.constant = 300;
}

- (void)setTopUpPurchaseStyle{
    [self.title setText:@"OOPS!"];
    [self.body setText:@"You have insufficient Fuzzie credits. Top up your credits or earn more cashback."];
    [self.redeemButton setTitle:@"TOP UP CREDITS NOW" forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"Close" forState:UIControlStateNormal];
    [self.bearImage setImage:[UIImage imageNamed:@"bear-dead"]];
    self.maskViewHeightAnchor.constant = 310;
}

- (IBAction)redeemButtonPressed:(id)sender {
    [self.delegate redeemButtonPressed];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate cancelButtonPressed];
}

@end
