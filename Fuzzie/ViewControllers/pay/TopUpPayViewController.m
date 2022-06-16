//
//  TopUpPayViewController.m
//  Fuzzie
//
//  Created by mac on 9/5/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "TopUpPayViewController.h"
#import "FZWebView2Controller.h"
#import "FZRedeemPopView.h"
#import "PromoCodeSuccessView.h"
#import "PaymentSuccessViewController.h"
#import "BankListViewController.h"
#import "ActivateViewController.h"
#import "PayMethodAddViewController.h"
#import "PayMethodEditViewController.h"

@interface TopUpPayViewController () <FZRedeemPopViewDelegate, PromoCodeSuccessViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeightAnchor;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbPayPrice;
@property (weak, nonatomic) IBOutlet UIView *payButtonView;
@property (weak, nonatomic) IBOutlet UIView *paymentAddContainerView;
@property (weak, nonatomic) IBOutlet UIView *paymentInfoContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *ivPaymentCard;
@property (weak, nonatomic) IBOutlet UILabel *lbPaymentCard;
@property (weak, nonatomic) IBOutlet UIView *promoCodeView;
@property (weak, nonatomic) IBOutlet UIButton *btnDeletePromoCode;
@property (weak, nonatomic) IBOutlet UITextField *tfPromoCode;
@property (weak, nonatomic) IBOutlet UILabel *lbPromoCashback;
@property (weak, nonatomic) IBOutlet UILabel *lbCashback;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackContainerHeightAnchor;
@property (weak, nonatomic) IBOutlet UIView *cashbackContainerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *promoActivity;

@property (strong, nonatomic) FZRedeemPopView *redeemPopView;
@property (strong, nonatomic) PromoCodeSuccessView *promoCodeSuccessView;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;
- (IBAction)addPaymentButtonPressed:(id)sender;
- (IBAction)paymentChangeButtonPressed:(id)sender;
- (IBAction)payButtonPressed:(id)sender;
- (IBAction)bannerButtonPressed:(id)sender;
- (IBAction)promoCodeDeleteButtonPressed:(id)sender;

@end

@implementation TopUpPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardInfoInputed) name:CARD_INFO_INPUTED object:nil];
    
    self.user = [UserController sharedInstance].currentUser;

    [FZData sharedInstance].tempCardInfoInputed = false;
    [FZData sharedInstance].tempCardInfo = nil;
    
    [self setStyling];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![FZData sharedInstance].tempCardInfoInputed) {
        [self checkPaymentMethod];
    }
    
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
    
    self.lbPrice.text = [NSString stringWithFormat:@"S$%d", [self.price intValue]];
    self.lbPayPrice.text = [NSString stringWithFormat:@"S$%d", [self.price intValue]];
    
    [CommonUtilities setView:self.payButtonView withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    if ([FZData sharedInstance].bankUploaded) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        self.bannerHeightAnchor.constant = screenWidth * 5 / 16;
    } else{
        self.bannerHeightAnchor.constant = 0.0f;
    }
    
    [self.cashbackContainerView setBackgroundColor:[UIColor colorWithHexString:@"#3B93DA"]];

    [CommonUtilities setView:self.promoCodeView withBackground:[UIColor whiteColor] withRadius:5.0f withBorderColor:[UIColor colorWithHexString:@"E0E0E0"] withBorderWidth:1.0f];
    [self updatePromoView:nil];
}

