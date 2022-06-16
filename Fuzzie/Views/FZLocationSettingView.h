//
//  FZLocationSettingView.h
//  Fuzzie
//
//  Created by mac on 7/20/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FZLocationSettingViewDelegate <NSObject>

- (void)settingButtonPressed;
- (void)laterButtonPressed;

@end

@interface FZLocationSettingView : UIView

@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) id<FZLocationSettingViewDelegate> delegate;

@end
