//
//  RedPacketPaySuccessJackpotViewController.m
//  Fuzzie
//
//  Created by movdev on 3/13/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketPaySuccessJackpotViewController.h"
#import "RedPacketPaySuccessViewController.h"

@interface RedPacketPaySuccessJackpotViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lbBody;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;

- (IBAction)continueButtonPressed:(id)sender;
@end

@implementation RedPacketPaySuccessJackpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    int ticketsCount = [FZData sharedInstance].assignedTicketsCountWithRedPacketBundle.intValue;
    NSString *ticketString = @"";
    if (ticketsCount == 1) {
        ticketString = [NSString stringWithFormat:@"%d FREE JACKPOT TICKET", ticketsCount];
    } else{
        ticketString = [NSString stringWithFormat:@"%d FREE JACKPOT TICKETS", ticketsCount];
    }
    NSString *string = [NSString stringWithFormat:@"CONGRATS! YOU'VE UNLOCKED %@", ticketString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FEC413"] range:[string rangeOfString:ticketString]];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.lineHeightMultiple = 1.1;
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
    self.lbBody.attributedText = attributedString;

    [CommonUtilities setView:self.btnContinue withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
}

- (IBAction)continueButtonPressed:(id)sender {
    
    RedPacketPaySuccessViewController *paySuccessView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketPaySuccessView"];
    paySuccessView.successDict = self.successDict;
    [self.navigationController pushViewController:paySuccessView animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
