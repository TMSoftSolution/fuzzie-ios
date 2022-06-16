//
//  FZBaseViewController.h
//  Fuzzie
//
//  Created by mac on 9/21/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FuzzieLoaderView.h"
#import "FZPopView.h"
#import "ClubExclusiveView.h"
#import "LocationVerifyView.h"
#import "LocationNoMatchView.h"

@interface FZBaseViewController : UIViewController <FZPopViewDelegate, ClubExclusiveViewDelegate, LocationNoMatchViewDelegate>

@property (strong, nonatomic) UIWindow* window;
@property (strong, nonatomic) FuzzieLoaderView *loader;
@property (strong, nonatomic) FZPopView *popView;
@property (strong, nonatomic) ClubExclusiveView *clubExclusiveView;
@property (strong, nonatomic) LocationVerifyView *locationVerifyView;
@property (strong, nonatomic) LocationNoMatchView *locationNoMatchView;

- (void)showLoader;
- (void)hideLoader;
- (void)showLoaderToWindow;
- (void)hideLoaderFromWindow;

- (void)showNormalWith:(NSString*)title window:(BOOL) window;
- (void)showProcessing:(BOOL) window;
- (void)showProcessing:(NSString*)title atWindow:(BOOL) window;
- (void)showCrafting:(BOOL) window;
- (void)showVerifying:(BOOL) window;
- (void)resendingCode:(BOOL) window;
- (void)showSuccess:(BOOL) window;
- (void)showSuccess:(NSString*)title window:(BOOL) window;
- (void)showSuccess:(NSString*)message buttonTitle:(NSString*)title window:(BOOL) window;
- (void)showSuccess:(NSString*)successTitle withMessage:(NSString*) message buttonTitle:(NSString*)title window:(BOOL) window;
- (void)showFail:(NSString *const)message window:(BOOL) window;
- (void)showFail:(NSString *const)message withErrorCode:(NSInteger)errorCode window:(BOOL) window;
- (void)showFail:(NSString *const)message buttonTitle:(NSString*)title window:(BOOL) window;
- (void)showEmptyError:(NSString*)message window:(BOOL) window;
- (void)showEmptyError:(NSString*)message buttonTitle:(NSString*)title window:(BOOL) window;
- (void)showClipboardCopy:(NSString*)body window:(BOOL) window;
- (void)showRedeem:(BOOL) window;
- (void)showPromoError:(NSString*)message window:(BOOL) window;
- (void)showError:(NSString*)message headerTitle:(NSString*)headerTitle buttonTitle:(NSString*)buttonTitle image:(NSString*)image window:(BOOL) window;
- (void)showErrorWith:(NSAttributedString*)message headerTitle:(NSString*)headerTitle buttonTitle:(NSString*)buttonTitle image:(NSString*)image window:(BOOL) window;
- (void)hidePopView;

- (void)showClubExclusiveView;
- (void)hideClubExclusiveView;

- (void)showLocationVerifyView;
- (void)hideLocationVerifyView;

- (void)showLocationNoMatchView;
- (void)hideLocationNoMatchView;


@end
