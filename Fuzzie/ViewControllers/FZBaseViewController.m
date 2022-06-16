//
//  FZBaseViewController.m
//  Fuzzie
//
//  Created by mac on 9/21/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FZBaseViewController.h"

@interface FZBaseViewController ()

@end

@implementation FZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINib *loaderNib = [UINib nibWithNibName:@"FuzzieLoaderView" bundle:nil];
    self.loader = [[loaderNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    UINib *popNib = [UINib nibWithNibName:@"FZPopView" bundle:nil];
    self.popView = [[popNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.popView.delegate = self;
    
    UINib *exclusiveNib = [UINib nibWithNibName:@"ClubExclusiveView" bundle:nil];
    self.clubExclusiveView = [[exclusiveNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    UINib *verifyNib = [UINib nibWithNibName:@"LocationVerifyView" bundle:nil];
    self.locationVerifyView = [[verifyNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    UINib *noMatchNib = [UINib nibWithNibName:@"LocationNoMatchView" bundle:nil];
    self.locationNoMatchView = [[noMatchNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    self.window = [UIApplication sharedApplication].keyWindow;
}


- (void)showLoader{
    
    if (![self.loader isDescendantOfView:self.view]) {
        [self.view addSubview:self.loader];
        self.loader.frame = self.view.frame;
        [self.loader setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
        [self.loader startLoader];
    }
}

- (void)hideLoader{
    if (self.loader != nil && [self.loader isDescendantOfView:self.view]) {
        [self.loader stopLoader];
        [self.loader removeFromSuperview];
    }
}

- (void)showLoaderToWindow{
    if (![self.loader isDescendantOfView:self.window]) {
        [self.window addSubview:self.loader];
        self.loader.frame = self.window.frame;
        [self.loader setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
        [self.loader startLoader];
    }
}

- (void)hideLoaderFromWindow{
    if (self.loader != nil && [self.loader isDescendantOfView:self.window]) {
        [self.loader stopLoader];
        [self.loader removeFromSuperview];
    }
}

- (void)showNormalWith:(NSString *)title window:(BOOL)window{
    [self showPopView:window];
    [self.popView showNormalWith:title];
}

- (void)showProcessing:(BOOL)window{
    [self showPopView:window];
    [self.popView showProcessing];
    
}

- (void)showProcessing:(NSString *)title atWindow:(BOOL)window{
    [self showPopView:window];
    [self.popView showProcessing:title];
}

- (void)showCrafting:(BOOL)window{
    [self showPopView:window];
    [self.popView showCrafting];
}

- (void)showVerifying:(BOOL)window{
    [self showPopView:window];
    [self.popView showVerifying];
}

- (void)resendingCode:(BOOL)window{
    [self showPopView:window];
    [self.popView resendingCode];
}

- (void)showSuccess:(BOOL)window{
    [self showPopView:window];
    [self.popView showSuccess];
}

- (void)showSuccess:(NSString *)title window:(BOOL)window{
    [self showPopView:window];
    [self.popView showSuccess:title];
}

- (void)showSuccess:(NSString *)message buttonTitle:(NSString *)title window:(BOOL)window{
    [self showPopView:window];
    [self.popView showSuccess:message buttonTitle:title];
}

- (void)showSuccess:(NSString *)successTitle withMessage:(NSString *)message buttonTitle:(NSString *)title window:(BOOL)window{
    [self showPopView:window];
    [self.popView showSuccess:successTitle withMessage:message buttonTitle:title];
}

- (void)showFail:(NSString *const)message window:(BOOL)window{
    [self showPopView:window];
    [self.popView showFail:message];
}

- (void)showFail:(NSString *const)message buttonTitle:(NSString *)title window:(BOOL)window{
    [self showPopView:window];
    [self.popView showFail:message buttonTitle:title];
}

- (void)showFail:(NSString *const)message withErrorCode:(NSInteger)errorCode window:(BOOL)window{
    [self showPopView:window];
    [self.popView showFail:message withErrorCode:errorCode];
}

- (void)showEmptyError:(NSString *)message window:(BOOL)window{
    [self showPopView:window];
    [self.popView showEmptyError:message];
}

- (void)showEmptyError:(NSString *)message buttonTitle:(NSString *)title window:(BOOL)window{
    [self showPopView:window];
    [self.popView showEmptyError:message buttonTitle:title];
}

- (void)showClipboardCopy:(NSString *)body window:(BOOL)window{
    [self showPopView:window];
    [self.popView showClipboardCopy:body];
}

- (void)showRedeem:(BOOL)window{
    [self showPopView:window];
    [self.popView showRedeem];
}

- (void)showPromoError:(NSString *)message window:(BOOL)window{
    [self showPopView:window];
    [self.popView showPromoError:message];
}

- (void)showError:(NSString *)message headerTitle:(NSString *)headerTitle buttonTitle:(NSString *)buttonTitle image:(NSString *)image window:(BOOL)window{
    [self showPopView:window];
    [self.popView showError:message headerTitle:headerTitle buttonTitle:buttonTitle image:image];
}

- (void)showErrorWith:(NSAttributedString *)message headerTitle:(NSString *)headerTitle buttonTitle:(NSString *)buttonTitle image:(NSString *)image window:(BOOL)window{
    [self showPopView:window];
    [self.popView showErrorWith:message headerTitle:headerTitle buttonTitle:buttonTitle image:image];
}

#pragma mark - FZPopViewDelegate
- (void)okButtonClicked{
    [self hidePopView];
}

- (void)signButttonClicked{
    [self hidePopView];
}

- (void)cancelButtonClicked{
    [self hidePopView];
}

- (void)showPopView:(BOOL)window{
    if (window) {
        [self.window addSubview:self.popView];
        self.popView.frame = self.window.frame;
    } else{
        [self.view addSubview:self.popView];
        self.popView.frame = self.view.frame;
    }
}

- (void)hidePopView{
    [self.popView hidePop];
    [self.popView removeFromSuperview];
}

- (void)showClubExclusiveView{
    
    if (![self.clubExclusiveView isDescendantOfView:self.view]) {
        
        [self.view addSubview:self.clubExclusiveView];
        self.clubExclusiveView.frame = self.view.frame;
        self.clubExclusiveView.delegate = self;
    }
}

- (void)hideClubExclusiveView{
    
    if ([self.clubExclusiveView isDescendantOfView:self.view]) {
        
         [self.clubExclusiveView removeFromSuperview];
    }
    
}

#pragma mark - ClubExclusiveViewDelegate
- (void)clubExclusiveViewExploreButtonPressed{
    
    [self hideClubExclusiveView];
}

- (void)clubExclusiveViewCloseButtonPressed{
    
    [self hideClubExclusiveView];
}

- (void)showLocationVerifyView{
    
    if (![self.locationVerifyView isDescendantOfView:self.view]) {
        
        [self.view addSubview:self.locationVerifyView];
        self.locationVerifyView.frame = self.view.frame;
    }
}

- (void)hideLocationVerifyView{
    
    if ([self.locationVerifyView isDescendantOfView:self.view]) {
        
        [self.locationVerifyView removeFromSuperview];
    }
}

- (void)showLocationNoMatchView{
    
    if (![self.locationNoMatchView isDescendantOfView:self.view]) {
        
        [self.view addSubview:self.locationNoMatchView];
        self.locationNoMatchView.frame = self.view.frame;
        self.locationNoMatchView.delegate = self;
    }
}

- (void)hideLocationNoMatchView{
    
    if ([self.locationNoMatchView isDescendantOfView:self.view]) {
        
        [self.locationNoMatchView removeFromSuperview];
    }
}

#pragma mark - LocationNoMatchViewDelegate
- (void)locationNoMatchViewChangeButtonPressed{
    
    [self hideLocationNoMatchView];
}

- (void)locationNoMatchViewCancelButtonPressed{
    
    [self hideLocationNoMatchView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
