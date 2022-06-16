//
//  JackpotPayViewController.m
//  Fuzzie
//
//  Created by mac on 9/10/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotPayViewController.h"
#import "PaymentSuccessViewController.h"
#import "BankListViewController.h"
#import "FZRedeemPopView.h"
#import "PromoCodeSuccessView.h"
#import "PayUseCreditsView.h"
#import "TopUpFuzzieCreditsViewController.h"
#import "JackpotPaySuccessViewController.h"
#import "ActivateViewController.h"
#import "JackpotCouponViewController.h"
#import "JackpotLearnMoreViewController.h"
#import "PowerUpPaySuccessViewController.h"

@interface JackpotPayViewController () <UITextFieldDelegate, FZRedeemPopViewDelegate, PromoCodeSuccessViewDelegate, MDHTMLLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ivBanner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeightAnchor;
@property (weak, nonatomic) IBOutlet UILabel *lbCouponName;
@property (weak, nonatomic) IBOutlet UILabel *lbCouponPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbticket;
@property (weak, nonatomic) IBOutlet UILabel *lbTicketCashback;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalCharge;
@property (weak, nonatomic) IBOutlet UIView *creditsValueContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creditsValueContainerHeigthAnchor;
@property (weak, nonatomic) IBOutlet UILabel *lbCreditsCharge;
@property (weak, nonatomic) IBOutlet UIView *promoCodeView;
@property (weak, nonatomic) IBOutlet UITextField *tfPromoCode;
@property (weak, nonatomic) IBOutlet UILabel *lbPromoCashback;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ticketInfoHeightAnchor;
@property (weak, nonatomic) IBOutlet UIButton *btnDeletePromoCode;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *promoActivity;
@property (weak, nonatomic) IBOutlet UILabel *lbCashback;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackContainerHeightAnchor;
@property (weak, nonatomic) IBOutlet UIView *rewardContainer;

@property (weak, nonatomic) IBOutlet UILabel *lbFuzzieCredits;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;

@property (weak, nonatomic) IBOutlet UISwitch *creditsSwitch;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *lbTopUp;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)promoCodeDeleteButtonPressed:(id)sender;
- (IBAction)payButtonPressed:(id)sender;
- (IBAction)bannerButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;
- (IBAction)creditsSwitchChanged:(UISwitch *)sender;

@property (strong, nonatomic) FZRedeemPopView *redeemPopView;
@property (strong, nonatomic) PromoCodeSuccessView *promoCodeSuccessView;
@property (strong, nonatomic) PayUseCreditsView *creditsView;

@end

@implementation JackpotPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.user = [UserController sharedInstance].currentUser;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topUpPurchased) name:TOP_UP_PURCHASED object:nil];
    
    [self setStyling];
}

