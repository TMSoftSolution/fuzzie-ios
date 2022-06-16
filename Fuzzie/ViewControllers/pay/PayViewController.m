//
//  PayViewController.m
//  Fuzzie
//
//  Created by mac on 8/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "PayViewController.h"
#import "PayTableViewCell.h"
#import "FZWebView2Controller.h"
#import "PayMethodAddViewController.h"
#import "PayMethodEditViewController.h"
#import "PaymentSuccessViewController.h"
#import "BankListViewController.h"
#import "FZRedeemPopView.h"
#import "PromoCodeSuccessView.h"
#import "PayUseCreditsView.h"
#import "ActivateViewController.h"
@import ENETSLib;

@interface PayViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,  FZRedeemPopViewDelegate,  PromoCodeSuccessViewDelegate, PaymentRequestDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ivBanner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeightAnchor;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightAnchor;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalCharge;
@property (weak, nonatomic) IBOutlet UIView *creditsValueContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creditsValueContainerHeigthAnchor;
@property (weak, nonatomic) IBOutlet UILabel *lbCreditsCharge;
@property (weak, nonatomic) IBOutlet UIView *promoCodeView;
@property (weak, nonatomic) IBOutlet UITextField *etPromoCode;
@property (weak, nonatomic) IBOutlet UILabel *lbPromoCashback;

@property (weak, nonatomic) IBOutlet UIButton *btnDeletePromoCode;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *promoActivity;
@property (weak, nonatomic) IBOutlet UIView *cashbackContainerView;
@property (weak, nonatomic) IBOutlet UILabel *lbCashback;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackContainerHeightAnchor;
@property (weak, nonatomic) IBOutlet UIView *paymentAddContainerView;
@property (weak, nonatomic) IBOutlet UIView *paymentInfoContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *ivPaymentCard;
@property (weak, nonatomic) IBOutlet UILabel *lbPaymentCard;
@property (weak, nonatomic) IBOutlet UILabel *lbFuzzieCredits;
@property (weak, nonatomic) IBOutlet UILabel *lbPaymentCharge;
@property (weak, nonatomic) IBOutlet UIView *payButtonView;
@property (weak, nonatomic) IBOutlet UISwitch *creditsSwitch;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promoCodeContainerHeigthAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emptyViewHeightAnchor;

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

@implementation PayViewController

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

    [self.cashbackContainerView setBackgroundColor:[UIColor colorWithHexString:@"#3B93DA"]];
    
    [CommonUtilities setView:self.payButtonView withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    UINib *itemCell = [UINib nibWithNibName:@"PayTableViewCell" bundle:nil];
    [self.tableView registerNib:itemCell forCellReuseIdentifier:@"PayCell"];
    
    [self.tableView reloadData];
    self.tableViewHeightAnchor.constant = self.tableView.contentSize.height;

    if (self.itemArray && self.itemArray.count > 0) {
        
        CGFloat totalPrice = 0.0f;
        CGFloat totalCashback = 0.0f;
        
        for (NSInteger i=0; i<self.itemArray.count; i++) {
            NSDictionary *itemDict = self.itemArray[i];
            
            totalPrice += [itemDict[@"discounted_price"] floatValue];
            totalCashback += [itemDict[@"cash_back"][@"value"] floatValue];
        }
        
        NSDictionary *itemDict = [self.itemArray firstObject];
        self.currencySymbol = itemDict[@"price"][@"currency_symbol"];
        self.totalPrice = totalPrice;
        self.totalCashback = totalCashback;

    } else{
        self.totalPrice = 0.0f;
        self.currencySymbol = @"S$";
    }

    self.lbTotalCharge.attributedText = [CommonUtilities getFormattedTotalValue:[NSNumber numberWithFloat:self.totalPrice] fontSize:16.0f smallFontSize:12.0f symbol:@""];
    self.lbPaymentCharge.attributedText = [CommonUtilities getFormattedTotalValue:[NSNumber numberWithFloat:self.totalPrice] fontSize:18.0f smallFontSize:14.0f symbol:@""];

    [self updateTotalCashback];
    
    // Use Credits by Default
    self.creditsToUse = 0.0f;
    [self updateFuzzieCredits];
    [self.creditsSwitch setOn:false];
    
    if ([FZData sharedInstance].bankUploaded) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        self.bannerHeightAnchor.constant = screenWidth * 5 / 16;
    } else{
        self.bannerHeightAnchor.constant = 0.0f;
    }

}

