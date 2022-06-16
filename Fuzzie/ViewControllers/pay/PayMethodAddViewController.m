//
//  PayMethodAddViewController.m
//  Fuzzie
//
//  Created by mac on 8/16/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "PayMethodAddViewController.h"
#import "PayViewController.h"
#import "TopUpPayViewController.h"
#import "RedPacketPayViewController.h"
#import "ClubSubscribePayViewController.h"
#import <CardIO.h>

@interface PayMethodAddViewController () <UITextFieldDelegate, CardIOPaymentViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *cardInfoContainer;
@property (weak, nonatomic) IBOutlet UITextField *tfCardNumber;
@property (weak, nonatomic) IBOutlet UIImageView *ivCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfExpire;
@property (weak, nonatomic) IBOutlet UIImageView *ivExpire;
@property (weak, nonatomic) IBOutlet UITextField *tfCCV;
@property (weak, nonatomic) IBOutlet UIImageView *ivCCV;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)scanButtonPressed:(id)sender;

@property (nonatomic, strong, readwrite) CardIOView *cardIOView;

@end

@implementation PayMethodAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [CardIOUtilities preloadCardIO];
}

- (void)setStyling{
    
    [self updateSaveButton];
    
    [CommonUtilities setView:self.cardInfoContainer withBackground:[UIColor whiteColor] withRadius:1.0f withBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] withBorderWidth:1.0f];
    
    [self initCardInfoView];
    
}

- (void)updateSaveButton{
    if (self.enableCardNumber && self.enableExprire && self.enableCCV) {
        self.btnSave.hidden = NO;
        [self.btnSave setEnabled:true];
        
    } else{
        self.btnSave.hidden = YES;
        [self.btnSave setEnabled:false];
    }
}

- (void)initCardInfoView{
    
    self.ivCardNumber.hidden = YES;
    self.ivExpire.hidden = YES;
    self.ivCCV.hidden = YES;
    
    self.tfCardNumber.text = @"";
    self.tfExpire.text = @"";
    self.tfCCV.text = @"";
}

- (void)setCardInfoFromScan:(CardIOCreditCardInfo*)cardInfo{
    
    self.ivCardNumber.hidden = NO;
    self.ivExpire.hidden = NO;
    self.ivCCV.hidden = NO;
    
    self.tfCardNumber.text = cardInfo.cardNumber;
    NSString *expireMonth = [@(cardInfo.expiryMonth) stringValue];
    if (expireMonth.length == 1) {
        expireMonth = [NSString stringWithFormat:@"0%@", expireMonth];
    }
    self.tfExpire.text = [[expireMonth stringByAppendingString:@"-"] stringByAppendingString:[[@(cardInfo.expiryYear) stringValue] substringToIndex:2]];
    self.tfCCV.text = cardInfo.cvv;
    
    self.enableCardNumber = true;
    self.enableExprire = true;
    self.enableCCV = true;
    
    [self updateSaveButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *cardNumber = [self.tfCardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSArray *exp = [self.tfExpire.text componentsSeparatedByString:@"-"];
    NSString *month = [exp objectAtIndex:0];
    NSString *year = [exp objectAtIndex:1];
    NSString *expDate = [NSString stringWithFormat:@"%@20%@", month, year];
    NSString *cvv = self.tfCCV.text;
    
    self.cardInfo = @{@"card_number" : cardNumber,
                           @"exp_date" : expDate,
                           @"cvv2" : cvv
                           };
    
    if (self.fromPaymentPage) {
        
        [FZData sharedInstance].tempCardInfoInputed = true;
        [FZData sharedInstance].tempCardInfo = self.cardInfo;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CARD_INFO_INPUTED object:nil];

        for (UIViewController *viewController in self.navigationController.viewControllers) {
            
            if ([viewController isKindOfClass:[PayViewController class]]
                || [viewController isKindOfClass:[TopUpPayViewController class]]
                || [viewController isKindOfClass:[RedPacketPayViewController class]]
                || [viewController isKindOfClass:[ClubSubscribePayViewController class]]) {
                
                [self.navigationController popToViewController:viewController animated:YES];
                return;
            }
        }
        
    } else {
        
        [self showError:@"To validate, your card will be charged $0.01 that will be immediately voided. Do you wish to continue?" headerTitle:@"CARD VALIDATION" buttonTitle:@"YES, VALIDATE NOW" image:@"bear-baby" window:YES];
        self.popView.btnCancel.hidden = NO;
        self.prePay = true;
        
    }
    
}

- (void) saveCard{
    
    [self showProcessing:@"PROCESSING" atWindow:NO];
    
    [PaymentController addPaymentMethod:self.cardInfo withCompletion:^(NSDictionary *dictionary, NSError *error) {
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            
            [self showEmptyError:[error localizedDescription] window:NO];
            
            return ;
        }
        
        if (dictionary) {
            
            NSMutableArray *tempArray;
            
            if ([PaymentController sharedInstance].paymentMethods) {
                tempArray = [[NSMutableArray alloc] initWithArray:[PaymentController sharedInstance].paymentMethods];
                
            } else{
                tempArray = [NSMutableArray new];
            }
            
            [tempArray addObject:dictionary];
            [PaymentController sharedInstance].paymentMethods = [[NSArray alloc] initWithArray:tempArray];
            
            if ([self.delegate respondsToSelector:@selector(paymentMethodAdded:)]) {
                [self.delegate paymentMethodAdded:dictionary];
            }
            
            self.newCardAdded = true;
            [self showSuccess:@"SUCCESS!" withMessage:@"Your new credit/debit card has been added." buttonTitle:@"DONE" window:NO];
        }
    }];
}

