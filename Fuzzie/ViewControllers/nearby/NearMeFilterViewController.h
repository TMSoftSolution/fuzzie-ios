//
//  NearMeFilterViewController.h
//  Fuzzie
//
//  Created by mac on 7/9/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NearMeFilterViewControllerDelegate <NSObject>

- (void)doneButtonClicked;

@end

@interface NearMeFilterViewController : FZBaseViewController

@property (weak, nonatomic) id<NearMeFilterViewControllerDelegate> delegate;

@end
