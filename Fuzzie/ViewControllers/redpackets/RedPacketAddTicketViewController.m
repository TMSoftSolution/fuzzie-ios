//
//  RedPacketAddTicketViewController.m
//  Fuzzie
//
//  Created by Joma on 3/29/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketAddTicketViewController.h"

@interface RedPacketAddTicketViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UILabel *lbTickets;
@property (weak, nonatomic) IBOutlet UITextField *tfTicket;
@property (weak, nonatomic) IBOutlet UILabel *lbPacket;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalTicket;
@property (weak, nonatomic) IBOutlet UILabel *lbTicketNote;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalTicketViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorLeftConstraint;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)saveButttonPressed:(id)sender;
- (IBAction)getMorebuttonPressed:(id)sender;

@property (assign, nonatomic) BOOL isGetMore;
@property (assign, nonatomic) BOOL isDiscard;
@property (assign, nonatomic) BOOL isEditDiscard;

@end

@implementation RedPacketAddTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.availableTicketCount = [UserController sharedInstance].currentUser.availableJackpotTicketsCount.intValue;
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnSave withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#FA3E3F"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:FONT_NAME_LATO_BOLD size:18.0f];
    button.frame=CGRectMake(0.0, 0.0, 60.0, 30.0);
    [button addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    
    [self.tfTicket setInputAccessoryView:toolBar];
    [self.tfTicket addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (self.availableTicketCount > 1) {
        self.lbTickets.text = [NSString stringWithFormat:@"%d Jackpot tickets available", self.availableTicketCount];
    } else {
        self.lbTickets.text = [NSString stringWithFormat:@"%d Jackpot ticket available", self.availableTicketCount];
    }
    
    self.tempCount = self.ticketCount;
    if (self.tempCount.intValue > 0) {
        self.tfTicket.text = [NSString stringWithFormat:@"%@", self.tempCount];
        self.lbTotalTicket.text = [NSString stringWithFormat:@"%d", self.tempCount.intValue * self.quantity.intValue];
    }
    
    if (self.quantity.intValue == 1) {
        self.totalTicketViewHeightConstraint.constant = 0.0f;
        self.separatorLeftConstraint.constant = 0.0f;
        self.lbTicketNote.text = @"JACKPOT TICKETS TO GIVE";
    } else {
        self.lbPacket.text = [NSString stringWithFormat:@"For %@ Packets", self.quantity];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.tempCount.intValue == 0) {
        textField.text = @"";
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField.text isEqualToString:@"0"] && range.location == 1) {
        
        if ([string isEqualToString:@"0"]){
            return NO;
        } else {
             textField.text = [textField.text substringFromIndex:1];
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        textField.text = @"0";
    }
}

- (void)textFieldDidChange:(UITextField*)textField{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.tempCount = [formatter numberFromString:self.tfTicket.text];
     self.lbTotalTicket.text = [NSString stringWithFormat:@"%d", self.tempCount.intValue * self.quantity.intValue];
}

#pragma mark - FZPopViewDelegate
- (void)okButtonClicked{
    [super okButtonClicked];
    
    if (self.isDiscard) {
        
        [self goJackpotHomePage];
        self.isDiscard = false;
    
    } else if (self.isGetMore){
        
        [self getMorebuttonPressed:nil];
        self.isGetMore = false;
        
    } else if (self.isEditDiscard){
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cancelButtonClicked{
    [super cancelButtonClicked];
    
    self.isDiscard = false;
    self.isGetMore = false;
    self.isEditDiscard = false;
}

#pragma mark - IBAction Helper

- (IBAction)saveButttonPressed:(id)sender {
    
    if (self.availableTicketCount >= self.tempCount.intValue * self.quantity.intValue) {
        
        if ([self.delegate respondsToSelector:@selector(ticketAdded:)]) {
            [self.delegate ticketAdded:self.tempCount];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        [self.view endEditing:YES];
        
        [self showError:@"You don't have enough Jackpot tickets available." headerTitle:@"OOPS!" buttonTitle:@"GET MORE TICKETS" image:@"bear-normal" window:YES];
        self.popView.btnCancel.hidden = NO;
        [self.popView.btnCancel setTitle:@"Close" forState:UIControlStateNormal];
        self.isGetMore = true;
    }
 
}

- (IBAction)getMorebuttonPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    [self showError:@"To get more Jackpot tickets now, you will need to discard your Lucky Packet. Do you wish to continue?" headerTitle:@"DISCARD LUCKY PACKET?" buttonTitle:@"YES, CONTINUE" image:@"bear-normal" window:YES];
    self.popView.btnCancel.hidden = NO;
    [self.popView.btnCancel setTitle:@"No, cancel" forState:UIControlStateNormal];
    self.isDiscard = true;

}

- (void)goJackpotHomePage{
    
    UIViewController *jackpotHomePage = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotHomePageView"];
    jackpotHomePage.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jackpotHomePage animated:YES];

}

- (IBAction)backButtonPressed:(id)sender {
    
    if (self.tempCount && ![self.ticketCount isEqualToNumber:self.tempCount]) {
        
        [self.view endEditing:YES];
        [self showError:@"Do you wish to discard your Lucky Packet?" headerTitle:@"DISCARD LUCKY PACKET?" buttonTitle:@"YES, DISCARD" image:@"bear-dead" window:YES];
        self.popView.btnCancel.hidden = NO;
        [self.popView.btnCancel setTitle:@"No, cancel" forState:UIControlStateNormal];
        self.isEditDiscard = true;
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
