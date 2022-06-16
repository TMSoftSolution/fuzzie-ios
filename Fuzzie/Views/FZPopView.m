//
//  FZPopView.m
//  Fuzzie
//
//  Created by mac on 4/10/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FZPopView.h"

@implementation FZPopView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [FLAnimatedImage setLogBlock:^(NSString *logString, FLLogLevel logLevel) {
        // Using NSLog
        NSLog(@"%@", logString);
        
        // ...or CocoaLumberjackLogger only logging warnings and errors
        if (logLevel == FLLogLevelError) {
            DDLogError(@"%@", logString);
        } else if (logLevel == FLLogLevelWarn) {
            DDLogWarn(@"%@", logString);
        }
    } logLevel:FLLogLevelWarn];
    
    NSString* path = [[NSBundle mainBundle] pathForResource: @"process" ofType: @"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile: path];
    self.loader.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:gifData];
    
    self.maskView.backgroundColor = [UIColor whiteColor];
    self.maskView.layer.masksToBounds = YES;
    self.maskView.layer.cornerRadius = 15;

}

- (void)hidePop{
    self.hidden = true;
    if (self.loader.isAnimating) {
        [self.loader stopAnimating];
    }
}

- (void)showNormalWith:(NSString *)title{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-craft"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = title;
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 10;
    self.maskViewHeightAnchor.constant = 210;
    self.bodyHeightAnchor.constant = 0;
    self.buttonHeightAnchor.constant = 0;
    self.loader.hidden = false;
    [self.loader startAnimating];
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
}

- (void)showProcessing{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-craft"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = @"PROCESSING";
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 10;
    self.maskViewHeightAnchor.constant = 210;
    self.bodyHeightAnchor.constant = 0;
    self.buttonHeightAnchor.constant = 0;
    self.loader.hidden = false;
    [self.loader startAnimating];
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
}

- (void)showProcessing:(NSString*)title{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-craft"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = title;
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 10;
    self.maskViewHeightAnchor.constant = 210;
    self.bodyHeightAnchor.constant = 0;
    self.buttonHeightAnchor.constant = 0;
    self.loader.hidden = false;
    [self.loader startAnimating];
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
}

- (void)showCrafting{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-craft"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = @"CRAFTING";
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 10;
    self.maskViewHeightAnchor.constant = 230;
    self.bodyHeightAnchor.constant = 40;
    self.lbBody.text = @"The Bear is creating your account.";
    self.buttonHeightAnchor.constant = 0;
    self.loader.hidden = false;
    [self.loader startAnimating];
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
}

- (void)showVerifying{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-craft"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = @"VERIFYING";
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 10;
    self.maskViewHeightAnchor.constant = 210;
    self.bodyHeightAnchor.constant = 0;
    self.buttonHeightAnchor.constant = 0;
    self.loader.hidden = false;
    [self.loader startAnimating];
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
}

- (void)resendingCode{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-craft"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = @"Resending code";
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 10;
    self.maskViewHeightAnchor.constant = 210;
    self.bodyHeightAnchor.constant = 0;
    self.buttonHeightAnchor.constant = 0;
    self.loader.hidden = false;
    [self.loader startAnimating];
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
}

- (void)showSuccess{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-good"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = @"SUCCESS!";
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 0;
    self.maskViewHeightAnchor.constant = 210;
    self.bodyHeightAnchor.constant = 0;
    self.buttonHeightAnchor.constant = 0;
    self.loader.hidden = true;
    if ([self.loader isAnimating]) {
        [self.loader stopAnimating];
        
    }
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
    
}

- (void)showSuccess:(NSString*)title{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-good"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = title;
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 0;
    self.maskViewHeightAnchor.constant = 210;
    self.bodyHeightAnchor.constant = 0;
    self.buttonHeightAnchor.constant = 0;
    self.loader.hidden = true;
    if ([self.loader isAnimating]) {
        [self.loader stopAnimating];
        
    }
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
    
}

