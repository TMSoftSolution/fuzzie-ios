//
//  JackpotPaySuccessViewController.m
//  Fuzzie
//
//  Created by mac on 9/18/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotTicketsLockSuccssViewController.h"
#import "FZTabBarViewController.h"
#import "JackpotTicketsViewController.h"
#import "JackpotTicketCollectionViewCell.h"

@interface JackpotTicketsLockSuccssViewController () <UICollectionViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIView *leftTimeView;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UILabel *lbDay;
@property (weak, nonatomic) IBOutlet UILabel *lbHour;
@property (weak, nonatomic) IBOutlet UILabel *lbMin;
@property (weak, nonatomic) IBOutlet UILabel *lbSec;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)switchChanged:(UISwitch*)sender;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation JackpotTicketsLockSuccssViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JACKPOT_RESULT_REFRESH object:nil];
    
    if ([[UserController sharedInstance].currentUser.jackpotDrawNotification boolValue]) {
        [[FZLocalNotificationManager sharedInstance] scheduleLiveDrawNotification];
    }
    
    [[FZLocalNotificationManager sharedInstance] scheduleJackpotRemainderNotification];

    [self initData];
    [self setStyling];
}

- (void)initData{
    
    NSMutableDictionary *ticketsDict = [[NSMutableDictionary alloc] init];
    for (NSString *ticket in self.ticketArray) {
        if ([ticketsDict objectForKey:ticket]) {
            NSMutableArray *tickets = [ticketsDict valueForKey:ticket];
            [tickets addObject:ticket];
        } else{
            NSMutableArray *tickets = [[NSMutableArray alloc] init];
            [tickets addObject:ticket];
            [ticketsDict setObject:tickets forKey:ticket];
        }
    }
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSString *key in [ticketsDict allKeys]) {
        NSArray *array = [ticketsDict objectForKey:key];
        [temp addObject:array];
    }
    
    self.groupedTicketArray = temp;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self endTimer];
}

- (void)setStyling{
    
    self.lbTitle.text = [[NSString stringWithFormat:@"GREATE JOB, %@!", [UserController sharedInstance].currentUser.firstName] uppercaseString];
    
    UINib *cellNib = [UINib nibWithNibName:@"JackpotTicketCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
    
    [CommonUtilities setView:self.leftTimeView withCornerRadius:3.0f];
    [CommonUtilities setView:self.btnDone withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    NSDate *drawDate = [[GlobalConstants standardFormatter] dateFromString:[FZData sharedInstance].jackpotDrawTime];
    if ([FZData isCuttingOffLiveDraw]) {
        drawDate = [[GlobalConstants standardFormatter] dateFromString:[FZData sharedInstance].jackpotNextDrawTime];
    }
   
    [self.switchButton setOn:[[UserController sharedInstance].currentUser.jackpotDrawNotification boolValue]];

}

- (void)startTimer{
    if (!self.timer) {
        self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:1.0f block:^(NSTimer *timer) {
            
            NSDate *drawTime ;
            if ([FZData isCuttingOffLiveDraw]) {
                drawTime = [[GlobalConstants standardFormatter] dateFromString:[FZData sharedInstance].jackpotNextDrawTime];
            } else{
                drawTime = [[GlobalConstants standardFormatter] dateFromString:[FZData sharedInstance].jackpotDrawTime];
            }
            NSDate *now = [NSDate date];
            
            if ([drawTime secondsFrom:now] > 0) {
                int days = (int)[drawTime daysFrom:now];
                int hours = [drawTime hoursFrom:now];
                hours %= 24;
                int minutes = [drawTime minutesFrom:now];
                minutes %= 60;
                int seconds = [drawTime secondsFrom:now];
                seconds %= 60;
                
                self.lbDay.text = [NSString stringWithFormat:@"%02d", days];
                self.lbHour.text = [NSString stringWithFormat:@"%02d", hours];
                self.lbMin.text = [NSString stringWithFormat:@"%02d", minutes];
                self.lbSec.text = [NSString stringWithFormat:@"%02d", seconds];
                
            }
            
        } repeats:YES];
    }
}

- (void)endTimer{
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.groupedTicketArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JackpotTicketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setCell:self.groupedTicketArray[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *tickets = [self.groupedTicketArray objectAtIndex:indexPath.row];
    if (tickets.count > 1) {
        return CGSizeMake(76.0f, 60.0f);
    }
    return CGSizeMake(64.0f, 60.0f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    // Center Items
    CGFloat ticketsWidth = 0.0f;
    for (NSArray *array in self.groupedTicketArray) {
        if (array.count > 1) {
            ticketsWidth += 76.0f;
        } else{
            ticketsWidth += 64.0f;
        }
    }
    CGFloat cellSpacings = 10.0f * (self.groupedTicketArray.count - 1);
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat inset = (screenWidth - 30.0f - ticketsWidth - cellSpacings) / 2.0f;
    inset = (inset <= 0) ? 16 : inset;
    return UIEdgeInsetsMake(0, inset, 0, inset);
}

#pragma mark - IBAction Helper
- (IBAction)doneButtonPressed:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_DISMISS_VIEW object:nil];
    
    BOOL fromTickets = false;
    UIViewController *ticketsView;
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[JackpotTicketsViewController class]]) {
            fromTickets = true;
            ticketsView = viewController;
        }
    }
    
    if (fromTickets) {
        [self.navigationController popToViewController:ticketsView animated:YES];
    } else{
        
        FZTabBarViewController *tabBarController = (FZTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        [tabBarController setSelectedIndex:kTabBarItemWallet];
        UINavigationController *navController = [[tabBarController viewControllers] objectAtIndex:kTabBarItemWallet];
        JackpotTicketsViewController *ticketsView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotTicketsView"];
        ticketsView.hidesBottomBarWhenPushed = YES;
        [navController pushViewController:ticketsView animated:YES];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)switchChanged:(UISwitch *)sender {
    
    [UserController sharedInstance].currentUser.jackpotDrawNotification = @(sender.isOn);

    [UserController setJackpotLiveDrawNotification:sender.isOn withErrorBlock:^(NSError *error) {
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            if (sender.isOn) {
                [_switchButton setOn:NO];
                [UserController sharedInstance].currentUser.jackpotDrawNotification =  @(NO);
            } else {
                [_switchButton setOn:YES];
                [UserController sharedInstance].currentUser.jackpotDrawNotification =  @(YES);
            }

        }
    }];
    
    
    if (sender.isOn) {
        [[FZLocalNotificationManager sharedInstance] scheduleLiveDrawNotification];
    } else{
        [[FZLocalNotificationManager sharedInstance] removePendingLiveDrawNotification:@[NOTIFICATION_ID_JACKPOT_LIVE_DRAW]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
