//
//  GiftEmailSendViewController.m
//  Fuzzie
//
//  Created by mac on 6/22/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "GiftEmailSendViewController.h"

@interface GiftEmailSendViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UIView *sendCopyView;
@property (weak, nonatomic) IBOutlet UIImageView *sendCopyCheck;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (assign, nonatomic) BOOL copied;
@property (assign, nonatomic ) BOOL sentSuccess;

-(IBAction)copyButtonPressed:(id)sender;
-(IBAction)sendButtonPressed:(id)sender;
- (IBAction)backButttonPressed:(id)sender;


@end

@implementation GiftEmailSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    if (self.redPacketBundleId) {
        [self.sendButton setTitle:@"SEND LUCKY PACKET" forState:UIControlStateNormal];
    }
    
    [self.tfEmail addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self updateCopy];
    [self updateSend];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
-(IBAction)copyButtonPressed:(id)sender{
    self.copied = !self.copied;
    [self updateCopy];
    
}

- (IBAction)sendButtonPressed:(id)sender{

    [self.view endEditing:true];

    if ([CommonUtilities validateEmail:self.tfEmail.text]) {
        
        [self showProcessing:YES];
        
        if (self.giftId) {
            
            [GiftController sendGiftViaEmailWithGiftId:self.giftId andReceiverEmail:self.tfEmail.text andCopy:self.copied withCompletion:^(NSDictionary *dictionary, NSError *error) {
                
                if (!error) {
                    _sentSuccess = true;
                    [self showSuccess:@"EMAIL SENT!" withMessage:@"Your gift has been successfully delivered." buttonTitle:@"DONE" window:YES];
                } else{
                    
                    if (error.code == 417) {
                        [self hidePopView];
                        [AppDelegate logOut];
                        return ;
                    } else{
                        [self showEmptyError:[error localizedDescription] window:YES];
                    }
                }
            }];
        } else if (self.redPacketBundleId){
            
            [RedPacketController sendRedPacketViaEmail:self.redPacketBundleId email:self.tfEmail.text copy:self.copied completion:^(NSDictionary *dictionary, NSError *error) {
                
                if (!error) {
                    _sentSuccess = true;
                    [self showSuccess:@"EMAIL SENT!" withMessage:@"Your Lucky Packet has been successfully sent." buttonTitle:@"DONE" window:YES];
                } else{
                    
                    if (error.code == 417) {
                        [self hidePopView];
                        [AppDelegate logOut];
                        return ;
                    } else{
                        [self showEmptyError:[error localizedDescription] window:YES];
                    }
                }
                
            }];
        }

        
    } else{
        
        [self showEmptyError:@"You need to enter a valid email address." buttonTitle:@"GOT IT" window:YES];
    }
}

- (IBAction)backButttonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper
- (void)updateCopy{
    if (self.copied) {
        [CommonUtilities setView:self.sendCopyView withBackground:[UIColor colorWithHexString:@"#FA3E3F"] withRadius:4.0f];
        [self.sendCopyCheck setImage:[UIImage imageNamed:@"email_check"]];
    } else{
        [CommonUtilities setView:self.sendCopyView withBackground:[UIColor colorWithHexString:@"#DADADA"] withRadius:4.0f];
        [self.sendCopyCheck setImage:[UIImage imageNamed:@"email_uncheck"]];
    }
}

- (void)updateSend{
    if (self.tfEmail.text.length > 0) {
        self.sendButton.enabled = true;
        [CommonUtilities setView:self.sendButton withBackground:[UIColor colorWithHexString:@"#FA3E3F"] withRadius:4.0f];
        
    } else{
        self.sendButton.enabled = false;
        [CommonUtilities setView:self.sendButton withBackground:[UIColor colorWithHexString:@"#DADADA"] withRadius:4.0f];
    }
}


#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.tfEmail resignFirstResponder];
    return YES;
}

- (void)textFieldDidChanged:(UITextField*) textField{
    [self updateSend];
}

#pragma mark - FZPopViewDelegate
- (void)okButtonClicked{
    [self hidePopView];
    if (self.sentSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
