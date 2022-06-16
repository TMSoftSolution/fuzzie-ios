//
//  FZPopView.h
//  Fuzzie
//
//  Created by mac on 4/10/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZPopButton.h"
#import "FLAnimatedImage.h"

@protocol FZPopViewDelegate <NSObject>

@optional
- (void)okButtonClicked;
@optional
- (void)signButttonClicked;
@optional
- (void)cancelButtonClicked;

@end

@interface FZPopView : UIView

@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIImageView *stateImage;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbBody;
@property (weak, nonatomic) IBOutlet FZPopButton *btnOk;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *loader;
@property (weak, nonatomic) IBOutlet UIButton *btnSign;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (weak, nonatomic) id <FZPopViewDelegate> delegate;

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) NSInteger errorCode;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleTopAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maskViewHeightAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bodyHeightAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateImageCenterAnchor;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *stateImageTopAnchor;


- (IBAction)okButtonPressed:(id)sender;
- (IBAction)signButtonPressed:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

- (void)hidePop;
- (void)showNormalWith:(NSString*)title;
- (void)showProcessing;
- (void)showProcessing:(NSString*)title;
- (void)showCrafting;
- (void)showVerifying;
- (void)resendingCode;
- (void)showSuccess;
- (void)showSuccess:(NSString*)title;
- (void)showSuccess:(NSString*)message buttonTitle:(NSString*)title;
- (void)showSuccess:(NSString*)successTitle withMessage:(NSString*) message buttonTitle:(NSString*)title;
- (void)showFail:(NSString *const)message;
- (void)showFail:(NSString *const)message withErrorCode:(NSInteger)errorCode;
- (void)showFail:(NSString *const)message buttonTitle:(NSString*)title;
- (void)showEmptyError:(NSString*)message;
- (void)showEmptyError:(NSString*)message buttonTitle:(NSString*)title;
- (void)showClipboardCopy:(NSString*)body;
- (void)showRedeem;
- (void)showPromoError:(NSString*)message;
- (void)showError:(NSString*)message headerTitle:(NSString*)headerTitle buttonTitle:(NSString*)buttonTitle image:(NSString*)image;
- (void)showErrorWith:(NSAttributedString*)message headerTitle:(NSString*)headerTitle buttonTitle:(NSString*)buttonTitle image:(NSString*)image;
@end
