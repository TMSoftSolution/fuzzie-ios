//
//  JackpotConfirmViewController.m
//  Fuzzie
//
//  Created by mac on 9/8/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotConfirmViewController.h"
#import "JackpotPayViewController.h"

@interface JackpotConfirmViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnCheckOut;

@property (weak, nonatomic) IBOutlet UILabel *lbX;
@property (weak, nonatomic) IBOutlet UILabel *lbBody;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;

- (IBAction)checkoutButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end

@implementation JackpotConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    [CommonUtilities setView:self.btnCheckOut withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    int couponCount = [self.coupon.ticketCount intValue];
    self.lbX.text = [NSString stringWithFormat:@"X%d", couponCount];
    
    NSString *first = @"You are entitled to ";
    NSString *second = @"";
    NSString *third = @" with this purchase.";
    if (couponCount == 1) {
        second = [NSString stringWithFormat:@"%d free Jackpot ticket",couponCount];
    } else {
        second = [NSString stringWithFormat:@"%d free Jackpot tickets",couponCount];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", first, second, third]];
    [attributedString setAttributes:@{NSFontAttributeName: [UIFont fontWithName:FONT_NAME_LATO_BOLD size:12.0f]} range:NSMakeRange(first.length, second.length)];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.alignment = NSTextAlignmentCenter;
    paragrapStyle.lineHeightMultiple = 1.1;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, first.length + second.length + third.length)];
    
    self.lbBody.attributedText = attributedString;
    
    self.lbDate.text = [NSString stringWithFormat:@"Valid till %@", [[GlobalConstants jackpotTicketsValidFormatter] stringFromDate:[[GlobalConstants dateApiFormatter] dateFromString:[UserController sharedInstance].currentUser.jackpotTicketsExpirationDate]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkoutButtonPressed:(id)sender {
    
    JackpotPayViewController *payView = [[GlobalConstants paymentStoryboard] instantiateViewControllerWithIdentifier:@"JackpotPayView"];
    payView.coupon = self.coupon;
    [self.navigationController pushViewController:payView animated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
