//
//  TopUpEnterValueViewController.m
//  Fuzzie
//
//  Created by mac on 9/5/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "TopUpEnterValueViewController.h"
#import "TopUpPayViewController.h"

#define PREFIX @"S$"

@interface TopUpEnterValueViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnTopUp;
@property (weak, nonatomic) IBOutlet UITextField *tfPrice;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)topUpButtonPressed:(id)sender;

@end

@implementation TopUpEnterValueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{

    [self.tfPrice addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self updateTopUpButton];
}

- (void)updateTopUpButton{
    if (self.tfPrice.text.length < 3) {
        [self.btnTopUp setEnabled:false];
        [CommonUtilities setView:self.btnTopUp withBackground:[UIColor colorWithHexString:@"#DADADA"] withRadius:4.0f];
    } else{
        [self.btnTopUp setEnabled:YES];
        
        [CommonUtilities setView:self.btnTopUp withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    }
}

- (void)textFieldDidChange:(UITextField*)textField{
    [self updateTopUpButton];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([self.tfPrice isEditing]) {
        [self.view endEditing:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.tfPrice) {
        if (textField.text.length == 0) {
            textField.text = @"S$";
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField.text isEqualToString:PREFIX] && range.location == PREFIX.length - 1 && range.length == 1) {
        return NO;
    }
    
    if (textField.text.length == 2 && [string isEqualToString:@"0"]) {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.tfPrice) {
        if (textField.text.length == 2) {
            textField.text = @"";
        }
    }
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)topUpButtonPressed:(id)sender {
    [self.view endEditing:YES];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *price = [formatter numberFromString:[self.tfPrice.text substringFromIndex:2]];
    
    if (price < [NSNumber numberWithInteger:10]) {
        [self showEmptyError:@"You have to choose a minimum of S$10 Fuzzie Credits." buttonTitle:@"GOT IT" window:NO];
    } else if (price > [NSNumber numberWithInteger:999]){
        [self showEmptyError:@"You have exceeded the maximum top up amount of S$999." buttonTitle:@"GOT IT" window:NO];
    } else{

        TopUpPayViewController *payView = [[GlobalConstants paymentStoryboard] instantiateViewControllerWithIdentifier:@"TopUpPayView"];
        payView.price = price;
        [self.navigationController pushViewController:payView animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
