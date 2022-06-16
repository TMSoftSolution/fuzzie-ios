//
//  JackpotPinTextField.h
//  Fuzzie
//
//  Created by mac on 9/9/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JackpotPinTextFieldDelegate <NSObject>

- (void)backSpaceDetected:(UITextField*)textField;

@end

@interface JackpotPinTextField : UITextField

@property (weak, nonatomic) id <JackpotPinTextFieldDelegate> jackpotPinTextFieldDelegate;

@end
