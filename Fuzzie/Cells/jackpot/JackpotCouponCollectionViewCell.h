//
//  JackpotCouponCollectionViewCell.h
//  Fuzzie
//
//  Created by mac on 9/9/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JackpotPinTextField.h"

@protocol JackpotCouponCollectionViewCellDelegate <NSObject>

- (void)completeDigits:(int)position withDigits:(NSString*)digits;
- (void)uncompleteDigits:(int)position withDigits:(NSString*)digits;

@end

@interface JackpotCouponCollectionViewCell : UICollectionViewCell <UITextFieldDelegate, JackpotPinTextFieldDelegate>

@property (weak, nonatomic) id<JackpotCouponCollectionViewCellDelegate> delegate;

@property (assign, nonatomic) int position;

@property (weak, nonatomic) IBOutlet UILabel *lbSequre;
@property (strong, nonatomic) IBOutletCollection(JackpotPinTextField) NSArray *tfDigits;


- (void)setCell:(int)position withDigit:(NSString*)digit withTicketCount:(int)count;

@end
