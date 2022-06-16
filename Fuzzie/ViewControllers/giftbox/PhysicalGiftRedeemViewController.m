//
//  PhysicalGiftRedeemViewController.m
//  Fuzzie
//
//  Created by joma on 4/17/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "PhysicalGiftRedeemViewController.h"
#import "FZWebView2Controller.h"
#import "GiftRedeemSuccessViewController.h"
#import "ZXingObjC.h"
#import "GiftBoxViewController.h"

@interface PhysicalGiftRedeemViewController ()

@property (weak, nonatomic) IBOutlet UILabel *redeemTitle;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *pinTextFields;
@property (weak, nonatomic) IBOutlet UIView *pinView;
@property (weak, nonatomic) IBOutlet UIView *qrCodeView;
@property (weak, nonatomic) IBOutlet UIImageView *ivQRCode;
@property (weak, nonatomic) IBOutlet UIView *barcodeView;
@property (weak, nonatomic) IBOutlet UIImageView *ivBarcode;
@property (weak, nonatomic) IBOutlet UILabel *lbQRCode;
@property (weak, nonatomic) IBOutlet UILabel *lbBarCode;
@property (weak, nonatomic) IBOutlet UIView *vUnredeemed;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelTopConstraint;

@property (strong, nonatomic) NSTimer *redeemTimer;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;
- (IBAction)markAsUnredeemedButtonPressed:(id)sender;

@end

@implementation PhysicalGiftRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[FZData sharedInstance] setActiveOnlineRedeemGiftPage:true];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[FZData sharedInstance] setActiveOnlineRedeemGiftPage:false];
    [self endTimer];
}


- (void)setStyling {
    
    for (UITextField *textField in self.pinTextFields) {
        textField.layer.cornerRadius = 5.0f;
        textField.layer.masksToBounds = YES;
        textField.layer.borderWidth = 1.0f;
        textField.layer.borderColor = [UIColor colorWithWhite:0.0f alpha:0.1f].CGColor;
    }
    
    NSString *redeemType;
    if (self.giftDict[@"gift_card"] && [self.giftDict[@"gift_card"] isKindOfClass:[NSDictionary class]]) {
        
        self.redeemTitle.text = [NSString stringWithFormat:@"%@%@ %@", self.giftDict[@"gift_card"][@"price"][@"currency_symbol"], self.giftDict[@"gift_card"][@"price"][@"value"], self.giftDict[@"gift_card"][@"display_name"]];
        
        redeemType = self.giftDict[@"gift_card"][@"redemption_type"];
        
    } else if (self.giftDict[@"service"] && [self.giftDict[@"service"] isKindOfClass:[NSDictionary class]]){
        
        self.redeemTitle.text = [NSString stringWithFormat:@"%@%@ %@", self.giftDict[@"service"][@"price"][@"currency_symbol"], self.giftDict[@"service"][@"price"][@"value"], self.giftDict[@"service"][@"display_name"]];
        
        redeemType = self.giftDict[@"service"][@"redemption_type"];
    }
    
    if (redeemType) {
        
        NSString *qrCode = self.giftDict[@"qr_code"];
        
        if ([redeemType isEqualToString:@"pin"] || !qrCode || [qrCode isKindOfClass:[NSNull class]]) {
            
            [self showPin];
            
        } else if ([redeemType isEqualToString:@"qr_code"]){
            
            [self showQRCode:qrCode];
            [self updateTimer];
            
        } else if ([redeemType isEqualToString:@"bar_code"]){
            
            [self showBarCode:qrCode];
            [self updateTimer];
            
        } else{
            
            [self showPin];
        }
        
    } else {
        
        [self showPin];
    }
}

- (void)showPin{
    
    self.barcodeView.hidden = YES;
    self.qrCodeView.hidden = YES;
    self.pinView.hidden = NO;
    self.vUnredeemed.hidden = YES;
}

- (void)showBarCode:(NSString*)codeString{
    
    self.barcodeView.hidden = NO;
    self.qrCodeView.hidden = YES;
    self.pinView.hidden = YES;
    
    self.lbBarCode.text = codeString;
    
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    
    ZXEncodeHints *hints = [[ZXEncodeHints alloc] init];
    hints.margin = [NSNumber numberWithInt:0];
    
    ZXBitMatrix *result = [writer encode:codeString
                                  format:kBarcodeFormatCode128
                                   width:900
                                  height:300
                                   hints:hints
                                   error:nil];
    
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        self.ivBarcode.image = [UIImage imageWithCGImage:image.cgimage];
    } else {
        self.ivBarcode.image = nil;
    }
}

