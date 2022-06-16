//
//  RedPacketAddCreditsViewController.m
//  Fuzzie
//
//  Created by Joma on 3/29/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketAddCreditsViewController.h"

#define PREFIX @"S$"

@interface RedPacketAddCreditsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UITextField *tfAmount;
@property (weak, nonatomic) IBOutlet UILabel *lbBalance;
@property (weak, nonatomic) IBOutlet UIView *splitContainer;
@property (weak, nonatomic) IBOutlet UILabel *lbNote;
@property (weak, nonatomic) IBOutlet UIView *splitView;
@property (weak, nonatomic) IBOutlet UILabel *lbRandom;
@property (weak, nonatomic) IBOutlet UILabel *lbEqual;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)splitModeSelected:(id)sender;

@property (assign, nonatomic) BOOL isEditDiscard;
@property (assign, nonatomic) BOOL isDiscard;

@end

@implementation RedPacketAddCreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.user = [UserController sharedInstance].currentUser;
    
    [self setStyling];
}

- (void)setStyling{
    
    if (self.quantity.intValue == 1) {
        self.splitView.hidden = YES;
    }
    
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
    
    [self.tfAmount setInputAccessoryView:toolBar];
    [self.tfAmount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.tempAmount = self.creditAmount;
    if (self.tempAmount.intValue > 0) {
        self.tfAmount.text = [NSString stringWithFormat:@"%@%@", PREFIX, self.tempAmount
                              ];
    }
    
    self.lbBalance.text = [NSString stringWithFormat:@"S$%.2f available", self.user.cashableCredits.floatValue];
    
    [CommonUtilities setView:self.splitContainer withCornerRadius:6.0f withBorderColor:[UIColor colorWithHexString:@"#E5E5E5"] withBorderWidth:1.0f];
    self.lbEqual.lineBreakMode = NSLineBreakByWordWrapping;
    self.lbEqual.numberOfLines = 0;
    self.lbRandom.lineBreakMode = NSLineBreakByWordWrapping;
    self.lbRandom.numberOfLines = 0;
    
     [CommonUtilities setView:self.btnSave withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    self.tempMode = self.isRandomMode;
    [self updateSplit];
    [self updateSplitNote];
}

- (void)updateSplit{
    
    UIColor *color = [UIColor colorWithRed:66.0f/255.0f green:66.0f/255.0f blue:66.0f/255.0f alpha:0.3f];
    
    NSString *randomString = @"SPLIT \nRANDOMLY";
    NSString *equalString = @"SPLIT \nEQUALLY";
    
    NSMutableAttributedString *random = [[NSMutableAttributedString alloc] initWithString:randomString attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#424242"]}];
    NSMutableAttributedString *equal = [[NSMutableAttributedString alloc] initWithString:equalString attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#424242"]}];
    
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.alignment = NSTextAlignmentCenter;
    
    [random addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, randomString.length)];
    [equal addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, equalString.length)];
    
    if (self.tempMode) {
     
        [random addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:HEX_COLOR_RED] range:[randomString rangeOfString:@"RANDOMLY"]];
        [equal addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, equalString.length)];
        
        self.lbRandom.attributedText = random;
        self.lbEqual.attributedText = equal;
        
    } else {
        
        [random addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, randomString.length)];
        [equal addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:HEX_COLOR_RED] range:[equalString rangeOfString:@"EQUALLY"]];
        
        self.lbRandom.attributedText = random;
        self.lbEqual.attributedText = equal;
        
    }
}

- (void)updateSplitNote{
    
    if (self.tempMode) {
        
        self.lbNote.text = @"Your budget will be split randomly among all your Lucky Packets.";
        
    } else {
        
        float amount = [self.tempAmount floatValue] / [self.quantity intValue];
        
        NSString *first = @"Your budget will be split equally. Each Lucky Packet will contain ";
        NSString *second = [NSString stringWithFormat:@"S$%.2f", amount];
        NSString *string = [NSString stringWithFormat:@"%@%@", first, second];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:12.0f] range:[string rangeOfString:second]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:HEX_COLOR_RED] range:[string rangeOfString:second]];
        
        self.lbNote.attributedText = attributedString;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.text.length == 0 || self.tempAmount.intValue <= 0) {
        textField.text = PREFIX;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([textField.text isEqualToString:@"S$0"] && range.location == 3) {
        
        if ([string isEqualToString:@"0"]) {
            
            return NO;
            
        } else {
            
            textField.text = [NSString stringWithFormat:@"%@", PREFIX];
            
        }
        
    } else if ([textField.text isEqualToString:PREFIX] && range.location == PREFIX.length - 1 && range.length == 1) {
        
        return NO;
        
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.text.length == 2) {
        textField.text = @"S$0";
    }
}

- (void)textFieldDidChange:(UITextField*)textField{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (textField.text.length > 2) {
        self.tempAmount = [formatter numberFromString:[self.tfAmount.text substringFromIndex:2]];
    } else{
        
        self.tempAmount = [NSNumber numberWithInt:0];
    }

    [self updateSplitNote];
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    
    if (self.isRandomMode != self.tempMode || ![self.creditAmount isEqualToNumber:self.tempAmount]) {
        
        [self.view endEditing:YES];
        [self showError:@"Do you wish to discard your Lucky Packet?" headerTitle:@"DISCARD LUCKY PACKET?" buttonTitle:@"YES, DISCARD" image:@"bear-dead" window:YES];
        self.popView.btnCancel.hidden = NO;
        [self.popView.btnCancel setTitle:@"No, cancel" forState:UIControlStateNormal];
        self.isEditDiscard = true;
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - FZPopViewDelegae
- (void)okButtonClicked{
    [super okButtonClicked];
    
    if (self.isEditDiscard) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if (self.isDiscard){
        
        self.isDiscard = false;
        [self goTopUpPage];
    }
}

- (void)cancelButtonClicked{
    [super cancelButtonClicked];
    
    self.isDiscard = false;
    self.isEditDiscard = false;
}

- (IBAction)saveButtonPressed:(id)sender {
    
    if (self.tempAmount.floatValue > self.user.cashableCredits.floatValue) {
        
        [self.view endEditing:YES];
        [self showError:@"You don't have enough credits." headerTitle:@"OOPS!" buttonTitle:@"TOP UP CREDITS NOW" image:@"bear-dead" window:YES];
        self.popView.btnCancel.hidden = NO;
        [self.popView.btnCancel setTitle:@"Close" forState:UIControlStateNormal];
        self.isDiscard = true;
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(creditAdded:isRandomMode:)]) {
            [self.delegate creditAdded:self.tempAmount isRandomMode:self.tempMode];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)goTopUpPage{

    UIViewController *topUpView = [[GlobalConstants topUpStoryboard] instantiateViewControllerWithIdentifier:@"TopUpFuzzieCreditsView"];
    topUpView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:topUpView animated:YES];
    
}

- (IBAction)splitModeSelected:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    if (button.tag == 1) {
        self.tempMode = false;
    } else {
        self.tempMode = true;
    }
    
    [self updateSplit];
    [self updateSplitNote];
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
