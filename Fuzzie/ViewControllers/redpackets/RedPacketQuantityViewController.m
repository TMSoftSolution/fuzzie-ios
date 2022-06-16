//
//  RedPacketQuantityViewController.m
//  Fuzzie
//
//  Created by Joma on 3/28/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketQuantityViewController.h"
#import "RedPacketAddItemsViewController.h"
#import "JackpotLearnMoreViewController.h"

@interface RedPacketQuantityViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UITextField *tfQuantity;

- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;

@property (strong, nonatomic) NSNumber *quantity;

@end

@implementation RedPacketQuantityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [self.tfQuantity becomeFirstResponder];    
    [self.tfQuantity addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self updateNextButton];
    
}

- (void)updateNextButton{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.quantity = [formatter numberFromString:self.tfQuantity.text];
    
    if (self.tfQuantity.text.length == 0 || self.quantity.intValue <= 0) {
        [self.btnNext setEnabled:false];
        [CommonUtilities setView:self.btnNext withBackground:[UIColor colorWithHexString:@"#DADADA"] withRadius:4.0f];
        
    } else{
        [self.btnNext setEnabled:YES];
        [CommonUtilities setView:self.btnNext withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    }
}

- (void)textFieldDidChange:(UITextField*)textField{
    [self updateNextButton];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([self.tfQuantity isEditing]) {
        [self.view endEditing:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.tfQuantity) {
        if ([textField.text isEqualToString:@"0"]) {
            textField.text = @"";
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.tfQuantity) {
        if (textField.text.length == 0) {
            textField.text = @"0";
        }
    }
}

#pragma mark - IBAction Helper
- (IBAction)nextButtonPressed:(id)sender {
    [self.view endEditing:YES];
    
    if (self.quantity.intValue == 1) {
        
        [self showError:@"You need to set 2 or more Lucky Packets with the group option." headerTitle:@"OOPS!" buttonTitle:@"GOT IT" image:@"bear-dead" window:YES];
        
    } else {
        
        RedPacketAddItemsViewController *addItemsView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketAddItemsView"];
        addItemsView.quantity = self.quantity;
        [self.navigationController pushViewController:addItemsView animated:YES];
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)helpButtonPressed:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"Need help?"];
    
    [actionSheet bk_addButtonWithTitle:@"Read our FAQ" handler:^{
        
        JackpotLearnMoreViewController *learnView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotLearnMoreView"];
        learnView.isRedPacket = YES;
        [self.navigationController pushViewController:learnView animated:YES];
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