- (IBAction)scanButtonPressed:(id)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.collectPostalCode = NO;
    scanViewController.collectExpiry = YES;
    scanViewController.collectCVV = YES;
    scanViewController.useCardIOLogo = YES;
    scanViewController.hideCardIOLogo = YES;
    scanViewController.keepStatusBarStyleForCardIO = YES;
    scanViewController.navigationBarTintColorForCardIO = [UIColor colorWithHexString:HEX_COLOR_RED];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    textField.text = finalString;
    
    if (textField == self.tfCardNumber) {
        
        if (finalString.length == 15 || finalString.length == 16) {
            self.ivCardNumber.hidden = NO;
            self.enableCardNumber = true;
        } else{
            self.ivCardNumber.hidden = YES;
            self.enableCardNumber = false;
        }
        
        if (finalString.length == 16) {
            [self.tfExpire becomeFirstResponder];
        }
        
        if (finalString.length > 16) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 16)];
            self.ivCardNumber.hidden = NO;
            self.enableCardNumber = true;
            [self.tfExpire becomeFirstResponder];
            return NO;
        }
   
    }
    
    if (textField == self.tfExpire) {
     
        if (finalString.length == 1 && [finalString intValue] > 1) {
            textField.text = [NSString stringWithFormat:@"0%@-", finalString];
        }
        
        if (finalString.length == 2 && [finalString intValue] > 12) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
            return NO;
        } else{
            if (finalString.length == 2 && ![finalString containsString:@"-"]) {
                if ([string isEqualToString:@""]) {
                    textField.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
                    return NO;
                }
                textField.text = [textField.text stringByAppendingString:@"-"];
            }
        }
        
        if (finalString.length == 5) {
           
            NSArray *exp = [finalString componentsSeparatedByString:@"-"];
            NSString *year = [exp objectAtIndex:1];
            if ([year intValue] < 18) {
                
                self.ivExpire.hidden = YES;
                self.enableExprire = false;
                
            } else{
                
                self.ivExpire.hidden = NO;
                self.enableExprire = true;
                [self.tfCCV becomeFirstResponder];
            }
            
        } else{
            self.ivExpire.hidden = YES;
            self.enableExprire = false;
        }
        
        if (textField.text.length > 5) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 5)];
            NSArray *exp = [textField.text componentsSeparatedByString:@"-"];
            NSString *year = [exp objectAtIndex:1];
            if ([year intValue] < 18) {
                
                self.ivExpire.hidden = YES;
                self.enableExprire = false;
                
            } else{
                
                self.ivExpire.hidden = NO;
                self.enableExprire = true;
                [self.tfCCV becomeFirstResponder];
            }
            return NO;
        }
    }
    
    if (textField == self.tfCCV) {
        if (finalString.length == 3 || finalString.length == 4) {
            self.ivCCV.hidden = NO;
            self.enableCCV = true;
            
        } else{
            self.ivCCV.hidden = YES;
             self.enableCCV = false;
        }
        
        if (textField.text.length > 4) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 4)];
            self.ivCCV.hidden = NO;
            self.enableCCV = true;
            return NO;
        }
        
    }
    
    [self updateSaveButton];
    
    return NO;
}

#pragma mark - FZPopViewDelegate
- (void)okButtonClicked{
    [self hidePopView];
    if (self.newCardAdded) {
        self.newCardAdded = false;
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.prePay){
        self.prePay = false;
        [self saveCard];
    }
}

- (void)cancelButtonClicked{
    
    [super cancelButtonClicked];
    
    self.newCardAdded = false;
    self.prePay = false;
}

#pragma mark - CardIOPaymentViewControllerDelegate
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController{
    NSLog(@"User cancelled payment info");
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController{

    // The full card number is available as info.cardNumber, but don't log that!
    NSLog(@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", cardInfo.redactedCardNumber, (unsigned long)cardInfo.expiryMonth, (unsigned long)cardInfo.expiryYear, cardInfo.cvv);
    // Use the card info...
    [self setCardInfoFromScan:cardInfo];
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
