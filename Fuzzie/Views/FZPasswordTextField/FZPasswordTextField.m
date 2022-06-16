//
//  FZPasswordTextField.m
//  Fuzzie
//
//  Created by mac on 7/21/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FZPasswordTextField.h"

@implementation FZPasswordTextField

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)setup{
    
    self.secureTextEntry = true;
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.button.frame = CGRectMake(self.bounds.size.width - 100, 0, 50, 50);
    [self.button setImage:[UIImage imageNamed:@"visibility_on"] forState:UIControlStateNormal];
    self.rightView = self.button;
    self.rightViewMode = UITextFieldViewModeAlways;
    
}

- (IBAction)buttonPressed:(id)sender{
    
    self.show = !self.show;
    if (self.show) {
        self.secureTextEntry = false;
        [self.button setImage:[UIImage imageNamed:@"visibility_off"] forState:UIControlStateNormal];
    } else{
        self.secureTextEntry = true;
        [self.button setImage:[UIImage imageNamed:@"visibility_on"] forState:UIControlStateNormal];
    }
}

- (BOOL)shouldChangeTextInRange:(UITextRange *)range replacementText:(NSString *)text{
    
    return true;
}

@end
