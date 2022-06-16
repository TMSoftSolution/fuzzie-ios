//
//  ClubExclusiveView.h
//  Fuzzie
//
//  Created by joma on 12/7/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubExclusiveViewDelegate <NSObject>

- (void) clubExclusiveViewExploreButtonPressed;
- (void) clubExclusiveViewCloseButtonPressed;

@end

@interface ClubExclusiveView : UIView

@property (weak, nonatomic) id<ClubExclusiveViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *btnExplore;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

- (IBAction)exploreButtonPressed:(id)sender;
- (IBAction)closeButtonPressed:(id)sender;

@end