- (void)setStyling{
    
    UINib *redeemPopViewNib = [UINib nibWithNibName:@"FZRedeemPopView" bundle:nil];
    self.redeemPopView = [[redeemPopViewNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.redeemPopView.delegate = self;
    [self.redeemPopView setPromoCodeDeleteStyle];
    [self.view addSubview:self.redeemPopView];
    self.redeemPopView.frame = self.view.frame;
    self.redeemPopView.hidden = YES;
    
    UINib *promoNib = [UINib nibWithNibName:@"PromoCodeSuccessView" bundle:nil];
    self.promoCodeSuccessView = [[promoNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self.view addSubview:self.promoCodeSuccessView];
    self.promoCodeSuccessView.delegate = self;
    self.promoCodeSuccessView.frame = self.view.frame;
    self.promoCodeSuccessView.hidden = YES;
    
    UINib *creditsNib = [UINib nibWithNibName:@"PayUseCreditsView" bundle:nil];
    self.creditsView = [[creditsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self.view addSubview:self.creditsView];
    self.creditsView.frame = self.view.frame;
    self.creditsView.hidden = YES;

    self.creditsValueContainerHeigthAnchor.constant = 0;
    
    [CommonUtilities setView:self.promoCodeView withBackground:[UIColor whiteColor] withRadius:5.0f withBorderColor:[UIColor colorWithHexString:@"E0E0E0"] withBorderWidth:1.0f];
    self.btnDeletePromoCode.hidden = YES;
    self.promoActivity.hidden = YES;
    self.lbPromoCashback.hidden = YES;
    
    // Use Credits by Default
    self.creditsToUse = 0.0f;
    [self updatePayButton];
    [self updateFuzzieCredits];
    [self.creditsSwitch setOn:false];
    
    if ([FZData sharedInstance].bankUploaded) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        self.bannerHeightAnchor.constant = screenWidth * 5 / 16;
    } else{
        self.bannerHeightAnchor.constant = 0.0f;
    }
    
    self.lbCouponName.text = self.coupon.name;

    self.lbCouponPrice.attributedText = [CommonUtilities getFormattedCashbackValue:self.coupon.priceValue fontSize:14.0f smallFontSize:10.0f];
    
    self.lbticket.text = [NSString stringWithFormat:@"%@", self.coupon.ticketCount];

    if ([self.coupon.cashbackValue floatValue] <= 0.0f) {
        self.lbTicketCashback.hidden = YES;
    } else{
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[CommonUtilities getFormattedCashbackValue:self.coupon.cashbackValue fontSize:12.0f smallFontSize:9.0f]];
        NSAttributedString *cashbackString = [[NSAttributedString alloc] initWithString:@" cashback" attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:12.0f]}];
        [attributedString appendAttributedString:cashbackString];
        self.lbTicketCashback.attributedText = attributedString;
    }
    
    self.totalPrice = [self.coupon.priceValue floatValue];
    self.lbTotalCharge.attributedText = [CommonUtilities getFormattedTotalValue:self.coupon.priceValue fontSize:16.0f smallFontSize:12.0f symbol:@""];
    
    self.totalCashback = [self.coupon.cashbackValue floatValue];
    [self updateTotalCashback];
    
    self.lbTopUp.htmlText = @"This item can only be purchased with Fuzzie Credits. <a href='top'>Top-up your credits here.</a>";
    self.lbTopUp.delegate = self;
    self.lbTopUp.linkAttributes = @{
                                   NSForegroundColorAttributeName: [UIColor colorWithHexString:HEX_COLOR_RED],
                                   NSFontAttributeName: [UIFont fontWithName:FONT_NAME_LATO_BLACK size:13.0f],
                                   NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone) };
    self.lbTopUp.lineHeightMultiple = 1.3f;
    
    [CommonUtilities setView:self.rewardContainer withCornerRadius:4.0f withBorderColor:[UIColor colorWithHexString:@"#E3E3E3"] withBorderWidth:1.0f];
}

- (void)topUpPurchased{
    
    self.user = [UserController sharedInstance].currentUser;
    [self updateFuzzieCredits];
}

- (void)updateFuzzieCredits{

    if (self.creditsToUse > 0.0f) {
        
        float left = [self.user.credits floatValue] - self.totalPrice;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[CommonUtilities getFormattedValueWithPrice:[NSNumber numberWithFloat:left] mainFontName:FONT_NAME_LATO_REGULAR mainFontSize:14.0f secondFontName:FONT_NAME_LATO_REGULAR secondFontSize:14.0f symboFontName:FONT_NAME_LATO_REGULAR symbolFontSize:14.0f]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" left" attributes:@{
                                                                                                                  NSFontAttributeName : [UIFont fontWithName:FONT_NAME_LATO_REGULAR size:14.0f]}]];
        self.lbFuzzieCredits.attributedText = attributedString;
        
    } else{
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[CommonUtilities getFormattedValueWithPrice:self.user.credits mainFontName:FONT_NAME_LATO_REGULAR mainFontSize:14.0f secondFontName:FONT_NAME_LATO_REGULAR secondFontSize:14.0f symboFontName:FONT_NAME_LATO_REGULAR symbolFontSize:14.0f]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" available" attributes:@{
                                                                                                                       NSFontAttributeName : [UIFont fontWithName:FONT_NAME_LATO_REGULAR size:14.0f]}]];
        self.lbFuzzieCredits.attributedText = attributedString;
        
    }
}

