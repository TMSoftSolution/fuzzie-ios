//
//  JackpotLiveDrawViewController.m
//  Fuzzie
//
//  Created by mac on 9/27/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotLiveDrawViewController.h"
#import "JackpotDrawHistoryTableViewCell.h"
#import "JackpotTicketCollectionViewCell.h"
#import "JackpotLiveDrawWonViewController.h"
#import "JackpotLearnMoreViewController.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"
#import "FLAnimatedImageView.h"
#import "JackpotHomePageViewController.h"
#import "FZTabBarViewController.h"

@interface JackpotLiveDrawViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MDHTMLLabelDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightAnchor;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *myCombinationView;
@property (weak, nonatomic) IBOutlet UIView *emptyCombinationView;
@property (weak, nonatomic) IBOutlet UIView *liveDrawView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *liveDrawViewHeight;
@property (weak, nonatomic) IBOutlet UIView *videoContainerView;
@property (weak, nonatomic) IBOutlet UIView *slotViewContainer;
@property (weak, nonatomic) IBOutlet JTNumberScrollAnimatedView *slotView;
@property (weak, nonatomic) IBOutlet UIView *liveDrawEndView;
@property (weak, nonatomic) IBOutlet UILabel *liveDrawEndTitle;
@property (weak, nonatomic) IBOutlet UILabel *liveDrawEndBody;

@property (weak, nonatomic) IBOutlet UIButton *btnJoin;
@property (weak, nonatomic) IBOutlet UILabel *lbWinningPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbWinningTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbWatchingNumber;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *commencingLoader;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *lbParticipate;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;
- (IBAction)joinButtonPressed:(id)sender;

@property (assign, nonatomic) int estimateLiveDrawViewHeight;
@property (assign, nonatomic) BOOL liveDrawEnd;
@property (assign, nonatomic) BOOL won;

@end

@implementation JackpotLiveDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMyNumbers) name:JACKPOT_RESULT_REFRESHED object:nil];
    
    [self setStyling];
    
    self.results = [FZData sharedInstance].jackpotResult[@"results"];
    [self loadJackpotLiveDrawResult];
    
    [FLAnimatedImage setLogBlock:^(NSString *logString, FLLogLevel logLevel) {
        // Using NSLog
        NSLog(@"%@", logString);
        
        // ...or CocoaLumberjackLogger only logging warnings and errors
        if (logLevel == FLLogLevelError) {
            DDLogError(@"%@", logString);
        } else if (logLevel == FLLogLevelWarn) {
            DDLogWarn(@"%@", logString);
        }
    } logLevel:FLLogLevelWarn];
    self.commencingLoader.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[CommonUtilities getDataForGifImage:@"commencing-draw"]];
    [self.commencingLoader startAnimating];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Turn on remote control event delivery
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Turn off remote control event delivery
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    [self endTimer];

}