- (void)checkPaymentMethod{
    
    if ([PaymentController sharedInstance].paymentMethods) {
        
        if ([FZData sharedInstance].selectedPaymentMethod && ![[FZData sharedInstance].selectedPaymentMethod[@"card_type"] isEqualToString:@"ENETS"]) {
            
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
        
        NSURL *imageUrl = [NSURL URLWithString:self.paymentMethodDict[@"image_url"]];
        [self.ivPaymentCard sd_setImageWithURL:imageUrl];
        
        self.lbPaymentCard.text = [NSString stringWithFormat:@"••••••• %@", self.paymentMethodDict[@"last_4"]];
        
    } else {
        
        self.paymentInfoContainerView.hidden = YES;
        self.paymentAddContainerView.hidden = NO;
    }
}

- (void)updatePromoView:(NSDictionary*)dict{
    
    if (dict) {
        
        self.cashbackContainerHeightAnchor.constant = 60.0f;
        
        self.lbPromoCashback.hidden = NO;
        self.btnDeletePromoCode.hidden = NO;
        self.tfPromoCode.hidden = YES;
        
        NSNumber *cashbackPercentage = dict[@"cash_back_percentage"];
        self.promoCashback = [self.price floatValue] * [cashbackPercentage floatValue] / 100.0f;
        
        self.usePromoCode = YES;
        
    } else{
        
        self.cashbackContainerHeightAnchor.constant = 0.0f;
        
        self.lbPromoCashback.hidden = YES;
        self.btnDeletePromoCode.hidden = YES;
        self.tfPromoCode.hidden = NO;
        self.tfPromoCode.text = @"";
        
        self.promoCashback = 0.0f;
        
        self.appliedPromoCode = NO;
        self.usePromoCode = NO;
    }
    
    self.lbPromoCashback.text = [NSString stringWithFormat:@"+S$%.0f Cashback", self.promoCashback];
    self.lbCashback.text = [NSString stringWithFormat:@"S$%.0f",self.promoCashback];
    
}

- (void) goWebView:(NSString*)title urlString:(NSString*)url{

    FZWebView2Controller *webView = [[GlobalConstants extraStoryboard] instantiateViewControllerWithIdentifier:@"Webview2"];
    webView.titleHeader = title;
    webView.URL = url;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)helpButtonPressed:(id)sender {
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

- (IBAction)addPaymentButtonPressed:(id)sender {
    
    [self goPaymentMethodAddPage];
    
}

- (IBAction)paymentChangeButtonPressed:(id)sender {
    
    if ([PaymentController sharedInstance].paymentMethods.count > 0) {
        
        [self goPaymentMethodEditPage];
        
    } else {
     
        [self goPaymentMethodAddPage];
        
    }
}

- (void)goPaymentMethodEditPage{
    
    PayMethodEditViewController *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"PayMethodEditView"];
    editView.fromPaymentPage = YES;
    editView.dontShowNets = YES;
    [self.navigationController pushViewController:editView animated:YES];
    
}

- (void)goPaymentMethodAddPage{
    
    PayMethodAddViewController *addView = [self.storyboard instantiateViewControllerWithIdentifier:@"PayMethodAddView"];
    addView.fromPaymentPage = YES;
    [self.navigationController pushViewController:addView animated:YES];
}

- (IBAction)payButtonPressed:(id)sender {
    
    if (!self.paymentMethodDict && ![FZData sharedInstance].tempCardInfoInputed) {
        
        [self showEmptyError:@"Please choose a payment method first." buttonTitle:@"GOT IT" window:NO];
        
    } else{
        
        if ([FZData sharedInstance].tempCardInfoInputed) {
            
            if ([FZData sharedInstance].tempCardInfo && [CommonUtilities getPaymentCardType:[FZData sharedInstance].tempCardInfo[@"card_number"]] == PaymentCardTypeNone) {
                
                [self showEmptyError:@"Our payment gateway is not able to accept your card. Change to another card and try again." buttonTitle:@"GOT IT" window:NO];
                
            } else {
                
                [self processPayment];
                
            }
            
        } else {
            
            [self processPayment];
        }
    }
}

- (IBAction)bannerButtonPressed:(id)sender {
    BankListViewController *bankListView = [self.storyboard instantiateViewControllerWithIdentifier:@"BankListView"];
    
    [self.navigationController pushViewController:bankListView animated:YES];
}

- (IBAction)promoCodeDeleteButtonPressed:(id)sender {
    self.isDeletePromoCode = YES;
    [self.redeemPopView setPromoCodeDeleteStyle];
    self.redeemPopView.hidden = NO;
}

- (void)cardInfoInputed{
    
    self.paymentInfoContainerView.hidden = NO;
    self.paymentAddContainerView.hidden = YES;
    
    NSString *cardNumber = [FZData sharedInstance].tempCardInfo[@"card_number"];
    self.lbPaymentCard.text = [NSString stringWithFormat:@"••••••• %@", [cardNumber substringFromIndex:[cardNumber length] - 4]];
    
    [self.ivPaymentCard setImage:[CommonUtilities getPaymentCardImage:[CommonUtilities getPaymentCardType:cardNumber]]];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.tfPromoCode) {
        [self.tfPromoCode resignFirstResponder];
        [self checkPromoValidate];
    }
    return true;
}

