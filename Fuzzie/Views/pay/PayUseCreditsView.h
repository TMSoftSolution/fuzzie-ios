//
//  PayUseCreditsView.h
//  Fuzzie
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayUseCreditsView : UIView

@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UILabel *lbCreditsValue;

- (void)showCreditsValue:(CGFloat)creditsValue;

@end