- (void)setStyling{
    
    UINib *cellNib = [UINib nibWithNibName:@"JackpotDrawHistoryTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableViewHeightAnchor.constant = 70.0f * self.prizes.count;
    });
    
    UINib *ticketCellNib = [UINib nibWithNibName:@"JackpotTicketCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:ticketCellNib forCellWithReuseIdentifier:@"TicketCell"];
    
    if (self.myTickets && self.myTickets.count > 0) {
        self.emptyCombinationView.hidden = YES;
        self.myCombinationView.hidden = NO;
    } else {
        self.emptyCombinationView.hidden = NO;
        self.myCombinationView.hidden = YES;
    }

    [CommonUtilities setView:self.btnJoin withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:2.0f];

    [self updateLiveDrawEnd];
    
    self.lbParticipate.htmlText = @"You did not participate in this draw. <a href='jackpot'>Get your tickets for the next draw!</a>";
    self.lbParticipate.delegate = self;
    self.lbParticipate.linkAttributes = @{
                                   NSForegroundColorAttributeName: [UIColor colorWithHexString:HEX_COLOR_RED],
                                   NSFontAttributeName: [UIFont fontWithName:FONT_NAME_LATO_BLACK size:12.0f],
                                   NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
    self.lbParticipate.lineHeightMultiple = 1.3f;
    
    self.slotView.textColor = [UIColor whiteColor];
    self.slotView.font = [UIFont fontWithName:FONT_NAME_BLACK size:38];

}

- (void)updateLiveDrawEnd{
    if (self.liveDrawEnd) {
        self.estimateLiveDrawViewHeight = 172.0f;
        if ([FZData getWinningResult]) {
            self.won = true;

            int totalWinningPrize = 0;
            for (NSDictionary *prize in self.liveDrawResult[@"prizes"]) {
                for (NSArray *myTicket in self.myTickets) {
                    NSString *fourD = [myTicket firstObject];
                    if ([fourD isEqualToString:prize[@"four_d"]]) {
                        totalWinningPrize = totalWinningPrize + [prize[@"amount"] intValue] * (int)myTicket.count;
                        break;
                    }
                }
                
            }
            self.liveDrawEndTitle.text = [NSString stringWithFormat:@"YOU'VE WON S$%d!", totalWinningPrize];
            
            NSString *string = [NSString stringWithFormat:@"Congrats %@! Write to us at jackpot@fuzzie.com.sg with your bank details. We will transfer the prize money directly to your bank account within 30 days from your email.", [UserController sharedInstance].currentUser.firstName];
            NSString *emailString = @"jackpot@fuzzie.com.sg";
            NSString *validString = @"30 days";
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:12.0f] range:[string rangeOfString:emailString]];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:12.0f] range:[string rangeOfString:validString]];
            NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
            paragrapStyle.alignment = NSTextAlignmentCenter;
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
            
            self.liveDrawEndBody.attributedText = attributedString;
            [self.btnJoin setTitle:@"SEND MY BANK DETAILS" forState:UIControlStateNormal];
            
            [FZData saveWinningResult:nil];
            
        } else{
            self.liveDrawEndTitle.text = @"THANKS FOR WATCHING!";
            self.liveDrawEndBody.text = @"The draw is now over. Get your Jackpot tickets for the next draw and we’ll see you soon!";
            [self.btnJoin setTitle:@"JOIN THE NEXT DRAW" forState:UIControlStateNormal];
        }
        self.liveDrawView.hidden = YES;
        self.liveDrawEndView.hidden = NO;
//        if (_player) {
//            [self.player pauseVideo];
//            [self setYouTubeStreaming];
//        }
        
    } else {
        CGRect screenSize = [UIScreen mainScreen].bounds;
        CGFloat width = screenSize.size.width - 30;
        self.estimateLiveDrawViewHeight = width * 12 / 29 + 160;
        self.liveDrawView.hidden = NO;
        self.liveDrawEndView.hidden = YES;
    }
    
    self.liveDrawViewHeight.constant = self.estimateLiveDrawViewHeight;
}


- (void) showMyNumbers{
    self.results = [FZData sharedInstance].jackpotResult[@"results"];
    if (!self.myTickets && self.liveDrawResult) {
        int drawId = [self.liveDrawResult[@"id"] intValue];
        for (NSDictionary *result in self.results) {
            if ([result[@"id"] intValue] == drawId) {
                self.myTickets = result[@"my_combinations"];
            }
        }
    }
    
    if (self.myTickets && self.myTickets.count > 0) {
        self.emptyCombinationView.hidden = YES;
        self.myCombinationView.hidden = NO;
    } else {
        self.emptyCombinationView.hidden = NO;
        self.myCombinationView.hidden = YES;
    }
    [self.collectionView reloadData];
}

- (void)loadJackpotLiveDrawResult{
    
    [JackpotController getJackpotLiveDrawResult:^(NSDictionary *dictionary, NSError *error) {
        [self hideLoader];
        
        if (error && error.code == 417) {
            [AppDelegate logOut];
        }
        
        if (dictionary) {
            self.liveDrawResult = dictionary;
            [self updateLiveDrawResult];
        }
    }];
}

