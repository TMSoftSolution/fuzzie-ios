//
//  RedPacketOpenViewController.m
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketOpenViewController.h"
#import "RedPacketOpenSuccessViewController.h"

@interface RedPacketOpenViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ivAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbMessage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *btnOpen;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)openButtonPressed:(id)sender;


@end

@implementation RedPacketOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [CommonUtilities setView:self.btnOpen withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.ivAvatar withCornerRadius:30.0f];
    
    if (self.redPacket) {
        
        NSString *senderImageUrl = self.redPacket[@"sender"][@"avatar"];
        if (senderImageUrl && ![senderImageUrl isKindOfClass:[NSNull class]] && ![senderImageUrl isEqualToString:@""]){
            
            [self.ivAvatar sd_setImageWithURL:[NSURL URLWithString:senderImageUrl] placeholderImage:[UIImage imageNamed:@"profile-image"]];
            
        } else {
            
            self.ivAvatar.image = [UIImage imageNamed:@"profile-image"];
        }
        
        self.lbName.text = self.redPacket[@"sender"][@"name"];
        
        NSString *message = self.redPacket[@"message"];
        if (message && message.length > 0) {
            
            self.lbMessage.text = [NSString stringWithFormat:@"\"%@\"", message];
            
        } else {
            
            self.lbMessage.text = @"";
            
        }
    }
    
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openButtonPressed:(id)sender {
    
    if (self.redPacket) {
        
        NSString *redPacketId = [NSString stringWithFormat:@"%@", self.redPacket[@"id"]];
        
        [self showProcessing:YES];
        
        [RedPacketController openReceivedRedPacket:redPacketId completion:^(NSDictionary *dictionary, NSError *error) {
            
            [self hidePopView];
            
            if (error) {
                
                if (error.code == 417) {
                    [AppDelegate logOut];
                } else {
                    [self showEmptyError:error.localizedDescription window:YES];
                }
            }
            
            if (dictionary) {
                
                [UserController getUserProfileWithCompletion:^(FZUser *user, NSError *error) {
                    [AppDelegate updateWalletBadge];
                }];
                [FZData replaceReceivedRedPacket:dictionary];
                [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVED_RED_PACKETS_REFRESHED object:nil];

                RedPacketOpenSuccessViewController *successView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketOpenSuccessView"];
                successView.redPacket = dictionary;
                [self.navigationController pushViewController:successView animated:YES];
            
            }
            
        }];
    }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