- (void)updateTotalCashback{
    
    if (self.totalCashback > 0) {
        self.cashbackContainerHeightAnchor.constant = 45.0f;
      
        self.lbCashback.attributedText = [CommonUtilities getFormattedValueWithPrice:[NSNumber numberWithFloat:self.totalCashback] mainFontName:FONT_NAME_BLACK mainFontSize:14.0f secondFontName:FONT_NAME_BLACK secondFontSize:10.0f symboFontName:FONT_NAME_BLACK symbolFontSize:14.0f];
        
    } else {
        self.cashbackContainerHeightAnchor.constant = 0.0f;
    }
    
}

- (void)updatePayButton{
    if (self.creditsToUse == 0) {
        [CommonUtilities setView:self.btnPay withBackground:[UIColor colorWithHexString:@"#CBCBCB"] withRadius:4.0f];
        self.btnPay.enabled = NO;
    } else {
        [CommonUtilities setView:self.btnPay withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
        self.btnPay.enabled = YES;
    }
}

- (void)updatePromoView:(NSDictionary*)dict{
    if (dict) {
        self.lbPromoCashback.hidden = NO;
        self.btnDeletePromoCode.hidden = NO;
        self.tfPromoCode.hidden = YES;
        
        NSNumber *cashbackPercentage = dict[@"cash_back_percentage"];
        self.promoCashback = self.totalPrice * [cashbackPercentage floatValue] / 100.0f;
        self.totalCashback = self.totalCashback + self.promoCashback;
        
        self.usePromoCode = YES;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"+" attributes:@{
                                                                                                                          NSFontAttributeName : [UIFont fontWithName:FONT_NAME_LATO_BOLD size:14.0f]
                                                                                                                          }];
        [attributedString appendAttributedString:[CommonUtilities getFormattedValueWithPrice:[NSNumber numberWithFloat:self.promoCashback] mainFontName:FONT_NAME_LATO_BOLD mainFontSize:14.0f secondFontName:FONT_NAME_LATO_BOLD secondFontSize:14.0f symboFontName:FONT_NAME_LATO_BOLD symbolFontSize:14.0f]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" Cashback" attributes:@{
                                                                                                                      NSFontAttributeName : [UIFont fontWithName:FONT_NAME_LATO_BOLD size:14.0f]}]];
        self.lbPromoCashback.attributedText = attributedString;
        
    } else{
        self.lbPromoCashback.hidden = YES;
        self.btnDeletePromoCode.hidden = YES;
        self.tfPromoCode.hidden = NO;
        self.tfPromoCode.text = @"";
        
        self.totalCashback = self.totalCashback - self.promoCashback;
        self.promoCashback = 0.0f;
        
        self.appliedPromoCode = NO;
        self.usePromoCode = NO;
    }

    [self updateTotalCashback];
}

