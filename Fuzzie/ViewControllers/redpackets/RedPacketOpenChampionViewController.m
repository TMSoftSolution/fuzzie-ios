//
//  RedPacketOpenChampionViewController.m
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketOpenChampionViewController.h"
#import "RedPacketReceiveDetailsViewController.h"

@interface RedPacketOpenChampionViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnGot;
@property (weak, nonatomic) IBOutlet UILabel *lbBody;

- (IBAction)gotButtonPressed:(id)sender;

@end

@implementation RedPacketOpenChampionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnGot withBackground:[UIColor whiteColor] withRadius:4.0f];
    
    NSString *string = [NSString stringWithFormat:@"%@, you have obtained the highest amount for this round. Good job!", [UserController sharedInstance].currentUser.firstName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : [UIFont fontWithName:FONT_NAME_LATO_REGULAR size:14.0f]}];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BLACK size:14.0f] range:[string rangeOfString:@"highest amount"]];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.lineHeightMultiple = 1.2;
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
    
    self.lbBody.attributedText = attributedString;
}

#pragma mark - IBAction Helper
- (IBAction)gotButtonPressed:(id)sender {
    
    [self goRedPacketHistoryPage];
}

- (void)goRedPacketHistoryPage{
     
    UIViewController *walletView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"WalletView"];
    
    UIViewController *redPacketHistoryView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketHistoryView"];
    redPacketHistoryView.hidesBottomBarWhenPushed = YES;
    
    RedPacketReceiveDetailsViewController *receiveDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketReceiveDetailsView"];
    receiveDetailsView.redPacket = self.redPacket;
    receiveDetailsView.hidesBottomBarWhenPushed = YES;
    
    NSArray *viewControllers = [NSArray arrayWithObjects:walletView, redPacketHistoryView, receiveDetailsView, nil];
    
    [self.navigationController setViewControllers:viewControllers animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
