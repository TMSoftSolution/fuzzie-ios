//
//  ClubSubscribePayViewController.m
//  Fuzzie
//
//  Created by joma on 6/18/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubSubscribePayViewController.h"
#import "FZRedeemPopView.h"
#import "PromoCodeSuccessView.h"
#import "PayUseCreditsView.h"
#import "FZWebView2Controller.h"
#import "PayMethodEditViewController.h"
@import ENETSLib;

@interface ClubSubscribePayViewController () <UITextFieldDelegate, FZRedeemPopViewDelegate, PromoCodeSuccessViewDelegate, PaymentRequestDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ivBanner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeightAnchor;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalCharge;
@property (weak, nonatomic) IBOutlet UIView *creditsValueContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creditsValueContainerHeigthAnchor;
@property (weak, nonatomic) IBOutlet UILabel *lbCreditsCharge;
@property (weak, nonatomic) IBOutlet UIView *promoCodeView;
@property (weak, nonatomic) IBOutlet UITextField *tfPromoCode;
@property (weak, nonatomic) IBOutlet UILabel *lbPromoCashback;
@property (weak, nonatomic) IBOutlet UIButton *btnDeletePromoCode;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *promoActivity;
@property (weak, nonatomic) IBOutlet UILabel *lbCashback;
@property (weak, nonatomic) IBOutlet UIView *rewardContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackContainerHeightAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rewardContainerBottonConstrint;
@property (weak, nonatomic) IBOutlet UIView *paymentAddContainerView;
@property (weak, nonatomic) IBOutlet UIView *paymentInfoContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *ivPaymentCard;
@property (weak, nonatomic) IBOutlet UILabel *lbPaymentCard;
@property (weak, nonatomic) IBOutlet UILabel *lbFuzzieCredits;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UIView *vPay;
@property (weak, nonatomic) IBOutlet UILabel *lbPayable;
@property (weak, nonatomic) IBOutlet UIView *referralCodeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *referralViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *tfReferralCode;

@property (weak, nonatomic) IBOutlet UISwitch *creditsSwitch;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)promoCodeDeleteButtonPressed:(id)sender;
- (IBAction)paymentChangeButtonPressed:(id)sender;
- (IBAction)addPaymentButtonPressed:(id)sender;
- (IBAction)payButtonPressed:(id)sender;
- (IBAction)bannerButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;
- (IBAction)creditsSwitchChanged:(UISwitch *)sender;

@property (strong, nonatomic) FZRedeemPopView *redeemPopView;
@property (strong, nonatomic) PromoCodeSuccessView *promoCodeSuccessView;
@property (strong, nonatomic) PayUseCreditsView *creditsView;

@end

@implementation ClubSubscribePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardInfoInputed) name:CARD_INFO_INPUTED object:nil];
    
    [self initData];
    [self setStyling];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![FZData sharedInstance].tempCardInfoInputed) {
        [self checkPaymentMethod];
    }
}

- (void)initData{
    
    self.user = [UserController sharedInstance].currentUser;
    
    self.totalPrice = self.user.clubMemberPrice.floatValue;
    self.creditsToUse = 0.0f;
    self.totalCashback = self.user.clubSubscribeCashback.floatValue;
    
    [FZData sharedInstance].tempCardInfoInputed = false;
    [FZData sharedInstance].tempCardInfo = nil;
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
    
    [CommonUtilities setView:self.promoCodeView withBackground:[UIColor whiteColor] withRadius:4.0f withBorderColor:[UIColor colorWithHexString:@"E0E0E0"] withBorderWidth:1.0f];
    self.btnDeletePromoCode.hidden = YES;
    self.promoActivity.hidden = YES;
    self.lbPromoCashback.hidden = YES;
    
    [CommonUtilities setView:self.rewardContainer withBackground:[UIColor whiteColor] withRadius:4.0f withBorderColor:[UIColor colorWithHexString:@"E0E0E0"] withBorderWidth:1.0f];
    
    if ([FZData sharedInstance].bankUploaded) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        self.bannerHeightAnchor.constant = screenWidth * 5 / 16;
    } else{
        self.bannerHeightAnchor.constant = 0.0f;
    }
    
     [CommonUtilities setView:self.referralCodeView withBackground:[UIColor whiteColor] withRadius:4.0f withBorderColor:[UIColor colorWithHexString:@"E0E0E0"] withBorderWidth:1.0f];
    if ([self.user.clubMember boolValue]) {
        self.referralViewHeightConstraint.constant = 0.0f;
    }
    
    self.lbPrice.attributedText = [CommonUtilities getFormattedCashbackValue:[NSNumber numberWithFloat:self.totalPrice] fontSize:14.0f smallFontSize:12.0f];
    self.lbTotalCharge.attributedText = [CommonUtilities getFormattedTotalValue:[NSNumber numberWithFloat:self.totalPrice] fontSize:16.0f smallFontSize:12.0f symbol:@""];
    
    [self.creditsSwitch setOn:false];
    [self updateTotalCashback];
    [self updateFuzzieCredits];
    
    [CommonUtilities setView:self.vPay withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    self.lbPayable.attributedText = [CommonUtilities getFormattedTotalValue:[NSNumber numberWithFloat:self.totalPrice] fontSize:18.0f smallFontSize:14.0f symbol:@""];
}