- (void)updateFuzzieCredits{
    
    self.user = [UserController sharedInstance].currentUser;

    if (self.creditsToUse > 0.0f) {
        
        float left = [self.user.credits floatValue] - self.totalPrice;
        if (left <= 0.0f) {
            
            self.lbFuzzieCredits.text = [NSString stringWithFormat:@"%@0 left", self.currencySymbol];
            
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

- (void)updateTotalCashback{
    
    if (self.totalCashback > 0) {
        self.cashbackContainerHeightAnchor.constant = 70.0f;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"+" attributes:@{
                                                                                                                          NSFontAttributeName : [UIFont fontWithName:FONT_NAME_BLACK size:16.0f]
                                                                                                                          }];
        [attributedString appendAttributedString:[CommonUtilities getFormattedValueWithPrice:[NSNumber numberWithFloat:self.totalCashback] mainFontName:FONT_NAME_BLACK mainFontSize:16.0f secondFontName:FONT_NAME_BLACK secondFontSize:16.0f symboFontName:FONT_NAME_BLACK symbolFontSize:16.0f]];
        self.lbCashback.attributedText = attributedString;
        
    } else {
        self.cashbackContainerHeightAnchor.constant = 0.0f;
        self.promoCodeContainerHeigthAnchor.constant = 0.0f;
    }
    
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

- (void)updatePromoView:(NSDictionary*)dict{
    if (dict) {
        self.lbPromoCashback.hidden = NO;
        self.btnDeletePromoCode.hidden = NO;
        self.etPromoCode.hidden = YES;
        
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
        self.etPromoCode.hidden = NO;
        self.etPromoCode.text = @"";
        
        self.totalCashback = self.totalCashback - self.promoCashback;
        self.promoCashback = 0.0f;
        
        self.appliedPromoCode = NO;
        self.usePromoCode = NO;
    }

    [self updateTotalCashback];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return [PayTableViewCell estimateHeigthWithBrand:self.brandArray[indexPath.row] andItem:self.itemArray[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayTableViewCell *cell = (PayTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"PayCell"];
    NSDictionary *itemDict = self.itemArray[indexPath.row];
    FZBrand *brand = self.brandArray[indexPath.row];
    BOOL isLast = indexPath.row == self.itemArray.count - 1;
    [cell setCellWithBrand:brand andItem:itemDict withLast:isLast];
    return cell;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.etPromoCode) {
        [self.etPromoCode resignFirstResponder];
        [self checkPromoValidate];
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

- (void)cardInfoInputed{
    
    self.paymentInfoContainerView.hidden = NO;
    self.paymentAddContainerView.hidden = YES;
    
    NSString *cardNumber = [FZData sharedInstance].tempCardInfo[@"card_number"];
    self.lbPaymentCard.text = [NSString stringWithFormat:@"••••••• %@", [cardNumber substringFromIndex:[cardNumber length] - 4]];
    
    [self.ivPaymentCard setImage:[CommonUtilities getPaymentCardImage:[CommonUtilities getPaymentCardType:cardNumber]]];
}

#pragma mark - PromoCodeSuccessViewDelegate
- (void)promoCodeSucceeViewDoneButtonPressed{
    self.promoCodeSuccessView.hidden = YES;
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)promoCodeDeleteButtonPressed:(id)sender {
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

- (IBAction)payButtonPressed:(id)sender {

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

- (IBAction)bannerButtonPressed:(id)sender {
    
    BankListViewController *bankListView = [self.storyboard instantiateViewControllerWithIdentifier:@"BankListView"];
    
    [self.navigationController pushViewController:bankListView animated:YES];
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

- (IBAction)creditsSwitchChanged:(UISwitch *)sender {
    
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
            self.emptyViewHeightAnchor.constant = 0.0f;
            
             self.lbCreditsCharge.attributedText = [CommonUtilities getFormattedTotalValue:[NSNumber numberWithFloat:self.creditsToUse] fontSize:16.0f smallFontSize:12.0f symbol:@"-"];
            self.lbPaymentCharge.attributedText = [CommonUtilities getFormattedTotalValue:[NSNumber numberWithFloat:self.totalPrice - self.creditsToUse] fontSize:18.0f smallFontSize:14.0f symbol:@""];
            
            [self updateFuzzieCredits];


        } else{
            
            [self showEmptyError:@"Looks like you don't have any fuzzie credits yet." buttonTitle:@"GOT IT" window:NO];
            [self.creditsSwitch setOn:false];
            
        }
        
    } else{
        
        self.creditsToUse = 0.0f;
        
        self.creditsValueContainerHeigthAnchor.constant = 0.0f;
        self.emptyViewHeightAnchor.constant = 16.0f;
        
        [self updateFuzzieCredits];
        
        self.lbPaymentCharge.attributedText = [CommonUtilities getFormattedTotalValue:[NSNumber numberWithFloat:self.totalPrice] fontSize:18.0f smallFontSize:14.0f symbol:@""];
    }
}

#pragma mark - Helper

- (void) goWebView:(NSString*)title urlString:(NSString*)url{

    FZWebView2Controller *webView = [[GlobalConstants extraStoryboard] instantiateViewControllerWithIdentifier:@"Webview2"];
    webView.titleHeader = title;
    webView.URL = url;
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)checkPromoValidate{
    
    NSString *code = [self.etPromoCode.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
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
                [self checkPromoCodeType:dictionary];
            }
            
        }];
    }
}

- (void)checkPromoCodeType:(NSDictionary*)dict{
    
    NSString *promoCodeType = dict[@"promo_code_type"][@"type"];
    
    if(![promoCodeType isEqualToString:@"FUZZIE"] && [self.creditsSwitch isOn]){
        [self showPromoError:@"Fuzzie credits cannot be used with your promo code. To use your credits, remove your promo code." window:NO];
        self.etPromoCode.text = @"";
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
        promoCode = self.etPromoCode.text;
    }
    
    NSString *paymentToken = nil;
    NSString *paymentMode = @"CREDIT_CARD";
    NSDictionary *cardInfo = nil;
 
    if ([FZData sharedInstance].tempCardInfoInputed && [FZData sharedInstance].tempCardInfo) {
        cardInfo = [FZData sharedInstance].tempCardInfo;
    } else if (self.paymentMethodDict) {
        paymentToken = self.paymentMethodDict[@"token"];
    }
    
    if (self.shoppingBag == NO) {
        NSDictionary *itemDict = [self.itemArray firstObject];
        [self showProcessing:NO];
        
        if (self.gifted){
            [PaymentController purchaseGiftCardForGifting:itemDict withPaymentToken:paymentToken andCardInfo:cardInfo andNetsInfo:nil andCredits:self.creditsToUse andPaymentMode: paymentMode andPromoCode: promoCode andMessage:self.message andFriendName:self.receiver.name andCompletion:^(NSDictionary *dictionary, NSError *error) {
                if (error && error.code == 417) {
                    [AppDelegate logOut];
                    return ;
                }
                [self handleSuccessfulPaymentWithDict:dictionary andError:error];
            }];
        } else{
            [PaymentController purchaseGiftCard:itemDict withPaymentToken:paymentToken andCardInfo:cardInfo andNetsInfo:nil andCredits:self.creditsToUse andPaymentMode: paymentMode andPromoCode: promoCode andCompletion:^(NSDictionary *dictionary, NSError *error) {
                if (error && error.code == 417) {
                    [AppDelegate logOut];
                    return ;
                }
                [self handleSuccessfulPaymentWithDict:dictionary andError:error];
            }];
        }
        
    } else {
        [self showProcessing:NO];
        [PaymentController checkoutShoppingBagWithPaymentToken:paymentToken andCardInfo:cardInfo andNetsInfo:nil andCredits:self.creditsToUse andPaymentMode: paymentMode andPromoCode: promoCode andCompletion:^(NSDictionary *dictionary, NSError *error) {
            if (error && error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            [self handleSuccessfulPaymentWithDict:dictionary andError:error];
        }];
    }
    
}


- (void)processPaymentWithNets{
    
    NSString *promoCode = nil;
    if (self.usePromoCode) {
        promoCode = self.etPromoCode.text;
    }
    
    NSString *paymentMode = @"NETS";
    NSDictionary *netsInfo = @{@"payment_reference": self.netsPaymentRef};
    
    if (self.shoppingBag == NO) {
        NSDictionary *itemDict = [self.itemArray firstObject];
        [self showProcessing:NO];
        
        if (self.gifted){
            [PaymentController purchaseGiftCardForGifting:itemDict withPaymentToken:nil andCardInfo:nil andNetsInfo:netsInfo andCredits:self.creditsToUse andPaymentMode: paymentMode andPromoCode: promoCode andMessage:self.message andFriendName:self.receiver.name andCompletion:^(NSDictionary *dictionary, NSError *error) {
                if (error && error.code == 417) {
                    [AppDelegate logOut];
                    return ;
                }
                [self handleSuccessfulPaymentWithDict:dictionary andError:error];
            }];
        } else{
            [PaymentController purchaseGiftCard:itemDict withPaymentToken:nil andCardInfo:nil andNetsInfo:netsInfo andCredits:self.creditsToUse andPaymentMode: paymentMode andPromoCode: promoCode andCompletion:^(NSDictionary *dictionary, NSError *error) {
                if (error && error.code == 417) {
                    [AppDelegate logOut];
                    return ;
                }
                [self handleSuccessfulPaymentWithDict:dictionary andError:error];
            }];
        }
        
    } else {
        [self showProcessing:NO];
        [PaymentController checkoutShoppingBagWithPaymentToken:nil andCardInfo:nil andNetsInfo:netsInfo andCredits:self.creditsToUse andPaymentMode: paymentMode andPromoCode: promoCode andCompletion:^(NSDictionary *dictionary, NSError *error) {
            if (error && error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            [self handleSuccessfulPaymentWithDict:dictionary andError:error];
        }];
    }
    
}


- (void)handleSuccessfulPaymentWithDict:(NSDictionary *)dictionary andError:(NSError *)error {
    [self hidePopView];
    
    if (dictionary) {
        
        if (self.gifted) {
      
            if (dictionary[@"gift"] && ![dictionary[@"gift"] isKindOfClass:[NSNull class]]) {
                
                if ([FZData sharedInstance].sentGiftBox) {
                    
                    [[FZData sharedInstance].sentGiftBox insertObject:dictionary[@"gift"] atIndex:0];
                    [[NSNotificationCenter defaultCenter] postNotificationName:SENT_GIFTBOX_REFRESHED object:nil];
                }
         
            }
            
        } else{
            
            if (self.shoppingBag) {
                
                if (dictionary[@"gifts"] && ![dictionary[@"gifts"] isKindOfClass:[NSNull class]]) {
                    
                    NSArray *gifts = dictionary[@"gifts"];
                    
                    if ([FZData sharedInstance].activeGiftBox) {

                        [[FZData sharedInstance].activeGiftBox insertObjects:gifts atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [gifts count])]];
                        [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
                    }
                    
                }
            
                [GiftController getShoppingBagWithCompletion:nil];
                
                
            } else {
                
                if (dictionary[@"gift"] && ![dictionary[@"gift"] isKindOfClass:[NSNull class]]) {
                    
                    if ([FZData sharedInstance].activeGiftBox) {
                        
                        [[FZData sharedInstance].activeGiftBox insertObject:dictionary[@"gift"] atIndex:0];
                        [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
                    }
                    
                }
            }

        }
        
        [UserController getUserProfileWithCompletion:^(FZUser *user, NSError *error) {
            if (error && error.code == 417) {
                [AppDelegate logOut];
            }
            
            [AppDelegate updateWalletBadge];
        }];
   
        if ([FZData sharedInstance].tempCardInfoInputed) {
            // Refresh Payments if previous card info not verified
            [PaymentController getPaymentMethodsWithCompletion:nil];
            
            [FZData sharedInstance].tempCardInfoInputed = false;
            [FZData sharedInstance].tempCardInfo = nil;
        }
        
        PaymentSuccessViewController *successView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"PaymentSuccessView"];
        successView.successDict = dictionary;
        successView.gifted = self.gifted;
        successView.receiver = self.receiver;
        if (self.gifted) {
            successView.showCashback = YES;
        } else{
            successView.showCashback = NO;
        }
        
        [self.navigationController pushViewController:successView animated:YES];
        
    } else {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
