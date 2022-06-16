//
//  JackpotLiveNotiViewController.m
//  Fuzzie
//
//  Created by Joma on 10/24/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotLiveNotiViewController.h"
#import "JackpotLiveDrawViewController.h"
#import "FZTabBarViewController.h"

@interface JackpotLiveNotiViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnJoin;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

- (IBAction)joinButtonPressed:(id)sender;
- (IBAction)closeButtonPressed:(id)sender;

@end

@implementation JackpotLiveNotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    [CommonUtilities setView:self.btnJoin withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.btnClose withBackground:[UIColor clearColor] withRadius:4.0f withBorderColor:[UIColor whiteColor] withBorderWidth:1.0f];
}

#pragma mark - IBAction Helper
- (IBAction)joinButtonPressed:(id)sender {
    FZTabBarViewController *rootController = (FZTabBarViewController*) [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UINavigationController *navController = [[rootController viewControllers] objectAtIndex:[FZData sharedInstance].selectedTab];
    [navController popToRootViewControllerAnimated:NO];
    
    [rootController setSelectedIndex:kTabBarItemShop];
    UINavigationController *navController1 = [[rootController viewControllers] objectAtIndex:kTabBarItemShop];
    [self dismissViewControllerAnimated:NO completion:^{
        JackpotLiveDrawViewController *liveView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotLiveDrawView"];
        liveView.hidesBottomBarWhenPushed = YES;
        [navController1 pushViewController:liveView animated:YES];
    }];
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