- (void)checkPaymentMethod{
    
    if ([PaymentController sharedInstance].paymentMethods) {
        
        if ([FZData sharedInstance].selectedPaymentMethod) {
            
            self.paymentMethodDict = [FZData sharedInstance].selectedPaymentMethod;
            
        } else{
            
            if ([PaymentController sharedInstance].paymentMethods.count > 0) {
                
                self.paymentMethodDict = [[PaymentController sharedInstance].paymentMethods firstObject];
                [FZData sharedInstance].selectedPaymentMethod = self.paymentMethodDict;
                
            } else {
                
                self.paymentMethodDict = nil;
            }
        }
        
        [self setupPaymentMethod];
        
    } else {
        
        [PaymentController getPaymentMethodsWithCompletion:^(NSArray *array, NSError *error) {
            
            if (array && array.count > 0) {
                self.paymentMethodDict = [array firstObject];
            } else{
                self.paymentMethodDict = nil;
            }
            
            [self setupPaymentMethod];
        }];
    }
    
}

- (void)setupPaymentMethod {
    
    if (self.paymentMethodDict) {
        
        self.paymentInfoContainerView.hidden = NO;
        self.paymentAddContainerView.hidden = YES;
        
        if ([self.paymentMethodDict[@"card_type"] isEqualToString:@"ENETS"]) {
            
            self.ivPaymentCard.image = [UIImage imageNamed:@"icon-nets"];
            self.lbPaymentCard.text = @"NETSPay";
            
        } else {
            
            NSURL *imageUrl = [NSURL URLWithString:self.paymentMethodDict[@"image_url"]];
            [self.ivPaymentCard sd_setImageWithURL:imageUrl];
            
            self.lbPaymentCard.text = [NSString stringWithFormat:@"••••••• %@", self.paymentMethodDict[@"last_4"]];
        }
        
    } else {
        
        self.paymentInfoContainerView.hidden = YES;
        self.paymentAddContainerView.hidden = NO;
    }
}

- (void)cardInfoInputed{
    
    self.paymentInfoContainerView.hidden = NO;
    self.paymentAddContainerView.hidden = YES;
    
    NSString *cardNumber = [FZData sharedInstance].tempCardInfo[@"card_number"];
    self.lbPaymentCard.text = [NSString stringWithFormat:@"••••••• %@", [cardNumber substringFromIndex:[cardNumber length] - 4]];
    
    [self.ivPaymentCard setImage:[CommonUtilities getPaymentCardImage:[CommonUtilities getPaymentCardType:cardNumber]]];
}

- (void)updateTotalCashback{
    
    if (self.totalCashback > 0) {
        self.cashbackContainerHeightAnchor.constant = 60.0f;
        self.lbCashback.attributedText = [CommonUtilities getFormattedValueWithPrice:[NSNumber numberWithFloat:self.totalCashback] mainFontName:FONT_NAME_BLACK mainFontSize:14.0f secondFontName:FONT_NAME_BLACK secondFontSize:10.0f symboFontName:FONT_NAME_BLACK symbolFontSize:14.0f];
        
    } else {
        self.cashbackContainerHeightAnchor.constant = 0.0f;
    }
    
}