- (void)checkPromoValidate{
    
    NSString *code = [self.tfPromoCode.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (code.length > 0) {
        
        self.promoActivity.hidden = NO;
        
        [self.promoActivity startAnimating];
        
        NSString *token = nil;

        [PaymentController validatePromoCode:code andPaymentToken:token withCompletion:^(NSDictionary *dictionary, NSError *error) {
            
            [self.promoActivity stopAnimating];
            
            if (error) {
                
                if (error.code == 417) {
                    
                    [AppDelegate logOut];
                    
                } else if (error.code == 411 || error.code == 416){
                    
                    self.isUseActivateCode = true;
                    [self.redeemPopView setGeneralStyle:@"OOPS!" body:error.localizedDescription image:@"bear-baby" buttonTitle1:@"GO TO FUZZIE CODE" buttonTitle2:@"Cancel"];
                    self.redeemPopView.hidden = NO;
                    
                } else{
                    
                    [self showEmptyError:[error localizedDescription] buttonTitle:@"TRY AGAIN" window:NO];
                }
                
                self.promoCodeDict = nil;
                [self updatePromoView:nil];
                
                return ;
            }
            
            if (dictionary) {
                self.appliedPromoCode = YES;
                self.promoCodeDict = dictionary;
                [self checkPromoCodeType:dictionary];
            }
            
        }];
    }
}

- (void)checkPromoCodeType:(NSDictionary*)dict{
    
    NSString *promoCodeType = dict[@"promo_code_type"][@"type"];
    
    if(![promoCodeType isEqualToString:@"FUZZIE"] && [self.creditsSwitch isOn]){
        [self showPromoError:@"Fuzzie credits cannot be used with your promo code. To use your credits, remove your promo code." window:NO];
        self.tfPromoCode.text = @"";
        self.promoCodeDict = nil;
    } else{
        [self showPromoSuccessView:dict];
        [self updatePromoView:dict];
    }
    
    
}

- (void)showPromoSuccessView:(NSDictionary*)dict{
    [self.promoCodeSuccessView showCashback:[dict[@"cash_back_percentage"] floatValue]];
    self.promoCodeSuccessView.hidden = NO;
}

- (void)showCredistValueView:(CGFloat)creditsValue{
    [self.creditsView showCreditsValue:creditsValue];
    self.creditsView.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.creditsView.hidden = YES;
    });
}

- (void)deletePromoCode{
    // Do Something to do delete promo code
    self.promoCodeDict = nil;
    [self updatePromoView:nil];
}

- (void)goActivateCodePage{
    
    ActivateViewController *activeView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"ActivateView"];
    [self.navigationController pushViewController:activeView animated:YES];
}

- (void)purchaseCoupon{
    
    NSString *promoCode = nil;
    if (self.usePromoCode) {
        promoCode = self.tfPromoCode.text;
    }
    
    [self showProcessing:NO];
    
    [PaymentController purchaseCoupon:self.coupon.couponId andPromoCode:promoCode andCompletion:^(NSDictionary *dictionary, NSError *error) {
        [self hidePopView];
        
        [self handleSuccessfulPaymentWithDict:dictionary andError:error];
    }];
}

- (void)handleSuccessfulPaymentWithDict:(NSDictionary *)dictionary andError:(NSError *)error {
    
    if (dictionary) {
        
        [UserController getUserProfileWithCompletion:^(FZUser *user, NSError *error) {
            if (error && error.code == 417) {
                [AppDelegate logOut];
            }
            
            [AppDelegate updateWalletBadge];
        }];
   
        if (dictionary[@"coupon"] && ![dictionary[@"coupon"] isKindOfClass:[NSNull class]]) {
            
            if (self.coupon.powerUpPack) {
                
                [GiftController getActiveGiftBox:1 withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:YES with:^(NSArray *array, NSError *error) {
                    
                    if (!error) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
                    }
                }];
                
            } else{
                
                [[FZData sharedInstance].activeGiftBox insertObject:dictionary[@"coupon"] atIndex:0];
                [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
                
            }
            
        }
        
        if (dictionary[@"cash_back"] && [dictionary[@"cash_back"] floatValue] > 0.0f) {

            PaymentSuccessViewController *successView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"PaymentSuccessView"];
            successView.successDict = dictionary;
            successView.fromJackpot = true;
            if (self.coupon.powerUpPack) {
                successView.isPowerUpPack = true;
            }
            [self.navigationController pushViewController:successView animated:YES];
        } else{
            
            JackpotPaySuccessViewController *successView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotPaySuccessView"];
            if (self.coupon.powerUpPack) {
                successView.isPowerUpPack = true;
            }
            [self.navigationController pushViewController:successView animated:YES];
        }
        
    }
    
    if (error) {
        
        if (error.code == 417) {
            [AppDelegate logOut];
            return;
        }
        
        [self showError:[error localizedDescription] headerTitle:@"OOPS!" buttonTitle:@"OK" image:@"bear-dead" window:NO];
    }
    
    
}

