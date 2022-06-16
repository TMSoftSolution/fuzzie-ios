//
//  JackpotTicketsUseViewController.m
//  Fuzzie
//
//  Created by Joma on 1/17/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "JackpotTicketsUseViewController.h"
#import "JackpotCouponViewController.h"
#import "FZTabBarViewController.h"
#import "JackpotHomePageViewController.h"

@interface JackpotTicketsUseViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSet;
@property (weak, nonatomic) IBOutlet UITextField *tfCount;
@property (weak, nonatomic) IBOutlet UILabel *lbTicketsAvailable;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)setButtonPressed:(id)sender;

@property (assign, nonatomic) int count;
@property (assign, nonatomic) BOOL isCuttingOffTime;
@property (assign, nonatomic) BOOL isGetMore;

@end

@implementation JackpotTicketsUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void) setStyling{
    
    [self updateSetButton];
    
    [self.tfCount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.tfCount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"0" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#EAB202"]}];
    
    NSString *tickets = @"";
    int availableCounts = [[UserController sharedInstance].currentUser.availableJackpotTicketsCount intValue];
    
    if (availableCounts <= 1) {
        tickets = [NSString stringWithFormat:@"%d Jackpot ticket", availableCounts];
    } else {
        tickets = [NSString stringWithFormat:@"%d Jackpot tickets", availableCounts];
    }
    
    NSString *available = [NSString stringWithFormat:@"You've got %@ available.", tickets];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:available];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#EAB202"] range:[available rangeOfString:tickets]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:13.0f] range:[available rangeOfString:tickets]];
    
    self.lbTicketsAvailable.attributedText = attributedString;
}

- (void) updateSetButton{
    
    if (self.tfCount.text.length != 0) {
        
        [CommonUtilities setView:self.btnSet withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
        self.btnSet.enabled = true;
        
    } else {
        
        [CommonUtilities setView:self.btnSet withBackground:[UIColor colorWithHexString:@"#505050"] withRadius:4.0f];
        self.btnSet.enabled = false;
        
    }
}

- (void)textFieldDidChange:(UITextField*)textField{
    [self updateSetButton];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField.text.length == 0 && [string isEqualToString:@"0"]) {
        return NO;
    }
    
    return YES;
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)setButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.count = [[formatter numberFromString:self.tfCount.text] intValue];
    
    int availableCounts = [[UserController sharedInstance].currentUser.availableJackpotTicketsCount intValue];
    int currentCount = [[UserController sharedInstance].currentUser.currentJackpotTicketsCount intValue];
    int weeklyLimit = [FZData sharedInstance].ticketsLimitPerWeek;
    
    if (self.count > availableCounts) {
        
        [self showError:@"You don't have enough Jackpot tickets available." headerTitle:@"OOPS!" buttonTitle:@"GOT IT" image:@"bear-dead" window:YES];
        self.popView.btnCancel.hidden = NO;
        [self.popView.btnCancel setTitle:@"Get more jackpot tickets" forState:UIControlStateNormal];
        
        self.isGetMore = true;
        
    } else if (self.count + currentCount > weeklyLimit){
        
        [self showError:[NSString stringWithFormat:@"You are exceeding %d Jackpot tickets for this draw.", weeklyLimit] headerTitle:@"OOPS!" buttonTitle:@"GOT IT" image:@"bear-dead" window:YES];
        
    } else if ([FZData isCuttingOffLiveDraw]){
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"The cut off time for this draw has been reached. Your Jackpot ticket will be valid only for next week's draw. Do you wish to continue?"];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:14] range: NSMakeRange(92, 17)];
        NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
        paragrapStyle.lineHeightMultiple = 1.3;
        paragrapStyle.alignment = NSTextAlignmentCenter;
        [string addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
        [self showErrorWith:string headerTitle:@"CUT OF TIME" buttonTitle:@"YES, CONTINUE" image:@"bear-baby" window:YES];
        self.popView.btnCancel.hidden = NO;
        [self.popView.btnCancel setTitle:@"No, cancel" forState:UIControlStateNormal];
        
        self.isCuttingOffTime = true;
        
    } else{

        [self goTicketsSetPage];
    }
    
}

- (void)goTicketsSetPage{
    
    JackpotCouponViewController *couponView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotCouponView"];
    couponView.ticketCount = self.count;
    [self.navigationController pushViewController:couponView animated:YES];
    
}

- (void)goJackpotHomePage{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_DISMISS_VIEW object:nil];
    
    FZTabBarViewController *tabBarController = (FZTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [tabBarController setSelectedIndex:kTabBarItemShop];
    UINavigationController *navController = [[tabBarController viewControllers] objectAtIndex:kTabBarItemShop];
    JackpotHomePageViewController *jackpotHomePage = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotHomePageView"];
    jackpotHomePage.hidesBottomBarWhenPushed = YES;
    [navController pushViewController:jackpotHomePage animated:YES];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - FZPopViewDelegate
- (void)okButtonClicked{
    [super okButtonClicked];
    
    if (self.isCuttingOffTime) {
        
        self.isCuttingOffTime = false;
        [self goTicketsSetPage];
    }
    
    self.isGetMore = false;
}

- (void)cancelButtonClicked{
    [super cancelButtonClicked];
    
    if (self.isGetMore) {
        
        self.isGetMore = false;
        [self goJackpotHomePage];

    }
    
    self.isCuttingOffTime = false;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
