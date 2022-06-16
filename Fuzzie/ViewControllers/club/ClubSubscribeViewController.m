//
//  ClubSubscribeViewController.m
//  Fuzzie
//
//  Created by joma on 6/18/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubSubscribeViewController.h"
#import "JackpotLearnMoreViewController.h"

@interface ClubSubscribeViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *subscribeView1;
@property (weak, nonatomic) IBOutlet UIView *subscribeView2;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbValid;

- (IBAction)subscribeButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)faqButtonPressed:(id)sender;
- (IBAction)termsButtonPressed:(id)sender;


@end

@implementation ClubSubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}


- (void)setStyling{
    
    self.scrollView.delegate = self;

    [CommonUtilities setView:self.lbPrice withCornerRadius:3.0f];
    
    self.subscribeView1.layer.cornerRadius = 8.0f;
    self.subscribeView1.clipsToBounds = YES;
    self.subscribeView1.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.subscribeView1.bounds cornerRadius:self.subscribeView1.layer.cornerRadius].CGPath;
    self.subscribeView1.layer.shadowColor = [UIColor colorWithHexString:@"#000000" alpha:0.1f].CGColor;
    self.subscribeView1.layer.shadowOpacity = 1.0f;
    self.subscribeView1.layer.shadowOffset = CGSizeMake(0, 2);
    self.subscribeView1.layer.shadowRadius = 7;
    self.subscribeView1.layer.masksToBounds = NO;
    
    [CommonUtilities setView:self.subscribeView2 withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    self.lbPrice.text = [NSString stringWithFormat:@"     S$%@/year     ", [UserController sharedInstance].currentUser.clubMemberPrice];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *date = [cal dateByAddingUnit:NSCalendarUnitYear value:1 toDate:[NSDate date] options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMM YY"];
    self.lbValid.text = [NSString stringWithFormat:@"Valid from today till %@", [dateFormatter stringFromDate:date]];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat heightSlider = screenWidth * 27 / 32 - 64;
    
    int realPosition = scrollView.contentOffset.y+20;
    if (realPosition >= heightSlider) {
        float ratio = realPosition-heightSlider;
        double coef = MIN(1,ratio/32);
        self.backgroundView.alpha = (float)coef;
        self.subscribeView1.alpha = 0;
    } else {
        self.backgroundView.alpha = 0;
        self.subscribeView1.alpha = 1;
    }
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)faqButtonPressed:(id)sender {
    
    JackpotLearnMoreViewController *learnView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotLearnMoreView"];
    learnView.isClubFaq = YES;
    [self.navigationController pushViewController:learnView animated:YES];
}

- (IBAction)termsButtonPressed:(id)sender {
    
    JackpotLearnMoreViewController *learnView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotLearnMoreView"];
    learnView.isClubTerms = YES;
    [self.navigationController pushViewController:learnView animated:YES];
}

- (IBAction)subscribeButtonPressed:(id)sender {
    
    UIViewController *viewController = [[GlobalConstants paymentStoryboard] instantiateViewControllerWithIdentifier:@"ClubSubscribePayView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