- (void)updateFuzzieCredits{
    
    if (self.creditsToUse > 0.0f) {
        
        float left = [self.user.credits floatValue] - self.totalPrice;
        if (left <= 0.0f) {
            
            self.lbFuzzieCredits.text = [NSString stringWithFormat:@"%@0 left", @"S$"];
            
        } else {
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[CommonUtilities getFormattedValueWithPrice:[NSNumber numberWithFloat:left] mainFontName:FONT_NAME_LATO_REGULAR mainFontSize:14.0f secondFontName:FONT_NAME_LATO_REGULAR secondFontSize:14.0f symboFontName:FONT_NAME_LATO_REGULAR symbolFontSize:14.0f]];
            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" left" attributes:@{
                                                                                                                      NSFontAttributeName : [UIFont fontWithName:FONT_NAME_LATO_REGULAR size:14.0f]}]];
            self.lbFuzzieCredits.attributedText = attributedString;
        }
        
    } else{
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[CommonUtilities getFormattedValueWithPrice:self.user.credits mainFontName:FONT_NAME_LATO_REGULAR mainFontSize:14.0f secondFontName:FONT_NAME_LATO_REGULAR secondFontSize:14.0f symboFontName:FONT_NAME_LATO_REGULAR symbolFontSize:14.0f]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" available" attributes:@{
                                                                                                                       NSFontAttributeName : [UIFont fontWithName:FONT_NAME_LATO_REGULAR size:14.0f]}]];
        self.lbFuzzieCredits.attributedText = attributedString;
        
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

- (void) goWebView:(NSString*)title urlString:(NSString*)url{

    FZWebView2Controller *webView = [[GlobalConstants extraStoryboard] instantiateViewControllerWithIdentifier:@"Webview2"];
    webView.titleHeader = title;
    webView.URL = url;
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)goActivateCodePage{

    UIViewController *activeView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"ActivateView"];
    [self.navigationController pushViewController:activeView animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.tfPromoCode) {
        [self.tfPromoCode resignFirstResponder];
        [self checkPromoValidate];
    } else if (textField == self.tfReferralCode){
        [self.tfReferralCode resignFirstResponder];
    }
    return true;
}

#pragma mark - FZRedeemPopViewDelegate
- (void)redeemButtonPressed{
    self.redeemPopView.hidden = YES;
    
    if (self.isDeletePromoCode) {
        self.isDeletePromoCode = false;
        [self deletePromoCode];
    } else if (self.isUseActivateCode){
        self.isUseActivateCode = false;
        [self goActivateCodePage];
    }
}

- (void)cancelButtonPressed{
    self.redeemPopView.hidden = YES;
    self.isDeletePromoCode = false;
    self.isUseActivateCode = false;
}

#pragma mark - PromoCodeSuccessViewDelegate
- (void)promoCodeSucceeViewDoneButtonPressed{
    self.promoCodeSuccessView.hidden = YES;
}

#pragma mark - IBAction Helper
- (void)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)promoCodeDeleteButtonPressed:(id)sender{
    self.isDeletePromoCode = YES;
    [self.redeemPopView setPromoCodeDeleteStyle];
    self.redeemPopView.hidden = NO;
}

- (IBAction)paymentChangeButtonPressed:(id)sender {
    
    PayMethodEditViewController *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"PayMethodEditView"];
    editView.fromPaymentPage = true;
    [self.navigationController pushViewController:editView animated:YES];
}

- (IBAction)addPaymentButtonPressed:(id)sender {
    
    PayMethodEditViewController *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"PayMethodEditView"];
    editView.fromPaymentPage = true;
    [self.navigationController pushViewController:editView animated:YES];
}

- (void)payButtonPressed:(id)sender{
    
    [self.view endEditing:YES];
    
    if (self.creditsToUse == self.totalPrice) {
        
        [self processPayment];
        
    } else {
        
        if ([FZData sharedInstance].tempCardInfoInputed) {
            
            if ([FZData sharedInstance].tempCardInfo && [CommonUtilities getPaymentCardType:[FZData sharedInstance].tempCardInfo[@"card_number"]] == PaymentCardTypeNone) {
                
                [self showEmptyError:@"Our payment gateway is not able to accept your card. Change to another card and try again." buttonTitle:@"GOT IT" window:NO];
                
            } else {
                
                [self processPayment];
                
            }
            
        } else {
            
            if (self.paymentMethodDict) {
                
                if ([self.paymentMethodDict[@"card_type"] isEqualToString:@"ENETS"]) {
                    
                    [self callNets];
                    
                } else {
                    
                    [self processPayment];
                }
                
            } else {
                
                [self showEmptyError:@"Please choose a payment method first." buttonTitle:@"GOT IT" window:NO];
            }
        }
    }
}

