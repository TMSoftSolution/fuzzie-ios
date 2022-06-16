//
//  JackpotRefineViewController.h
//  Fuzzie
//
//  Created by mac on 9/14/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JackpotRefineViewControllerDelegate <NSObject>

- (void)jackpotRefineDoneButtonPressed;

@end

@interface JackpotRefineViewController : FZBaseViewController

@property (nonatomic, strong) NSArray *subCategories;
@property (weak, nonatomic) id<JackpotRefineViewControllerDelegate> delegate;

@end
