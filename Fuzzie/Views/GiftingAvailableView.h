//
//  GiftingAvailableView.h
//  Fuzzie
//
//  Created by mac on 7/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GiftingAvailableViewDelegate <NSObject>

- (void)gotItButtonPressed;
- (void)howItWorkButtonPressed;

@end

@interface GiftingAvailableView : UIView

@property (weak, nonatomic) id<GiftingAvailableViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIButton *gotItButton;
- (IBAction)gotItButtonClicked:(id)sender;
- (IBAction)howItWorkButtonClicked:(id)sender;

@end
