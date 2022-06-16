//
//  JackpotCouponDescriptionTableViewCell.h
//  Fuzzie
//
//  Created by mac on 9/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JackpotCouponDescriptionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *tvBody;

- (void)setCell:(NSString *)description;

@end