- (void)checkPromoValidate{
    
    NSString *code = [self.tfPromoCode.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (code.length > 0) {
        
        self.promoActivity.hidden = NO;
        
        [self.promoActivity startAnimating];
        
        NSString *token = nil;
        if (self.paymentMethodDict[@"token"]) {
            token = self.paymentMethodDict[@"token"];
        }
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
                [self showPromoSuccessView:dictionary];
                [self updatePromoView:dictionary];
            }
            
        }];
    }
}


- (void)checkPromoCodeType:(NSDictionary*)dict{
    
    NSString *promoCodeType = dict[@"promo_code_type"][@"type"];
    
    if([promoCodeType isEqualToString:@"FUZZIE"]){
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

#pragma mark - PromoCodeSuccessViewDelegate
- (void)promoCodeSucceeViewDoneButtonPressed{
    self.promoCodeSuccessView.hidden = YES;
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

- (void)deletePromoCode{
    // Do Something to do delete promo code
    self.promoCodeDict = nil;
    [self updatePromoView:nil];
}

- (void)goActivateCodePage{

    ActivateViewController *activeView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"ActivateView"];
    [self.navigationController pushViewController:activeView animated:YES];
}

- (void)processPayment {
    
    NSString *promoCode = nil;
    if (self.usePromoCode) {
        promoCode = self.tfPromoCode.text;
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
    [PaymentController purchaseFuzzieTopUp:[self.price floatValue] withPaymentToken:paymentToken andCardInfo:cardInfo andNetsInfo:nil andPaymentMode:paymentMode andPromoCode:promoCode andCompletion:^(NSDictionary *dictionary, NSError *error) {
        
        if (error && error.code == 417) {
            [AppDelegate logOut];
            return ;
        }
        
        [self handleSuccessfulPaymentWithDict:dictionary andError:error];
    }];
}

- (void)handleSuccessfulPaymentWithDict:(NSDictionary *)dictionary andError:(NSError *)error {
    
    [self hidePopView];
    
    if (dictionary) {
        [UserController getUserProfileWithCompletion:^(FZUser *user, NSError *error) {
            if ([FZData sharedInstance].backOriginalPaymentPage) {
                [[NSNotificationCenter defaultCenter] postNotificationName:TOP_UP_PURCHASED object:nil];
            }
        }];
        
        if ([FZData sharedInstance].tempCardInfoInputed) {
            // Refresh Payments if previous card info not verified
            [PaymentController getPaymentMethodsWithCompletion:nil];
            
            [FZData sharedInstance].tempCardInfoInputed = false;
            [FZData sharedInstance].tempCardInfo = nil;
        }
        
        PaymentSuccessViewController *successView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"PaymentSuccessView"];
        successView.successDict = dictionary;
        successView.topUp = YES;
        [self.navigationController pushViewController:successView animated:YES];
    
    } else{
        if (error) {
            
            if (error.code == 410) {
                [self showPromoError:[error localizedDescription] window:NO];
            } else{
                [self showEmptyError:[error localizedDescription] window:NO];
            }
            
        } else {
            
            [self showEmptyError:@"Unknown error occurred." window:NO];
        }

    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