- (void)goTopUpPage{
    
    [FZData sharedInstance].backOriginalPaymentPage = YES;

    TopUpFuzzieCreditsViewController *topUpView = [[GlobalConstants topUpStoryboard] instantiateViewControllerWithIdentifier:@"TopUpFuzzieCreditsView"];
    [self.navigationController pushViewController:topUpView animated:YES];
    
}

#pragma mark - MDHTMLLabelDelegate
- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL{
    [self goTopUpPage];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.tfPromoCode) {
        [self.tfPromoCode resignFirstResponder];
        [self checkPromoValidate];
    }
    return true;
}

#pragma mark - FZRedeemPopViewDelegate
- (void)redeemButtonPressed{
    self.redeemPopView.hidden = YES;
    if (self.topUpPop) {
        self.topUpPop = false;
        [self goTopUpPage];
    } else if (self.isDeletePromoCode) {
        self.isDeletePromoCode = false;
        [self deletePromoCode];
    } else if (self.isUseActivateCode){
        self.isUseActivateCode = false;
        [self goActivateCodePage];
    }
}

- (void)cancelButtonPressed{
    self.redeemPopView.hidden = YES;
    self.topUpPop = false;
    self.isDeletePromoCode = false;
    self.isUseActivateCode = false;
}

#pragma mark - PromoCodeSuccessViewDelegate
- (void)promoCodeSucceeViewDoneButtonPressed{
    self.promoCodeSuccessView.hidden = YES;
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [FZData sharedInstance].backOriginalPaymentPage = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)promoCodeDeleteButtonPressed:(id)sender{
    self.isDeletePromoCode = YES;
    [self.redeemPopView setPromoCodeDeleteStyle];
    self.redeemPopView.hidden = NO;
}

- (IBAction)payButtonPressed:(id)sender{
    
    if (self.creditsToUse != self.totalPrice) {
        [self showEmptyError:@"Please choose a payment method first." buttonTitle:@"GOT IT" window:NO];
    } else {
        [self purchaseCoupon];
    }

}

- (IBAction)bannerButtonPressed:(id)sender{
    BankListViewController *bankListView = [self.storyboard instantiateViewControllerWithIdentifier:@"BankListView"];
    
    [self.navigationController pushViewController:bankListView animated:YES];
}

- (IBAction)helpButtonPressed:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"Need help?"];
    
    [actionSheet bk_addButtonWithTitle:@"Read our Jackpot FAQ" handler:^{
        [self goJackpotLearnMorePage];
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

- (void) goJackpotLearnMorePage{

    JackpotLearnMoreViewController *learnView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotLearnMoreView"];
    [self.navigationController pushViewController:learnView animated:YES];
}

- (IBAction)creditsSwitchChanged:(UISwitch *)sender;{
    if (sender.on) {
        
        if ([self.user.credits floatValue] > 0.0f && [self.user.credits floatValue] >= self.totalPrice) {
            
            self.creditsToUse = self.totalPrice;
            [self showCredistValueView:self.creditsToUse];
            
            self.creditsValueContainerHeigthAnchor.constant = 30.0f;
            
            self.lbCreditsCharge.attributedText = [CommonUtilities getFormattedTotalValue:self.coupon.priceValue fontSize:16.0f smallFontSize:12.0f symbol:@"-"];
 
            [self updateFuzzieCredits];
            
        } else{
            [self.creditsSwitch setOn:false];
            [self.redeemPopView setTopUpPurchaseStyle];
            self.redeemPopView.hidden = NO;
            self.topUpPop = YES;
        }
        
    } else{
        
        self.creditsValueContainerHeigthAnchor.constant = 0.0f;
        
        self.creditsToUse = 0.0f;
        [self updateFuzzieCredits];
    }
    
    [self updatePayButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TOP_UP_PURCHASED object:nil];
}


@end
