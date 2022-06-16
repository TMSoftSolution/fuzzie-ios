//
//  GiftEditViewController.m
//  Fuzzie
//
//  Created by mac on 7/27/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "GiftEditViewController.h"
@import UITextView_Placeholder;

@interface GiftEditViewController () <UITextFieldDelegate, UITextViewDelegate, FZRedeemPopViewDelegate>

@end

@implementation GiftEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    self.tvMessage.placeholder = @"Your warm & fuzzie message...";
    self.tvMessage.placeholderColor = [UIColor colorWithHexString:@"#ADADAD"];
    self.tvMessage.delegate = self;
    
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
    [self.tvMessage setInputAccessoryView:toolBar];
    
    [self.tfName addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.tfName setInputAccessoryView:toolBar];
    
    self.tfName.text = self.giftDict[@"receiver"][@"name"];
    self.tvMessage.text = self.giftDict[@"message"];
    [self updateSaveButton];

}

- (void)updateSaveButton{
    if (([self.tfName.text isEqualToString:self.giftDict[@"receiver"][@"name"]] && [self.tvMessage.text isEqualToString:self.giftDict[@"message"]]) || [self.tfName.text isEqualToString:@""] || [self.tvMessage.text isEqualToString:@""]) {
        
        self.saveButton.enabled = false;
        [CommonUtilities setView:self.saveButton withBackground:[UIColor colorWithHexString:@"#DADADA"] withRadius:4.0f];

    } else{
        
        self.saveButton.enabled = true;
        [CommonUtilities setView:self.saveButton withBackground:[UIColor colorWithHexString:@"#FA3E3F"] withRadius:4.0f];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.tfName resignFirstResponder];
    return YES;
}

- (void)textFieldDidChanged:(UITextField*) textField{
    [self updateSaveButton];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    [self updateSaveButton];
}

- (void)showConfirmWindow{
    
    UINib *nib = [UINib nibWithNibName:@"FZRedeemPopView" bundle:nil];
    self.confirmView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.confirmView.delegate = self;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.confirmView];
    self.confirmView.frame = window.frame;
    [self.confirmView setGiftEditBackConfirmStyle];
    
    [self.view endEditing:YES];
}

- (void)hideConfirmView{
    [self.confirmView removeFromSuperview];
}

#pragma mark - FZRedeemPopViewDelegate
- (void)redeemButtonPressed{
    [self hideConfirmView];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelButtonPressed{
    [self hideConfirmView];
}

#pragma mark - IBAction Helper

- (IBAction)saveButtonPressed:(id)sender {
    [self showProcessing:YES];
    [GiftController updageGiftInfoWithGiftId:self.giftDict[@"id"] andName:self.tfName.text andMessage:self.tvMessage.text withCompletion:^(NSDictionary *dictionary, NSError *error) {
        [self hidePopView];
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            } else{
                [self showEmptyError:[error localizedDescription] window:YES];
            }
        }
        if (dictionary) {
            
            [FZData replaceSentGift:dictionary];
            self.giftDict = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:dictionary forKey:@"gift"];
            [[NSNotificationCenter defaultCenter] postNotificationName:SENT_GIFT_UPDATED object:nil
                                                              userInfo:userInfo];
            [self updateSaveButton];
            [self showSuccess:@"Your gift has been updated" buttonTitle:@"OK" window:YES];
            self.showSuccess = true;
        }
    }];
}

- (IBAction)backButtonPressed:(id)sender {
    if (![self.tfName.text isEqualToString:self.giftDict[@"receiver"][@"name"]] || ![self.tvMessage.text isEqualToString:self.giftDict[@"message"]]){
        [self showConfirmWindow];
    } else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}

- (void)okButtonClicked{
    [super okButtonClicked];
    
    if (self.showSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cancelButtonClicked{
    [super cancelButtonClicked];
    
    self.showSuccess = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
