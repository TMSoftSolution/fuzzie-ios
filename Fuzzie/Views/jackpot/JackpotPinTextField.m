//
//  JackpotPinTextField.m
//  Fuzzie
//
//  Created by mac on 9/9/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotPinTextField.h"

@implementation JackpotPinTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]) {
        
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
        self.layer.cornerRadius = 5.0f;
        self.layer.borderColor = [UIColor colorWithHexString:@"#363535"].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f].CGColor;
        self.layer.shadowOpacity = 0.2f;
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.layer.shadowRadius = 1.0f;
        self.layer.masksToBounds = YES;
        self.font = [UIFont fontWithName:FONT_NAME_BOLD size:30.0f];
        self.textColor = [UIColor colorWithHexString:@"#FCFCFC"];
        self.textAlignment = NSTextAlignmentCenter;
        self.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    return self;
}

- (void)deleteBackward{
    [super deleteBackward];
    if ([self.jackpotPinTextFieldDelegate respondsToSelector:@selector(backSpaceDetected:)]) {
        [self.jackpotPinTextFieldDelegate backSpaceDetected:self];
    }
}

@end