- (void)bannerButtonPressed:(id)sender{
    
    UIViewController *bankListView = [self.storyboard instantiateViewControllerWithIdentifier:@"BankListView"];
    [self.navigationController pushViewController:bankListView animated:YES];
    
}

- (void)helpButtonPressed:(id)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"Need help?"];
    
    [actionSheet bk_addButtonWithTitle:@"Read our FAQ" handler:^{
        [self goWebView:@"FAQ" urlString:@"http://fuzzie.com.sg/faq.html"];
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

- (void)creditsSwitchChanged:(UISwitch *)sender{
    
    if (sender.on) {
        
        if (self.promoCodeDict) {
            NSString *promoCodeType = self.promoCodeDict[@"promo_code_type"][@"type"];
            if (![promoCodeType isEqualToString:@"FUZZIE"]) {
                [self showPromoError:@"Your promo code cannot be used with Fuzzie credits. Switch Off your credits to use your code." window:NO];
                [self.creditsSwitch setOn:false];
                return;
            }
        }
        
        if ([self.user.credits floatValue] > 0.0f) {
            
            self.creditsToUse = MIN(self.totalPrice,self.user.credits.floatValue);
            
            [self showCredistValueView:self.creditsToUse];
            
            self.creditsValueContainerHeigthAnchor.constant = 40.0f;
            
            self.lbCreditsCharge.attributedText = [CommonUtilities getFormattedTotalValue:[NSNumber numberWithFloat:self.creditsToUse] fontSize:16.0f smallFontSize:12.0f symbol:@"-"];
            self.lbPayable.attributedText = [CommonUtilities getFormattedTotalValue:[NSNumber numberWithFloat:(self.totalPrice - self.creditsToUse)] fontSize:18.0f smallFontSize:14.0f symbol:@""];
            
            [self updateFuzzieCredits];

        } else{
            [self showEmptyError:@"Looks like you don't have any fuzzie credits yet." buttonTitle:@"GOT IT" window:NO];
            [self.creditsSwitch setOn:false];
        }
        
    } else{
        
        self.creditsToUse = 0.0f;
        
        self.creditsValueContainerHeigthAnchor.constant = 0.0f;
        
        [self updateFuzzieCredits];
        
        self.lbPayable.attributedText = [CommonUtilities getFormattedTotalValue:[NSNumber numberWithFloat:self.totalPrice] fontSize:18.0f smallFontSize:14.0f symbol:@""];
    }
    
}

- (void)showCredistValueView:(CGFloat)creditsValue{
    [self.creditsView showCreditsValue:creditsValue];
    self.creditsView.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.creditsView.hidden = YES;
    });
}

