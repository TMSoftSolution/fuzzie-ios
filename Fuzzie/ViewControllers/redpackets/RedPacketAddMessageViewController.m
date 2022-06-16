
//
//  RedPacketAddMessageViewController.m
//  Fuzzie
//
//  Created by Joma on 3/29/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketAddMessageViewController.h"
@import UITextView_Placeholder;

@interface RedPacketAddMessageViewController ()

@property (weak, nonatomic) IBOutlet UITextView *tvMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)addButtonPressed:(id)sender;

@end

@implementation RedPacketAddMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnAdd withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    self.tvMessage.placeholder = @"Your message";
    self.tvMessage.placeholderColor = [UIColor colorWithHexString:@"ADADAD"];
    
    if (self.message.length > 0) {
        self.tvMessage.text = self.message;
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    
    if (![self.message isEqualToString:self.tvMessage.text]) {
        
        [self.view endEditing:YES];
        [self showError:@"Do you wish to discard your message?" headerTitle:@"DISCARD MESSAGE?" buttonTitle:@"YES, DISCARD" image:@"bear-dead" window:YES];
        self.popView.btnCancel.hidden = NO;
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - FZPopViewDelegae
- (void)okButtonClicked{
    [super okButtonClicked];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(messageAdded:)]) {
        [self.delegate messageAdded:self.tvMessage.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
