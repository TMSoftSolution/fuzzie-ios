//
//  PayUseCreditsView.m
//  Fuzzie
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "PayUseCreditsView.h"

@implementation PayUseCreditsView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initView];
}

- (void)initView{
    self.maskView.backgroundColor = [UIColor whiteColor];
    self.maskView.layer.masksToBounds = YES;
    self.maskView.layer.cornerRadius = 15.0f;
}

- (void)showCreditsValue:(CGFloat)creditsValue{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"-" attributes:@{NSFontAttributeName : [UIFont fontWithName:FONT_NAME_BLACK size:50.0f]}];
    [attributedString appendAttributedString:[CommonUtilities getFormattedValueWithPrice:[NSNumber numberWithFloat:creditsValue] mainFontName:FONT_NAME_BLACK mainFontSize:50.0f secondFontName:FONT_NAME_BLACK secondFontSize:40.0f symboFontName:FONT_NAME_BLACK symbolFontSize:50.0f]];
    self.lbCreditsValue.attributedText = attributedString;
}

@end
