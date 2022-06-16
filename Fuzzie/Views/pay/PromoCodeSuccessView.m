//
//  PromoCodeSuccessView.m
//  Fuzzie
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "PromoCodeSuccessView.h"

@implementation PromoCodeSuccessView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initView];
}

- (void)initView{
    
    self.maskView.backgroundColor = [UIColor colorWithHexString:@"#3B93DA"];
    self.maskView.layer.masksToBounds = YES;
    self.maskView.layer.cornerRadius = 15.0f;
    
    self.btnDone.backgroundColor = [UIColor whiteColor];
}

- (void)showCashback:(CGFloat)cashback{
    self.lbCashback.text = [NSString stringWithFormat:@"+%.0f%%", cashback];
}

- (IBAction)donButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(promoCodeSucceeViewDoneButtonPressed)]) {
        [self.delegate promoCodeSucceeViewDoneButtonPressed];
    }
}
@end