- (void)showSuccess:(NSString*)message buttonTitle:(NSString*)title{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-good"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = @"SUCCESS!";
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 0;
    self.maskViewHeightAnchor.constant = 250;
    self.bodyHeightAnchor.constant = 60;
    self.lbBody.text = message;
    self.buttonHeightAnchor.constant = 50;
    [self.btnOk setTitle:title forState:UIControlStateNormal];
    self.loader.hidden = true;
    if ([self.loader isAnimating]) {
        [self.loader stopAnimating];
        
    }
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
    
}

- (void)showSuccess:(NSString*)successTitle withMessage:(NSString*) message buttonTitle:(NSString*)title{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-good"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = successTitle;
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 0;
    self.maskViewHeightAnchor.constant = 250;
    self.bodyHeightAnchor.constant = 60;
    self.lbBody.text = message;
    self.buttonHeightAnchor.constant = 50;
    [self.btnOk setTitle:title forState:UIControlStateNormal];
    self.loader.hidden = true;
    if ([self.loader isAnimating]) {
        [self.loader stopAnimating];
        
    }
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
    
}

- (void)showFail:(NSString *const)message {
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-dead"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = @"OOPS!";
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 0;
    self.maskViewHeightAnchor.constant = 250;
    self.bodyHeightAnchor.constant = 60;
    self.lbBody.text = message;
    self.buttonHeightAnchor.constant = 50;
    [self.btnOk setTitle:@"OK" forState:UIControlStateNormal];
    self.loader.hidden = true;
    if ([self.loader isAnimating]) {
        [self.loader stopAnimating];
        
    }
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
    
}

- (void)showFail:(NSString *const)message withErrorCode:(NSInteger)errorCode{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-dead"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = @"OOPS!";
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 0;
    self.maskViewHeightAnchor.constant = 250;
    self.bodyHeightAnchor.constant = 60;
    self.lbBody.text = message;
    self.buttonHeightAnchor.constant = 50;
    self.loader.hidden = true;
    if ([self.loader isAnimating]) {
        [self.loader stopAnimating];
        
    }
    
    self.errorCode = errorCode;
    if (self.errorCode == 406 || self.errorCode == 422) {
        self.btnSign.hidden = false;
        [self.btnOk setTitle:@"TRY AGAIN" forState:UIControlStateNormal];
        
    } else {
        self.btnSign.hidden = true;
        [self.btnOk setTitle:@"OK" forState:UIControlStateNormal];
    }
    self.btnCancel.hidden = true;
}


- (void)showFail:(NSString *const)message buttonTitle:(NSString*)title{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-dead"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = @"OOPS!";
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 0;
    self.bodyHeightAnchor.constant = 60;
    self.maskViewHeightAnchor.constant = 250;
    self.lbBody.text = message;
    self.buttonHeightAnchor.constant = 50;
    [self.btnOk setTitle:title forState:UIControlStateNormal];
    self.loader.hidden = true;
    if ([self.loader isAnimating]) {
        [self.loader stopAnimating];
        
    }
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
}

- (void)showEmptyError:(NSString*)message{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-dead"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = @"OOPS!";
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 0;
    self.bodyHeightAnchor.constant = [self estimateBodyHeightWith:message];
    self.maskViewHeightAnchor.constant = [self estimateBodyHeightWith:message] + 190;
    self.lbBody.text = message;
    self.buttonHeightAnchor.constant = 50;
    [self.btnOk setTitle:@"OK" forState:UIControlStateNormal];
    self.loader.hidden = true;
    if ([self.loader isAnimating]) {
        [self.loader stopAnimating];
        
    }
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
    
}

- (void)showEmptyError:(NSString*)message buttonTitle:(NSString*)title{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-dead"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = @"OOPS!";
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 0;
    self.maskViewHeightAnchor.constant = [self estimateBodyHeightWith:message] + 190;
    self.bodyHeightAnchor.constant = [self estimateBodyHeightWith:message];
    self.lbBody.text = message;
    self.buttonHeightAnchor.constant = 50;
    [self.btnOk setTitle:title forState:UIControlStateNormal];
    self.loader.hidden = true;
    if ([self.loader isAnimating]) {
        [self.loader stopAnimating];
        
    }
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
    
}

