//
//  JackpotSortViewController.h
//  Fuzzie
//
//  Created by mac on 9/13/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JackpotSortViewControllerDelegate <NSObject>

- (void)changeSortItem;

@end

@interface JackpotSortViewController : FZBaseViewController

@property (weak, nonatomic) id<JackpotSortViewControllerDelegate> delegate;

@end