- (void)updateLiveDrawResult{
    
    if (self.liveDrawResult) {
        
        self.prizes = self.liveDrawResult[@"prizes"];
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (NSDictionary *prize in self.prizes) {
            if (prize[@"four_d"] && ![prize[@"four_d"] isKindOfClass:[NSNull class]]) {
                [temp addObject:prize[@"four_d"]];
            } else {
                [temp addObject:@""];
            }
        }
        self.prizesTickets = temp;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableViewHeightAnchor.constant = 70.0f * self.prizes.count;
        });
        [self.tableView reloadData];
        
        [self showMyNumbers];
        
        self.currentWinning = self.liveDrawResult[@"current_winning"];
        if (self.currentWinning && ![self.currentWinning isKindOfClass:[NSNull class]]) {
            if (!self.latestWinning) {
                self.latestWinning = self.currentWinning;
                [self showLiveDrawWinning];
            } else {
                if (![self.latestWinning[@"identifier"] isEqualToString:self.currentWinning[@"identifier"]]) {
                    self.latestWinning = self.currentWinning;
                    [self showLiveDrawWinning];
                } else {
                    if (![self.currentWinning[@"four_d"] isKindOfClass:[NSNull class]]) {
                        if (![self.latestWinning[@"four_d"] isEqualToString:self.currentWinning[@"four_d"]]) {
                            self.latestWinning = self.currentWinning;
                            [self showLiveDrawWinning];
                        }
                    }
                    
                }
            }
            
            if (!self.isNext) {
                self.isNext = true;
                self.commencingLoader.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[CommonUtilities getDataForGifImage:@"commencing-next"]];
            }

        } else{
            if (!self.isFirst) {
                self.isFirst = true;
                self.commencingLoader.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[CommonUtilities getDataForGifImage:@"commencing-draw"]];
            }

        }
        
        self.nextPrize = self.liveDrawResult[@"next_prize"];
        if (self.nextPrize && ![self.nextPrize isKindOfClass:[NSNull class]]) {
            if (!self.prevPrize) {
                if (self.currentWinning && ![self.currentWinning isKindOfClass:[NSNull class]]) {
                    self.prevPrize = self.currentWinning;
                } else{
                    self.prevPrize = self.nextPrize;
                }

                [self keepPrevPrize];
                NSTimer *timer;
                timer = [NSTimer bk_scheduledTimerWithTimeInterval:5.0f block:^(NSTimer *timer) {
                    self.prevPrize = self.nextPrize;
                    [self showNextPrize];
                    [timer invalidate];
                    timer = nil;
                    
                } repeats:NO];
            } else{
                if (![self.nextPrize[@"identifier"] isEqualToString:self.prevPrize[@"identifier"]]) {
                    [self keepPrevPrize];
                    self.prevPrize = self.nextPrize;
                    NSTimer *timer;
                    timer = [NSTimer bk_scheduledTimerWithTimeInterval:5.0f block:^(NSTimer *timer) {
                        
                        [self showNextPrize];
                        [timer invalidate];
                        timer = nil;
                        
                    } repeats:NO];
                }
            }
        } else{
            self.commencingLoader.hidden = YES;
            self.slotView.hidden = NO;
        }

        
        NSNumber *watchNumber = self.liveDrawResult[@"watchers_count"];
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        self.lbWatchingNumber.text = [NSString stringWithFormat:@"%@ watching now", [formatter stringFromNumber:watchNumber]];
        
        if ([self.liveDrawResult[@"state"] isEqualToString:@"ended"]) {
            [self endDraw];
        }
        
//        if (![FZData sharedInstance].liveDrawStreamingUrl || [[FZData sharedInstance].liveDrawStreamingUrl isEqualToString:@""]) {
//            [FZData sharedInstance].liveDrawStreamingUrl = self.liveDrawResult[@"streaming_url"];
//            [self setYouTubeStreaming];
//        }
        
    }
}

