//
//  DeliveryMethodViewController.m
//  Fuzzie
//
//  Created by mac on 6/22/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "DeliveryMethodViewController.h"
#import "GiftReceiverAvatarView.h"
#import "FZTabBarViewController.h"
#import "GiftEmailSendViewController.h"
#import "GiftBoxViewController.h"


#define MESSAGE_BODY @"I've just sent you a gift on Fuzzie! Click this link to open your gift: "

@interface DeliveryMethodViewController () <FBSDKSharingDelegate, MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *backButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *giftImage;
@property (weak, nonatomic) IBOutlet UILabel *giftName;
@property (weak, nonatomic) IBOutlet UILabel *giftPrice;
@property (weak, nonatomic) IBOutlet UIView *senderView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) GiftReceiverAvatarView *senderInfoView;

@property (assign, nonatomic) BOOL sent;

- (IBAction)whatsappButtonPressed:(id)sender;
- (IBAction)messengerButtonPressed:(id)sender;
- (IBAction)smsButtonPressed:(id)sender;
- (IBAction)emailButtonPressed:(id)sender;
- (IBAction)copyLinkButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

@end

@implementation DeliveryMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground) name:@"appDidEnterForeground" object:nil];

    [self initData];
    [self setStying];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.sent) {
        [self updateDoneButton];
    }
}

- (void)initData{
    
    if (self.giftDict[@"gift_card"] && [self.giftDict[@"gift_card"] isKindOfClass:[NSDictionary class]]) {
        self.giftCardDict = self.giftDict[@"gift_card"];
    }
    
    if (self.giftDict[@"service"] && [self.giftDict[@"service"] isKindOfClass:[NSDictionary class]]) {
        self.giftServiceDict = self.giftDict[@"service"];
    }
}

- (void)setStying{
    
    if (self.showBack) {
        self.backButtonView.hidden = NO;
    } else{
        self.backButtonView.hidden = YES;
    }
    
    if (self.giftDict[@"image"] && [self.giftDict[@"image"] isKindOfClass:[NSString class]] && ![self.giftDict[@"image"] isEqualToString:@""]) {
        
        [self.giftImage sd_setImageWithURL:[NSURL URLWithString:self.giftDict[@"image"]] placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
    }
    
    if (self.giftCardDict) {
        [self.giftName setText:self.giftCardDict[@"display_name"]];
        [self.giftPrice setText:[NSString stringWithFormat:@"%@%@", self.giftCardDict[@"price"][@"currency_symbol"], self.giftCardDict[@"price"][@"value"]]];
    } else{
        [self.giftName setText:self.giftServiceDict[@"display_name"]];
        [self.giftPrice setText:[NSString stringWithFormat:@"%@%@", self.giftServiceDict[@"price"][@"currency_symbol"], self.giftServiceDict[@"price"][@"value"]]];
    }
    
    UINib *customNib = [UINib nibWithNibName:@"GiftReceiverAvatarView" bundle:nil];
    self.senderInfoView = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    if (self.receiver) {
        [self.senderInfoView setReceiverView:self.receiver];
        [self.senderView addSubview:self.senderInfoView];
    }
    
    [self updateDoneButton];

}


-(void)popHide{
    [self hidePopView];
    [self updateDoneButton];
}

#pragma mark - Button Action
- (IBAction)whatsappButtonPressed:(id)sender {
    if (!self.sent) {
        self.sent = true;
    }
    
    CFStringRef message = (__bridge CFStringRef)[NSString stringWithFormat:@"%@%@", MESSAGE_BODY, self.giftDict[@"gift_url"]];
    CFStringRef encodedString = CFURLCreateStringByAddingPercentEscapes(
                                                                        kCFAllocatorDefault,
                                                                        message,
                                                                        NULL,
                                                                        CFSTR(":/?#[]@!$&'()*+,;="),
                                                                        kCFStringEncodingUTF8);
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@",(__bridge NSString*)encodedString]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
    {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    } else{
        
    }

}

- (IBAction)messengerButtonPressed:(id)sender {
    if (!self.sent) {
        self.sent = true;
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb-messenger://"]])
    {
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:self.giftDict[@"gift_url"]];
        [FBSDKMessageDialog showWithContent:content delegate:self];

    }
}

- (IBAction)smsButtonPressed:(id)sender {
    if (!self.sent) {
        self.sent = true;
    }
    
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.body = [NSString stringWithFormat:@"%@%@", MESSAGE_BODY, self.giftDict[@"gift_url"]];
        messageController.messageComposeDelegate = self;
        [self presentViewController:messageController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
}

- (IBAction)emailButtonPressed:(id)sender {
    if (!self.sent) {
        self.sent = true;
    }
    
    GiftEmailSendViewController *giftEmailSendView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"GiftEmailSendView"];
    giftEmailSendView.giftId = self.giftDict[@"id"];
    [self.navigationController pushViewController:giftEmailSendView animated:YES];
}

- (IBAction)copyLinkButtonPressed:(id)sender {
    if (!self.sent) {
        self.sent = true;
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.giftDict[@"gift_url"];
    [self showClipboardCopy:@"Link copied to clipboard" window:NO];
    [self performSelector:@selector(popHide) withObject:self afterDelay:2.0];
}

- (IBAction)doneButtonPressed:(id)sender {
    
    [self showProcessing:NO];
    
    [GiftController markAsDelivered:self.giftDict[@"id"] withCompletion:^(NSDictionary *dictionary, NSError *error) {
        
        [self popHide];
        
        if (dictionary && dictionary[@"gift"]) {
            
            [FZData replaceSentGift:dictionary[@"gift"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:SENT_GIFTBOX_REFRESHED object:nil];
            
        }
        
        if (!self.showBack) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_DISMISS_VIEW object:nil];
                
                FZTabBarViewController *tabBarController = (FZTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
                [tabBarController setSelectedIndex:kTabBarItemWallet];
                UINavigationController *navController = [[tabBarController viewControllers] objectAtIndex:kTabBarItemWallet];
                
                GiftBoxViewController *giftBoxView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"GiftBoxView"];
                giftBoxView.fromDelivery = true;
                giftBoxView.hidesBottomBarWhenPushed = YES;
                [navController pushViewController:giftBoxView animated:YES];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            });
            
        } else{
            
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                
                if ([viewController isKindOfClass:[GiftBoxViewController class]]) {
                    
                    [self.navigationController popToViewController:viewController animated:YES];
                    break;
                    
                }
            }
        }
    }];
    
    
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper

- (void) appDidEnterForeground{
    if (self.sent) {
        [self updateDoneButton];
    }
}

- (void)updateDoneButton{
    if (self.sent) {
        self.doneButton.enabled = true;
        [CommonUtilities setView:self.doneButton withBackground:[UIColor colorWithHexString:@"#FA3E3F"] withRadius:4.0f];
    } else{
        self.doneButton.enabled = false;
        [CommonUtilities setView:self.doneButton withBackground:[UIColor colorWithHexString:@"#DADADA"] withRadius:4.0f];
    }
}

#pragma mark - SMS delegate

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        switch (result) {
            case MessageComposeResultSent:
                break;
            case MessageComposeResultFailed:
                break;
            case MessageComposeResultCancelled:
                break;
            default:
                break;
        }
    }];
}

#pragma mark - Messenger delegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{

}
@end
