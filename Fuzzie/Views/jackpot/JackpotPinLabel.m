//
//  JackpotPinLabel.m
//  Fuzzie
//
//  Created by mac on 9/10/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotPinLabel.h"

@implementation JackpotPinLabel

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#323232"];
        self.layer.cornerRadius = 4.0f;
        self.layer.borderColor = [UIColor colorWithHexString:@"#5B5B5B"].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f].CGColor;
        self.layer.shadowOpacity = 1.0f;
        self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        self.layer.shadowRadius = 9.0f;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
        self.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
}

- (instancetype)init{
    if (self == [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#323232"];
        self.layer.cornerRadius = 4.0f;
        self.layer.borderColor = [UIColor colorWithHexString:@"#5B5B5B"].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f].CGColor;
        self.layer.shadowOpacity = 1.0f;
        self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        self.layer.shadowRadius = 9.0f;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
        self.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

@end