- (void)showQRCode:(NSString*)codeString{
    
    self.barcodeView.hidden = YES;
    self.qrCodeView.hidden = NO;
    self.pinView.hidden = YES;
    
    self.lbQRCode.text = codeString;
    
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    
    ZXEncodeHints *hints = [[ZXEncodeHints alloc] init];
    hints.margin = [NSNumber numberWithInt:0];
    
    ZXBitMatrix *result = [writer encode:codeString
                                  format:kBarcodeFormatQRCode
                                   width:300
                                  height:300
                                   hints:hints
                                   error:nil];
    
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        self.ivQRCode.image = [UIImage imageWithCGImage:image.cgimage];
    } else {
        self.ivQRCode.image = nil;
    }
}

- (void)updateTimer{
    
    if (self.giftDict[@"redeemed_time"] && [self.giftDict[@"redeemed_time"] isKindOfClass:[NSNull class]]) {
        self.timeLabelTopConstraint.constant = 16.0f;
        [self startTimer];
    } else{
        self.timeLabelTopConstraint.constant = 4.0f;
        self.timerLabel.text = @"";
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)submitPinIfCompleted {
    
    BOOL completed = YES;
    NSString *marchantPin = @"";
    for (UITextField *textField in self.pinTextFields) {
        if (textField.text.length == 0) {
            completed = NO;
        } else {
            marchantPin = [marchantPin stringByAppendingString:textField.text];
        }
    }
    
    if (!completed) return;
    
    [self showProcessing:YES];
    [self.view endEditing:YES];
    [GiftController redeemGiftCard:self.giftDict withMerchantPin:marchantPin withCompletion:^(NSDictionary *dictionary, NSError *error) {
        [self hidePopView];
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            // Clear TextFields
            for (UITextField *textField in self.pinTextFields) {
                textField.text = @"";
            }
            
            [self showEmptyError:[error localizedDescription] buttonTitle:@"TRY AGAIN" window:YES];
        }
        
        if (dictionary) {
            
            // Remove This Gift from ActiveGifts
            [FZData removeActiveGift:self.giftDict];
            [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
            
            // Add CallBack Gift to the UsedGifts
            if (dictionary && dictionary[@"gift"]) {
                
                if (![FZData alreadyExistUsedGift:dictionary[@"gift"]]) {
                    [[FZData sharedInstance].usedGiftBox insertObject:dictionary[@"gift"] atIndex:0];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USED_GIFTBOX_REFRESHED object:nil];
                }
            }
            
            // Decrease Active Gift Count
            [UserController decreaseActiveGiftCount:1];
            
            GiftRedeemSuccessViewController *successView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"GiftRedeemSuccessView"];
            successView.successDict = self.giftDict;
            [self.navigationController pushViewController:successView animated:YES];
        }
    }];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    textField.text = finalString;
    
    if (finalString.length > 0) {
        NSInteger tag = textField.tag;
        
        if (tag != 3) {
            UITextField *nextTextField = self.pinTextFields[tag+1];
            [nextTextField becomeFirstResponder];
        }
        
        [self submitPinIfCompleted];
    }
    
    return NO;
}

#pragma mark - FZPopViewDelegate
- (void)okButtonClicked{
    [self hidePopView];
    [self.pinTextFields[0] becomeFirstResponder];
}

#pragma mark - Button Actions
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)helpButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"Need help?"];
    
    [actionSheet bk_addButtonWithTitle:@"Read our FAQ" handler:^{
        
        FZWebView2Controller *webView2Controller = [[GlobalConstants extraStoryboard] instantiateViewControllerWithIdentifier:@"Webview2"];
        webView2Controller.URL = @"http://fuzzie.com.sg/faq.html";
        webView2Controller.titleHeader = @"FAQ";
        [self.navigationController pushViewController:webView2Controller animated:YES];
        
    }];
    
    if ([MFMailComposeViewController canSendMail]) {
        
        [actionSheet bk_addButtonWithTitle:@"Email us" handler:^{
            
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            [mailer setSubject: @"Fuzzie Support"];
            [mailer setToRecipients:@[@"support@fuzzie.com.sg"]];
            mailer.navigationBar.tintColor = [UIColor whiteColor];
            mailer.bk_completionBlock = ^( MFMailComposeViewController *mailer, MFMailComposeResult result, NSError* error) {
                
                if (result == MFMailComposeResultSent) {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Email sent!", nil)];
                }
                
                [mailer dismissViewControllerAnimated:YES completion:nil];
            };
            
            [self presentViewController:mailer animated:YES completion:nil];
            
        }];
    }
    
    [actionSheet bk_addButtonWithTitle:@"Facebook us" handler:^{
        NSURL *facebookURL = [NSURL URLWithString:@"http://m.me/fuzzieapp"];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        }
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"Cancel" handler:nil];
    [actionSheet showInView:self.view];
}