- (void)showClipboardCopy:(NSString*)body{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"glass_bear"]];
    self.lbTitle.hidden = true;
    self.titleTopAnchor.constant = 0;
    self.stateImageTopAnchor.constant = 10;
    self.stateImageCenterAnchor.constant = 0;
    self.maskViewHeightAnchor.constant = 190;
    self.bodyHeightAnchor.constant = 30;
    self.lbBody.text = body;
    self.buttonHeightAnchor.constant = 0;
    self.loader.hidden = true;
    if ([self.loader isAnimating]) {
        [self.loader stopAnimating];
        
    }
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
}

- (void)showRedeem{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-baby"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = @"REDAY TO REDEEM?";
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 0;
    self.maskViewHeightAnchor.constant = 290;
    self.bodyHeightAnchor.constant = 80;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"You will have 60 minutes to access your Merchant gift code."];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:14] range: NSMakeRange(14, 10)];
    [self.lbBody setAttributedText:string];
    self.buttonHeightAnchor.constant = 50;
    [self.btnOk setTitle:@"YES, REDEEM NOW" forState:UIControlStateNormal];
    self.loader.hidden = true;
    if ([self.loader isAnimating]) {
        [self.loader stopAnimating];
        
    }
    self.btnSign.hidden = YES;
    self.btnCancel.hidden = NO;
}

- (void)showPromoError:(NSString*)message{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:@"bear-dead"]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = @"OOPS!";
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 0;
    self.bodyHeightAnchor.constant = [self estimateBodyHeightWith:message];
    self.maskViewHeightAnchor.constant = [self estimateBodyHeightWith: message] + 190;
    self.lbBody.text = message;
    self.buttonHeightAnchor.constant = 50;
    [self.btnOk setTitle:@"GOT IT" forState:UIControlStateNormal];
    self.loader.hidden = true;
    if ([self.loader isAnimating]) {
        [self.loader stopAnimating];
        
    }
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
}

- (CGFloat)estimateBodyHeightWith:(NSString*)string{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_REGULAR size:14] range: NSMakeRange(0, string.length)];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.lineHeightMultiple = 1.1;
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
    CGFloat width = 200;
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height + 20;
}

- (CGFloat)estimateBodyHeight:(NSAttributedString*)string{
    CGFloat width = 200;
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height + 40;
}

- (void)showError:(NSString *)message headerTitle:(NSString *)headerTitle buttonTitle:(NSString *)buttonTitle image:(NSString *)image{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:image]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = headerTitle;
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 0;
    self.bodyHeightAnchor.constant = [self estimateBodyHeightWith:message];
    self.maskViewHeightAnchor.constant = [self estimateBodyHeightWith: message] + 190;
    self.lbBody.text = message;
    self.buttonHeightAnchor.constant = 50;
    [self.btnOk setTitle:buttonTitle forState:UIControlStateNormal];
    self.loader.hidden = true;
    if ([self.loader isAnimating]) {
        [self.loader stopAnimating];
        
    }
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
}

- (void)showErrorWith:(NSAttributedString *)message headerTitle:(NSString *)headerTitle buttonTitle:(NSString *)buttonTitle image:(NSString *)image{
    self.hidden = false;
    [self.stateImage setImage:[UIImage imageNamed:image]];
    self.lbTitle.hidden = false;
    self.lbTitle.text = headerTitle;
    self.titleTopAnchor.constant = 30;
    self.stateImageTopAnchor.constant = 20;
    self.stateImageCenterAnchor.constant = 0;
    self.bodyHeightAnchor.constant = [self estimateBodyHeight:message];
    self.maskViewHeightAnchor.constant = [self estimateBodyHeight: message] + 190;
    self.lbBody.attributedText = message;
    self.buttonHeightAnchor.constant = 50;
    [self.btnOk setTitle:buttonTitle forState:UIControlStateNormal];
    self.loader.hidden = true;
    if ([self.loader isAnimating]) {
        [self.loader stopAnimating];
        
    }
    self.btnSign.hidden = true;
    self.btnCancel.hidden = true;
}

- (IBAction)okButtonPressed:(id)sender {
    [self.delegate okButtonClicked];
}

- (IBAction)signButtonPressed:(id)sender{
    [self.delegate signButttonClicked];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.delegate cancelButtonClicked];
}

@end
