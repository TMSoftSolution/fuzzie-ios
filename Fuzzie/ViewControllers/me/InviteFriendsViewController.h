//
//  InviteFriendsViewController.h
//  Fuzzie
//
//  Created by Yevhen Strohanov on 4/12/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZPopView.h"
#import "PasteboardLabel.h"

@interface InviteFriendsViewController : FZBaseViewController
@property (strong, nonatomic) IBOutlet UIView *codeView;
@property (strong, nonatomic) IBOutlet UILabel *getTitle;
@property (weak, nonatomic) IBOutlet UILabel *bodyText;
@property (strong, nonatomic) FZPopView *pop;
@property (strong, nonatomic) IBOutlet PasteboardLabel *referralCode;
@property (weak, nonatomic) IBOutlet UILabel *successfulReferralCount;
@property (strong, nonatomic) IBOutlet UILabel *totalReferralCount;
@property (strong, nonatomic) IBOutlet UILabel *creditsReward;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *successActivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *totalActivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *creditsAcitivy;

@end