- (IBAction)markAsUnredeemedButtonPressed:(id)sender {
    
    [self showProcessing:YES];
    
    [GiftController markAsUnredeemedOnlineGift:self.giftDict[@"id"] withCompletion:^(NSDictionary *dictionary, NSError *error) {
        
        [self hidePopView];
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            [self showErrorAlertTitle:@"Opps!" message:[error localizedDescription] buttonTitle:@"OK"];
        }
        
        if (dictionary && dictionary[@"gift"]) {
            
            if (self.redeemTimer != nil) {
                [self endTimer];
            }
            
            [self showSuccess:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self hidePopView];
                
                [self handle:dictionary[@"gift"]];
            });
            
        }
        
    }];
}

- (void)handle:(NSDictionary*)giftDict{
    
    if ([self.giftDict[@"used"] boolValue]) {
        
        // Remove Gift from UsedGifts
        [FZData removeUsedGift:self.giftDict];
        [[NSNotificationCenter defaultCenter] postNotificationName:USED_GIFTBOX_REFRESHED object:nil];
        
        [GiftController getActiveGiftBox:1 withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:YES with:^(NSArray *array, NSError *error) {
            
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
            }
        }];
        
        // Increase Active Gift Count
        [UserController increaseActiveGiftCount:1];
        
    } else {
        
        [FZData replaceActiveGift:giftDict];
        [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
        
    }
    
    [self goGiftBoxPage];
}

- (void)startTimer{
    __block  int redeemTimerCounts;
    
    if (self.giftDict[@"redeem_timer_started_at"] && ![self.giftDict[@"redeem_timer_started_at"] isKindOfClass:[NSNull class]]) {
        NSDate *redeemStartDate = [[GlobalConstants standardFormatter] dateFromString:self.giftDict[@"redeem_timer_started_at"]];
        
        if (redeemStartDate && ![redeemStartDate isEqual:[NSNull null]]) {
            NSDate *now = [NSDate date];
            
            int seconds = [now secondsFrom:redeemStartDate];
            NSLog(@"Seconds: %d", seconds);
            if (seconds <= REDEEM_COUNT_TIME) {
                redeemTimerCounts = REDEEM_COUNT_TIME - seconds;
                
                self.redeemTimer = [NSTimer bk_scheduledTimerWithTimeInterval:1.0f block:^(NSTimer *timer) {
                    int hours = redeemTimerCounts / 3600;
                    int minutes = (redeemTimerCounts / 60) % 60;
                    int seconds = redeemTimerCounts % 60;
                    
                    if ([FZData sharedInstance].activeOnlineRedeemGiftPage) {
                        self.timerLabel.text = [NSString stringWithFormat:@"Your item will be marked as used in %02dh%02dm%02ds",hours,minutes,seconds];
                    }
                    
                    redeemTimerCounts = redeemTimerCounts - 1 ;
                    
                    if (redeemTimerCounts == 0) {
                        
                        self.timeLabelTopConstraint.constant = 4.0f;
                        self.timerLabel.text = @"";
                        
                        [self endTimer];
                        [self markAsRedeemed];
                    }
                } repeats:YES];
                
            } else{
                
                if (self.giftDict[@"redeemed_time"] && [self.giftDict[@"redeemed_time"] isKindOfClass:[NSNull class]]) {
                    
                    self.timeLabelTopConstraint.constant = 4.0f;
                    self.timerLabel.text = @"";
                    
                    [self markAsRedeemed];
                }
            }
            
        }
        
    } else {
        
        self.timeLabelTopConstraint.constant = 4.0f;
        self.timerLabel.text = @"";
    }
    
}

- (void)endTimer{
    
    if (self.redeemTimer != nil && self.redeemTimer.isValid) {
        [self.redeemTimer invalidate];
        self.redeemTimer = nil;
    }
}

- (void)invalideTimer:(NSNotification*)notification{
    
    NSString *giftId = [notification.userInfo objectForKey:@"giftId"];
    if ([self.giftDict[@"id"] isEqualToString:giftId]) {
        [self endTimer];
    }
    
}

- (void)markAsRedeemed{
    
    [GiftController markAsRedeemedForGiftCard:self.giftDict[@"id"] withCompletion:^(NSDictionary *dictionary, NSError *error) {
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            [self showErrorAlertTitle:@"Oops" message:[error localizedDescription] buttonTitle:@"OK"];
            
        }
        
        if (dictionary){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:GIFT_MARK_AS_UNREDEEMED object:nil];
            
            [FZData removeActiveGift:self.giftDict];
            [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
            
            // Decrease Active Gift Count
            [UserController decreaseActiveGiftCount:1];
            
            // Add callback Gift to the UsedGifts
            if (dictionary && dictionary[@"gift"]) {
                
                if (![FZData alreadyExistUsedGift:dictionary[@"gift"]]) {
                    [[FZData sharedInstance].usedGiftBox insertObject:dictionary[@"gift"] atIndex:0];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USED_GIFTBOX_REFRESHED object:nil];
                }
            }
            
            [self goGiftBoxPage];
            
        }
    }];
}

- (void)goGiftBoxPage{
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        
        if ([viewController isKindOfClass:[GiftBoxViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