- (void) showNextPrize{
    self.slotView.hidden = YES;
    self.commencingLoader.hidden = NO;
    if (self.nextPrize && ![self.nextPrize isKindOfClass:[NSNull class]]) {
        if (![self.nextPrize[@"name"] isEqualToString:@""]) {
            self.lbWinningTitle.text = self.nextPrize[@"name"];
        }
        if ([self.nextPrize[@"amount"] intValue] != 0) {
            self.lbWinningPrice.text = [NSString stringWithFormat:@"S$%d", [self.nextPrize[@"amount"] intValue]] ;
            
        }
    }
}

- (void) keepPrevPrize{
    self.slotView.hidden = NO;
    if (self.currentWinning && ![self.currentWinning isKindOfClass:[NSNull class]]) {
        self.commencingLoader.hidden = YES;
    } else{
        self.commencingLoader.hidden = NO;
    }

    if (self.prevPrize && ![self.prevPrize isKindOfClass:[NSNull class]]) {
        if (![self.prevPrize[@"name"] isEqualToString:@""]) {
            self.lbWinningTitle.text = self.prevPrize[@"name"];
        }
        if ([self.prevPrize[@"amount"] intValue] != 0) {
            self.lbWinningPrice.text = [NSString stringWithFormat:@"S$%d", [self.prevPrize[@"amount"] intValue]] ;
            
        }
    }
}

- (void)showLiveDrawWinning{
    if (self.latestWinning) {
        
        if (![self.latestWinning[@"four_d"] isKindOfClass:[NSNull class]] && ![self.latestWinning[@"four_d"] isEqualToString:@""]) {
            NSString *fourD = self.latestWinning[@"four_d"];
            [self.slotView setValue:fourD];
            [self.slotView startAnimation];

            for (NSArray *tickets in self.myTickets) {
                if ([[tickets firstObject] isEqualToString:self.latestWinning[@"four_d"]]) {
                    if (![FZData alreadyShownWinningPage:self.latestWinning]) {
                        self.won = true;
                        [FZData saveWinningResult:self.latestWinning];
                        int winningAmount = [self.latestWinning[@"amount"] intValue] * (int)tickets.count;
                        [self showWinningPage:winningAmount];
                        [[NSNotificationCenter defaultCenter] postNotificationName:JACKPOT_LIVE_DRAW_WON object:nil];
                    }
                }
            }
        }

    }
}

- (void) endDraw{
    
    [self endTimer];
    self.liveDrawEnd = YES;

    NSTimer *timer;
    timer = [NSTimer bk_scheduledTimerWithTimeInterval:2.0f block:^(NSTimer *timer) {
        
        [self updateLiveDrawEnd];
        [[NSNotificationCenter defaultCenter] postNotificationName:JACKPOT_LIVE_DRAW_END object:nil];
        
        [timer invalidate];
        timer = nil;
        
    } repeats:NO];
}


- (void)showWinningPage:(int) winningAmount{

    NSTimer *timer;
    timer = [NSTimer bk_scheduledTimerWithTimeInterval:2.0f block:^(NSTimer *timer) {
        
        JackpotLiveDrawWonViewController *wonView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotLiveDrawWonView"];
        wonView.amount = winningAmount;
        [self presentViewController:wonView animated:YES completion:nil];
        
        [timer invalidate];
        timer = nil;
        
    } repeats:NO];
}

- (void)startTimer{
    if (!self.timer) {
        self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:5.0f block:^(NSTimer *timer) {
            
            [self loadJackpotLiveDrawResult];
            
        } repeats:YES];
    }
}

