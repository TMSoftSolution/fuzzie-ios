//
//  JackpotCouponCollectionViewCell.m
//  Fuzzie
//
//  Created by mac on 9/9/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotCouponCollectionViewCell.h"

@implementation JackpotCouponCollectionViewCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
     [CommonUtilities setView:self withBackground:[UIColor colorWithHexString:@"#282828"] withRadius:8.0f withBorderColor:[UIColor colorWithHexString:@"323232"] withBorderWidth:1.0f];
    
    for (JackpotPinTextField *tf in self.tfDigits) {
        tf.delegate = self;
        tf.jackpotPinTextFieldDelegate = self;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusNext:) name:FOCUS_NEXT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusPrev:) name:FOCUS_PREV object:nil];
}

- (void)setCell:(int)position withDigit:(NSString *)digit withTicketCount:(int)count{
    self.position = position;
    self.lbSequre.text = [NSString stringWithFormat:@"%d/%d", position + 1, count];
    
    if (digit.length == 4) {
        for (UITextField *tf in self.tfDigits) {
            tf.text = [digit substringWithRange:NSMakeRange(tf.tag, 1)];
        }
    } else{
        for (UITextField *tf in self.tfDigits) {
            tf.text = @"";
        }
    }
    
    [self checkFourDigitsFilled];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    textField.text = string;

    NSInteger tag = textField.tag;

    if (textField.text.length >= 1 && string.length > 0) {
        
        if (tag != 3) {
            UITextField *nextTextField = self.tfDigits[tag+1];
            [nextTextField becomeFirstResponder];
        } else{
            UITextField *nextTextField = self.tfDigits[tag];
            [nextTextField resignFirstResponder];
            NSDictionary* userInfo = @{@"position": @(self.position)};
            [[NSNotificationCenter defaultCenter] postNotificationName:FOCUS_NEXT object:self userInfo:userInfo];
        }
        
        [self checkFourDigitsFilled];
        return NO;
    } else if (textField.text.length < 1 && string.length == 0){
        if (tag != 0) {
            UITextField *nextTextField = self.tfDigits[tag-1];
            [nextTextField becomeFirstResponder];
        } else {
            UITextField *nextTextField = self.tfDigits[tag];
            [nextTextField resignFirstResponder];
            NSDictionary* userInfo = @{@"position": @(self.position)};
            [[NSNotificationCenter defaultCenter] postNotificationName:FOCUS_PREV object:self userInfo:userInfo];
        }
        
        textField.text = @"";
        [self checkFourDigitsFilled];
        return NO;

    } else if (textField.text.length < 1){
        textField.text = string;
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSInteger tag = textField.tag;
    
    // Don't focus if previous textfield is empty when input.
    if (tag == 0) {
        if ([textField.text isEqualToString:@""]) {
            return true;
        } else{
            UITextField *nextTextField = self.tfDigits[tag+1];
            if (![nextTextField.text isEqualToString:@""]) {
                [nextTextField becomeFirstResponder];
                return false;
            }
            return true;
        }
    } else{
        UITextField *prevTextField = self.tfDigits[tag-1];
        if ([prevTextField.text isEqualToString:@""]) {
            [prevTextField becomeFirstResponder];
            return false;
        }
    }
    
    // Don't focus if next textfield is non empty when delete.
    if (tag == 3) {
        if (![textField.text isEqualToString:@""]) {
            return true;
        } else{
            UITextField *prevTextField = self.tfDigits[tag-1];
            if ([prevTextField.text isEqualToString:@""]) {
                [prevTextField becomeFirstResponder];
                return false;
            }
            return true;
        }
    } else{
        UITextField *nextTextField = self.tfDigits[tag+1];
        if (![nextTextField.text isEqualToString:@""]) {
            [nextTextField becomeFirstResponder];
            return false;
        }
    }
    
    return true;
}

#pragma mark - JackpotPinTextFieldDelegate
- (void)backSpaceDetected:(UITextField *)textField{
    NSInteger tag = textField.tag;
    if (tag != 0) {
        UITextField *prevTextField = self.tfDigits[tag-1];
        [prevTextField becomeFirstResponder];
    }
    else{
        if (self.position != 0) {
            NSDictionary* userInfo = @{@"position": @(self.position)};
            [[NSNotificationCenter defaultCenter] postNotificationName:FOCUS_PREV object:self userInfo:userInfo];
        }
    }
}

- (void)checkFourDigitsFilled{
    BOOL completed = YES;
    NSString *digits = @"";
    for (UITextField *textField in self.tfDigits) {
        if (textField.text.length == 0) {
            completed = NO;
        } else {
            digits = [digits stringByAppendingString:textField.text];
        }
    }
    
    if (completed) {
        [CommonUtilities setView:self withBackground:[UIColor colorWithHexString:@"#282828"] withRadius:8.0f withBorderColor:[UIColor colorWithHexString:HEX_COLOR_RED] withBorderWidth:1.0f];
        if ([self.delegate respondsToSelector:@selector(completeDigits:withDigits:)]) {
            [self.delegate completeDigits:self.position withDigits:digits];
        }
    } else{
        [CommonUtilities setView:self withBackground:[UIColor colorWithHexString:@"#282828"] withRadius:8.0f withBorderColor:[UIColor colorWithHexString:@"323232"] withBorderWidth:1.0f];
        if ([self.delegate respondsToSelector:@selector(uncompleteDigits:withDigits:)]) {
            [self.delegate uncompleteDigits:self.position withDigits:digits];
        }
        return;
    }
}

- (void)focusNext:(NSNotification*)notification{
//    NSLog(@"Focus Next");
    NSDictionary* userInfo = notification.userInfo;
    int position = [userInfo[@"position"] intValue];
    if (self.position == position + 1) {
        UITextField *textField = self.tfDigits[0];
        [textField becomeFirstResponder];
    }
   
}

- (void)focusPrev:(NSNotification*)notification{
//    NSLog(@"Focus Prev");
    NSDictionary* userInfo = notification.userInfo;
    int position = [userInfo[@"position"] intValue];
    if (self.position == position - 1) {
        UITextField *textField = self.tfDigits[3];
        [textField becomeFirstResponder];
    }
    
}

@end