- (void)checkPromoValidate{
    
    NSString *code = [self.tfPromoCode.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (code.length > 0) {
        
        self.promoActivity.hidden = NO;
        
        [self.promoActivity startAnimating];
        
        [ClubController validatePromoCode:code withCompletion:^(NSDictionary *dictionary, NSError *error) {
            
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

- (void)deletePromoCode{
    // Do Something to do delete promo code
    self.promoCodeDict = nil;
    [self updatePromoView:nil];
}

#pragma mark - Payment Process
- (void)callNets{
    
    self.netsPaymentRef = [CommonUtilities genRandomString:20];
    NSLog(@"Nets Payment Ref - %@", self.netsPaymentRef);
    
    NSString * txnRequest = [[NetsUtils sharedInstance] getTxnRequestWithMID:NETSPAY_MID paymentAmount:[NSNumber numberWithFloat:(self.totalPrice - self.creditsToUse) * 100] paymentRef:self.netsPaymentRef];
    NSString * hmac = [Util hashShash256WithMessage:txnRequest secretKey:NETSPAY_SECRET_KEY];
    
    PaymentRequest * request = [[PaymentRequest alloc] initWithHmac:hmac
                                                             txnReq:txnRequest];
    
    PaymentRequestManager * paymentManager = [[PaymentRequestManager alloc] init];
    paymentManager.paymentDelegate = self;
    
    [paymentManager sendPaymentRequestWithApiKey:NETSPAY_API_KEY_ID
                                  paymentRequest:request
                                  viewController:self];
}

#pragma mark - PaymentRequestDelegate
- (void)onResultWithResponse:(PaymentResponse *)response{
    
    [self processPaymentWithNets];
}

- (void)onFailureWithError:(NETSError *)error{
    
    if (![error.responseCode containsString:@"69078"]) {
        
        NSString * message = [[NetsUtils sharedInstance] netsError:error.responseCode];
        [self showEmptyError:message buttonTitle:@"OK" window:NO];
    }
}
- (void)processPayment{
    
    NSString *promoCode = nil;
    if (self.usePromoCode) {
        promoCode = self.tfPromoCode.text;
    }
    
    NSString *referralCode = nil;
    if (![self.user.clubMember boolValue]) {
        referralCode = self.tfReferralCode.text;
    }
    
    NSString *paymentToken = nil;
    NSString *paymentMode = @"CREDIT_CARD";
    NSDictionary *cardInfo = nil;
    
    if ([FZData sharedInstance].tempCardInfoInputed && [FZData sharedInstance].tempCardInfo) {
        cardInfo = [FZData sharedInstance].tempCardInfo;
    } else if (self.paymentMethodDict) {
        paymentToken = self.paymentMethodDict[@"token"];
    }
    
    [self showProcessing:NO];
    [PaymentController subscribeClub:self.creditsToUse withPaymentToken:paymentToken andCardInfo:cardInfo andNetsInfo:nil andPaymentMode:paymentMode andPromoCode:promoCode andReferralCode:referralCode andCompletion:^(NSDictionary *dictionary, NSError *error) {
        
        [self handleSuccessfulPaymentWithDict:dictionary andError:error];
    }];
}

- (void)processPaymentWithNets{
    
    NSString *promoCode = nil;
    if (self.usePromoCode) {
        promoCode = self.tfPromoCode.text;
    }
    
    NSString *referralCode = nil;
    if (![self.user.clubMember boolValue]) {
        referralCode = self.tfReferralCode.text;
    }
    
    NSString *paymentMode = @"NETS";
    NSDictionary *netsInfo = @{@"payment_reference": self.netsPaymentRef};
    
    [self showProcessing:NO];
    [PaymentController subscribeClub:self.creditsToUse withPaymentToken:nil andCardInfo:nil andNetsInfo:netsInfo andPaymentMode:paymentMode andPromoCode:promoCode andReferralCode:referralCode andCompletion:^(NSDictionary *dictionary, NSError *error) {
        
        [self handleSuccessfulPaymentWithDict:dictionary andError:error];
    }];
}

- (void)handleSuccessfulPaymentWithDict:(NSDictionary *)dictionary andError:(NSError *)error {
    
    [self hidePopView];
    
    if (dictionary) {
        
        [UserController getUserProfileWithCompletion:^(FZUser *user, NSError *error) {
            if (error && error.code == 417) {
                [AppDelegate logOut];
            }
        }];
        
        if ([FZData sharedInstance].tempCardInfoInputed) {
            // Refresh Payments if previous card info not verified
            [PaymentController getPaymentMethodsWithCompletion:nil];
            
            [FZData sharedInstance].tempCardInfoInputed = false;
            [FZData sharedInstance].tempCardInfo = nil;
        }
        
        UIViewController *successView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubSubscribePaySuccessView"];
        [self.navigationController pushViewController:successView animated:YES];
        
    } else{
        
        if (error) {
            
            if (error.code == 406 || error.code == 422) {
                
                if ([error localizedDescription]) {
                    [self showEmptyError:[error localizedDescription] buttonTitle:@"GOT IT" window:NO];
                } else {
                    [self showEmptyError:[NSString stringWithFormat:@"Unknown error occurred. %ld", error.code] buttonTitle:@"GOT IT" window:NO];
                }
                
            } else if (error.code == 410) {
                [self showPromoError:[error localizedDescription] window:NO];
            } else{
                [self showEmptyError:[error localizedDescription] window:NO];
            }
            
        } else {
            
            [self showEmptyError:@"Unknown error occurred." window:NO];
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TOP_UP_PURCHASED object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