- (void)endTimer{
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.prizes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    JackpotDrawHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    BOOL matched = false;
    for (NSArray *ticket in self.myTickets) {
        NSString *fourD = [self.prizes objectAtIndex:indexPath.row][@"four_d"];
        if (fourD) {
            if ([[ticket firstObject] isEqualToString:fourD]) {
                matched = true;
                break;
            }
        }
       
    }
    [cell setCell:[self.prizes objectAtIndex:indexPath.row] position:(int)indexPath.row matched:matched];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return 70.0f;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.myTickets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JackpotTicketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TicketCell" forIndexPath:indexPath];
    NSArray *tickets = [self.myTickets objectAtIndex:indexPath.row];
    NSString *ticket = [tickets firstObject];
    [cell setCell:ticket count:tickets.count matched:[self.prizesTickets containsObject:ticket]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(77.0f, 60.0f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 5, 0, 15);
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MDHTMLLabelDelegate
- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL{
 
    [self goJackpotHomePage];
}

- (void) goJackpotHomePage{
    FZTabBarViewController *rootController = (FZTabBarViewController*) [UIApplication sharedApplication].keyWindow.rootViewController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [rootController setSelectedIndex:kTabBarItemShop];
    UINavigationController *navController1 = [[rootController viewControllers] objectAtIndex:kTabBarItemShop];
    JackpotHomePageViewController *jackpotHomePage = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotHomePageView"];
    jackpotHomePage.hidesBottomBarWhenPushed = YES;
    [navController1 pushViewController:jackpotHomePage animated:YES];
}

- (IBAction)helpButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"Need help?"];
    
    [actionSheet bk_addButtonWithTitle:@"Read our FAQ" handler:^{
       
        JackpotLearnMoreViewController *learnView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotLearnMoreView"];
        [self.navigationController pushViewController:learnView animated:YES];
    }];
    
    if ([MFMailComposeViewController canSendMail]) {
        
        [actionSheet bk_addButtonWithTitle:@"Email us" handler:^{
            
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            [mailer setSubject: @"Fuzzie Support"];
            [mailer setToRecipients:@[@"support@fuzzie.com.sg"]];
            mailer.navigationBar.tintColor = [UIColor whiteColor];
            mailer.bk_completionBlock = ^( MFMailComposeViewController *mailer, MFMailComposeResult result, NSError* error) {
 
                [mailer dismissViewControllerAnimated:YES completion:nil];
            };
            
            [self presentViewController:mailer animated:YES completion:nil];
            
        }];
    }
    
    [actionSheet bk_addButtonWithTitle:@"Facebook us" handler:^{
        NSURL *facebookURL = [NSURL URLWithString:@"http://m.me/fuzzieapp"];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        }
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"Cancel" handler:nil];
    [actionSheet showInView:self.view];
}

- (IBAction)joinButtonPressed:(id)sender {
    if (self.won) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            [mailer setSubject: @"Claiming The Fuzzie Jackpot Prize"];
            [mailer setToRecipients:@[@"jackpot@fuzzie.com.sg"]];
            FZUser *user = [UserController sharedInstance].currentUser;
            NSString *body = [NSString stringWithFormat:@"Name: %@ %@\nMobile: %@\nBank Name: \nAccount number: ", user.firstName, user.lastName, user.phone];
            [mailer setMessageBody:body isHTML:NO];
            mailer.navigationBar.tintColor = [UIColor whiteColor];
            mailer.bk_completionBlock = ^( MFMailComposeViewController *mailer, MFMailComposeResult result, NSError* error) {
                [mailer dismissViewControllerAnimated:YES completion:nil];
            };
            
            [self presentViewController:mailer animated:YES completion:nil];
        } else{
            
            NSString *string = @"You need an email client to continue. Or write to us directly at jackpot@fuzzie.com.sg.";
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:13] range: [string rangeOfString:@"jackpot@fuzzie.com.sg"]];
            [self showErrorWith:attributedString headerTitle:@"OOPS!" buttonTitle:@"GOT IT" image:@"bear-dead" window:NO];
        }
    } else{
        [self goJackpotHomePage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JACKPOT_RESULT_REFRESHED object:nil];
}

@end
