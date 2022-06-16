//
//  JackpotTicketsViewController.m
//  Fuzzie
//
//  Created by mac on 9/24/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotTicketsViewController.h"
#import "JackpotTicketsTableViewCell.h"
#import "JackpotDrawHistoryViewController.h"
#import "JackpotHomePageViewController.h"
#import "JackpotLiveDrawViewController.h"
#import "JackpotTicketUseTableViewCell.h"
#import "JackpotTicketsUseViewController.h"
#import "JackpotLearnMoreViewController.h"
#import "JackpotTicketsPastTableViewCell.h"

typedef enum : NSUInteger {
    kSectionUse,
    kSectionTickets,
    kSectionPastResult,
    kSectionCount
} kSection;

@interface JackpotTicketsViewController () <UITableViewDataSource, UITableViewDelegate, JackpotTicketsTableViewCellDelegate, JackpotTicketUseTableViewCellDelegate, JackpotTicketsPastTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;

@end

@implementation JackpotTicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jackpotResultRefreshed) name:JACKPOT_RESULT_REFRESHED object:nil];
    
    [self setStyling];
    [self resetUnopenedTicketsCount];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if ([FZData sharedInstance].jackpotResult) {
        self.jackpotResults = [FZData sharedInstance].jackpotResult[@"results"];
        [self fetchDrawDict];
    } else{
        [self loadJackpotResult:true];
    }
    
    [self.tableView reloadData];
}

- (void)fetchDrawDict{
    
    for (NSDictionary *dict in self.jackpotResults) {
        
        if([dict[@"id"] isEqual:[FZData sharedInstance].jackpotDrawId]){
            self.drawDict = dict;
            break;
        }
    }
}

- (void)jackpotResultRefreshed{
    self.jackpotResults = [FZData sharedInstance].jackpotResult[@"results"];
    [self fetchDrawDict];
    [self.tableView reloadData];
}

- (void)setStyling{
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    
    UINib *cellNib = [UINib nibWithNibName:@"JackpotTicketsTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    UINib *useCell = [UINib nibWithNibName:@"JackpotTicketUseTableViewCell" bundle:nil];
    [self.tableView registerNib:useCell forCellReuseIdentifier:@"UseCell"];
    
    UINib *pastCell = [UINib nibWithNibName:@"JackpotTicketsPastTableViewCell" bundle:nil];
    [self.tableView registerNib:pastCell forCellReuseIdentifier:@"PastCell"];

}

- (void)resetUnopenedTicketsCount{
    
    if ([UserController sharedInstance].currentUser.unOpenedTicketCount.intValue > 0) {
        
        [UserController resetUnopenedTicketCount];
        [AppDelegate updateWalletBadge];
        
        [GiftController resetUnopenedTicketsCount:nil];
    }

}

- (void)loadJackpotResult:(BOOL)refresh{
    
    if (refresh) {
        [self showLoader];
    }

    [JackpotController getJackpotResult:^(NSDictionary *dictionary, NSError *error) {
        
        [self hideLoader];
        
        if (error && error.code == 417) {
            [AppDelegate logOut];
        }
        
        if (dictionary) {
            [FZData sharedInstance].jackpotResult = dictionary;
            self.jackpotResults = dictionary[@"results"];
            [self fetchDrawDict];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - JackpotTicketsTableViewCellDelegate
- (void)liveButtonPressed{
    JackpotLiveDrawViewController *liveView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotLiveDrawView"];
    [self.navigationController pushViewController:liveView animated:YES];
}

#pragma mark - JackpotTicketUseTableViewCellDelegate
- (void)useButtonPressed{
    
    JackpotTicketsUseViewController *useView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotTicketsUseView"];
    [self.navigationController pushViewController:useView animated:YES];
}

- (void)getJackpotButtonPressed{
    JackpotHomePageViewController *jackpotHomePage = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotHomePageView"];
    [self.navigationController pushViewController:jackpotHomePage animated:YES];
}
#pragma mark - JackpotTicketsPastTableViewCellDelegate
- (void)viewPastResultPressed{

    JackpotDrawHistoryViewController *historyView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotDrawHistoryView"];
    [self.navigationController pushViewController:historyView animated:YES];

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == kSectionUse || section == kSectionTickets || section == kSectionPastResult) {
        
        return 1;
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kSectionUse) {
        
        JackpotTicketUseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UseCell"];
        cell.delegate = self;
        [cell initCell];
        return cell;
        
    } else if (indexPath.section == kSectionTickets){
        
        JackpotTicketsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        [cell setCell:self.drawDict];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == kSectionPastResult){
        
        JackpotTicketsPastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PastCell"];
        cell.delegate = self;
        return cell;
    }
    
    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kSectionTickets){

        return [JackpotTicketsTableViewCell estimateHeight:self.drawDict];
        
    }
 
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10.0f)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;

}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JACKPOT_RESULT_REFRESHED object:nil];
}

@end
