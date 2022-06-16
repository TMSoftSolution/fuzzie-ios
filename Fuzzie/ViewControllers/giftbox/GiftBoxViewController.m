//
//  GiftBoxViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 19/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "GiftBoxViewController.h"
#import "LoadingTableViewCell.h"
#import "FZTabBarViewController.h"
#import "GiftBoxTableViewCell.h"
#import "GiftCardViewController.h"
#import "GiftPackageViewController.h"
#import "SentCardViewController.h"
#import "SentPackageViewController.h"
#import "GiftBoxPowerUpCardTableViewCell.h"
#import "PowerUpGiftViewController.h"

typedef enum : NSUInteger {
    kGiftBoxActive,
    kGiftBoxUsed,
    kGiftBoxSent
} kGiftBox;

@interface GiftBoxViewController () <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate, GiftBoxTableViewCellDelegate, GiftBoxPowerUpCardTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *giftArray;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *segmentButtons;

@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *emptyView;
@property (assign, nonatomic) kGiftBox currentGiftBoxSegment;

@property (assign, nonatomic) BOOL loaderShowing;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)segmentButtonPressed:(id)sender;

@property (strong, nonatomic) UIView *footerView;

@property (assign, nonatomic) BOOL loading;
@property (assign, nonatomic) BOOL isLastActive;
@property (assign, nonatomic) BOOL isLastUsed;
@property (assign, nonatomic) BOOL isLastSent;

@end

@implementation GiftBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setStyling];
    
    [self loadActiveGiftBox];
    [self loadUsedGiftBox];
    [self loadSentGiftBox];

    if (self.fromDelivery) {
        [self segmentButtonPressed:self.segmentButtons[2]];
    } else{
        [self segmentButtonPressed:self.segmentButtons[0]];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadActiveGiftBox) name:ACTIVE_GIFTBOX_REFRESHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUsedGiftBox) name:USED_GIFTBOX_REFRESHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSentGiftBox) name:SENT_GIFTBOX_REFRESHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(giftMarkAsUnredeemed) name:GIFT_MARK_AS_UNREDEEMED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(giftRedeeded) name:GIFT_REDEEMED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSentGiftBox) name:SENT_GIFT_UPDATED object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACTIVE_GIFTBOX_REFRESHED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USED_GIFTBOX_REFRESHED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SENT_GIFTBOX_REFRESHED object:nil];
}

#pragma mark - Button Actions

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)segmentButtonPressed:(id)sender {
    
    UIButton *activeButton = (UIButton *)sender;
    self.currentGiftBoxSegment = activeButton.tag;
    
    for (UIButton *button in self.segmentButtons) {
        if (button == activeButton) {
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[UIColor colorWithHexString:@"#FA3E3F"] forState:UIControlStateNormal];
            button.layer.borderWidth = 0.5f;
            button.layer.borderColor = [UIColor clearColor].CGColor;
        } else {
            button.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.05f];
            [button setTitleColor:[UIColor colorWithHexString:@"#B32C2C"] forState:UIControlStateNormal];
            button.layer.borderWidth = 0.5f;
            button.layer.borderColor = [UIColor colorWithWhite:0.0f alpha:0.2f].CGColor;
        }
    }
    
    switch (self.currentGiftBoxSegment) {
        case kGiftBoxActive:
            self.giftArray = [FZData sharedInstance].activeGiftBox;
            break;
            
        case kGiftBoxUsed:
            self.giftArray = [FZData sharedInstance].usedGiftBox;
            break;
            
        case kGiftBoxSent:
            self.giftArray = [FZData sharedInstance].sentGiftBox;
            break;
            
        default:
            break;
    }
    
    if ((self.giftArray && self.giftArray.count == 0) || !self.giftArray) {
        self.emptyView.hidden = NO;
        self.tableView.hidden = YES;
    } else {
        self.emptyView.hidden = YES;
        self.tableView.hidden = NO;
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.giftArray) {
        return 1;
    } else {
        return self.giftArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *giftDict = self.giftArray[indexPath.row];
    
    if (giftDict[@"type"] && [giftDict[@"type"] isKindOfClass:[NSString class]] && [giftDict[@"type"] isEqualToString:@"PowerUpCodeGift"]) {
    
        GiftBoxPowerUpCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PowerUpCardCell"];
        [cell setCell:giftDict];
        cell.delegate = self;
        return cell;
        
    } else {
        
        GiftBoxTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GiftBoxTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setCell:giftDict];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.giftArray || self.giftArray.count == 0) {
        return 0.0f;
    } else {
        NSDictionary *dict = [self.giftArray objectAtIndex:indexPath.row];
        if (dict[@"gifted"] && ![dict[@"gifted"] isKindOfClass:[NSNull class]] && [dict[@"gifted"] boolValue]) {
            return 150.0f;
        } else{
            return 120.0f;
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 40.0)];
    
    UIActivityIndicatorView * actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    actInd.tag = 10;
    
    actInd.frame = CGRectMake(tableView.frame.size.width / 2 - 10, 5.0, 20.0, 20.0);
    
    actInd.hidesWhenStopped = YES;
    
    [self.footerView addSubview:actInd];
    
    actInd = nil;
    
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.giftArray.count == 0) {
        return 0.0f;
    }
    return 42.0f;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height - 20)) {

        if (!self.loaderShowing && !self.loading && !scrollView.dragging && !scrollView.decelerating) {

            if (self.currentGiftBoxSegment == kGiftBoxActive && !self.isLastActive) {

                self.loading = YES;
                [(UIActivityIndicatorView *)[self.footerView viewWithTag:10] startAnimating];
                [self loadNextActiveGift];

            } else if(self.currentGiftBoxSegment == kGiftBoxUsed && !self.isLastUsed){

                self.loading = YES;
                [(UIActivityIndicatorView *)[self.footerView viewWithTag:10] startAnimating];
                [self loadNextUsedGift];

            } else if(self.currentGiftBoxSegment == kGiftBoxSent && !self.isLastSent){

                self.loading = YES;
                [(UIActivityIndicatorView *)[self.footerView viewWithTag:10] startAnimating];
                [self loadNextSentGift];
            }
        }
    }
}

#pragma mark - GiftBoxTableViewCellDelegate
- (void)cellTapped:(NSDictionary *)giftDict isSent:(BOOL)isSent{
    
    NSString *giftId = giftDict[@"id"];
    
    if (isSent) {
        if (giftDict[@"gift_card"] && ![giftDict[@"gift_card"] isKindOfClass:[NSNull class]]) {
            
            [self performSegueWithIdentifier:@"pushToSentCard" sender:giftDict];
           
        }
        
        if (giftDict[@"service"] && ![giftDict[@"service"] isKindOfClass:[NSNull class]]) {
            
            [self performSegueWithIdentifier:@"pushToSentPackagee" sender:giftDict];
            
        }
        
    } else{
    
        if (self.currentGiftBoxSegment == kGiftBoxActive && giftDict[@"opened"] && ![giftDict[@"opened"] isKindOfClass:[NSNull class]] && ![giftDict[@"opened"] boolValue]){
            
            [AppDelegate updateWalletBadge];
          
            [GiftController markAsOpenedReceivedGift:giftId withCompletion:^(NSDictionary *dictionary, NSError *error) {
                
                if (dictionary) {
                    
                    if (dictionary[@"gift"]){
                        
                        [FZData replaceActiveGift:dictionary[@"gift"]];
                        
                    } else if (dictionary[@"jackpot_coupon"]){
                        
                        [FZData replaceActiveGift:dictionary[@"jackpot_coupon"]];

                    }
                }
            }];
        }
        
        if (giftDict[@"type"] && [giftDict[@"type"] isEqualToString:@"PowerUpCodeGift"]) {
            
            PowerUpGiftViewController *powerUpGiftView = [[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"PowerUpGiftView"];
            powerUpGiftView.giftDict = giftDict;
            [self.navigationController pushViewController:powerUpGiftView animated:YES];
            
            
        } else {
            
            if (giftDict[@"gift_card"] && ![giftDict[@"gift_card"] isKindOfClass:[NSNull class]]) {
                
                [self performSegueWithIdentifier:@"pushToGiftCard" sender:giftDict];
                
            } else if(giftDict[@"service"] && ![giftDict[@"service"] isKindOfClass:[NSNull class]]) {
                
                [self performSegueWithIdentifier:@"pushToGiftPackage" sender:giftDict];
                
            }
        }

    }
}

#pragma mark - GiftBoxPowerUpCardTableViewCellDelegate
- (void)powerUpCardCellTapped:(NSDictionary *)giftDict{
    
    [self cellTapped:giftDict isSent:false];
}

#pragma mark - Helper Functions

- (void)loadActiveGiftBox{
    
    [(UIActivityIndicatorView *)[self.footerView viewWithTag:10] stopAnimating];
 
    if ([FZData sharedInstance].activeGiftBox) {
    
        [self setUI];
        
    } else {
        
        [self loadFirstActiveGift];
    }
}


- (void)loadFirstActiveGift{

    if (!self.loaderShowing) {
         [self showLoader];
         self.loaderShowing = YES;
    }

    [GiftController getActiveGiftBox:1 withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:YES with:^(NSArray *array, NSError *error) {
       
        [self.refreshControl endRefreshing];
        if (self.loaderShowing) {
            [self hideLoader];
            self.loaderShowing = NO;
        }
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            
            [self showErrorAlertTitle:@"Opps!" message:[error localizedDescription] buttonTitle:@"OK"];
  
        }
        
        if (array) {
            
            self.isLastActive = array.count % GIFT_BOX_PAGINGATION_COUNT != 0 || array.count == 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
        }
        
    }];

}

- (void)loadNextActiveGift{
    
    int start = (int)self.giftArray.count + 1;
    
    [GiftController getActiveGiftBox:start withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:NO with:^(NSArray *array, NSError *error) {
        
        self.loading = NO;
        [(UIActivityIndicatorView *)[self.footerView viewWithTag:10] stopAnimating];
        
        if (error) {

            [self showErrorAlertTitle:@"Opps!" message:[error localizedDescription] buttonTitle:@"OK"];
            
        }
        
        if (array) {
            
            self.isLastActive = array.count % GIFT_BOX_PAGINGATION_COUNT != 0 || array.count == 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
        }
    }];
}

- (void)loadUsedGiftBox{
    
    [(UIActivityIndicatorView *)[self.footerView viewWithTag:10] stopAnimating];

    if ([FZData sharedInstance].usedGiftBox) {
    
        [self setUI];
        
    } else {
        
        [self loadFirstUsedGift];
    }
    
}


- (void)loadFirstUsedGift{
    
    if (!self.loaderShowing) {
         [self showLoader];
         self.loaderShowing = YES;
    }
    
     [GiftController getUsedGiftBox:1 withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:YES with:^(NSArray *array, NSError *error) {
        
        [self.refreshControl endRefreshing];
        if (self.loaderShowing) {
            [self hideLoader];
            self.loaderShowing = NO;
        }
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            [self showErrorAlertTitle:@"Oops" message:[error localizedDescription] buttonTitle:@"OK"];
            
        }
        
         if (array) {
             
             self.isLastUsed = array.count % GIFT_BOX_PAGINGATION_COUNT != 0 || array.count == 0;
             
             [[NSNotificationCenter defaultCenter] postNotificationName:USED_GIFTBOX_REFRESHED object:nil];
         }

    }];

}

- (void)loadNextUsedGift{
    
     int start = (int)self.giftArray.count + 1;
    
    [GiftController getUsedGiftBox:start withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:NO with:^(NSArray *array, NSError *error) {
        
        self.loading = NO;
        [(UIActivityIndicatorView *)[self.footerView viewWithTag:10] stopAnimating];
        
        if (error) {
            
            [self showErrorAlertTitle:@"Opps!" message:[error localizedDescription] buttonTitle:@"OK"];
            
        }
        
        if (array) {
            
            self.isLastUsed = array.count % GIFT_BOX_PAGINGATION_COUNT != 0 || array.count == 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:USED_GIFTBOX_REFRESHED object:nil];
        }
    }];
}

- (void)loadSentGiftBox{
    
    [(UIActivityIndicatorView *)[self.footerView viewWithTag:10] stopAnimating];
    
    if ([FZData sharedInstance].sentGiftBox) {
       
        [self setUI];
        
    } else {
        
        [self loadFirstSentGift];
    }
    
}

- (void)loadFirstSentGift{
    
    if (!self.loaderShowing) {
        [self showLoader];
        self.loaderShowing = YES;
    }

    [GiftController getSentGiftBox:1 withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:YES with:^(NSArray *array, NSError *error) {
        
        [self.refreshControl endRefreshing];
        if (self.loaderShowing) {
            [self hideLoader];
            self.loaderShowing = NO;
        }
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            [self showErrorAlertTitle:@"Oops" message:[error localizedDescription] buttonTitle:@"OK"];
            
        }
        
        if (array) {
            
            self.isLastSent = array.count % GIFT_BOX_PAGINGATION_COUNT != 0 || array.count == 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SENT_GIFTBOX_REFRESHED object:nil];
        }

    }];
    
}

- (void)loadNextSentGift{

    int start = (int)self.giftArray.count + 1;
    
    [GiftController getSentGiftBox:start withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:NO with:^(NSArray *array, NSError *error) {
        
        self.loading = NO;
        [(UIActivityIndicatorView *)[self.footerView viewWithTag:10] stopAnimating];

        if (error) {
            
            [self showErrorAlertTitle:@"Opps!" message:[error localizedDescription] buttonTitle:@"OK"];
            
        }
        
        if (array) {
            
            self.isLastSent = array.count % GIFT_BOX_PAGINGATION_COUNT != 0 || array.count == 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SENT_GIFTBOX_REFRESHED object:nil];
        }
    }];
}

- (IBAction)refreshButtonClicked:(id)sender {
    
    if (self.currentGiftBoxSegment == kGiftBoxActive) {
        
        [self loadFirstActiveGift];
        
    } else if (self.currentGiftBoxSegment == kGiftBoxUsed){
        
        [self loadFirstUsedGift];
        
    } else if (self.currentGiftBoxSegment == kGiftBoxSent){
        
        [self loadFirstSentGift];
    }
}

- (void)setUI{
  
    switch (self.currentGiftBoxSegment) {
        case kGiftBoxActive:
            self.giftArray = [FZData sharedInstance].activeGiftBox;
            break;
        case kGiftBoxUsed:
            self.giftArray = [FZData sharedInstance].usedGiftBox;
            break;
        case kGiftBoxSent:
            self.giftArray = [FZData sharedInstance].sentGiftBox;
            break;
        default:
            break;
    }
    
    if ((self.giftArray && self.giftArray.count == 0) || !self.giftArray) {
        self.emptyView.hidden = NO;
        self.tableView.hidden = YES;
    } else {
        self.emptyView.hidden = YES;
        self.tableView.hidden = NO;
    }
    
    [self.tableView reloadData];
}

- (void)setStyling {
    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    UINib *giftCellNib = [UINib nibWithNibName:@"GiftBoxTableViewCell" bundle:nil];
    [self.tableView registerNib:giftCellNib forCellReuseIdentifier:@"GiftBoxTableViewCell"];
    
    UINib *powerupCardCellNib = [UINib nibWithNibName:@"GiftBoxPowerUpCardTableViewCell" bundle:nil];
    [self.tableView registerNib:powerupCardCellNib forCellReuseIdentifier:@"PowerUpCardCell"];
    
    // Setup Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshButtonClicked:)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    self.refreshControl.tintColor = [UIColor clearColor];

    self.tableView.hidden = YES;
    self.emptyView.hidden = YES;
    
    for (UIButton *button in self.segmentButtons) {
        
        if (button.tag != 0) {
            button.layer.borderWidth = 1.0f;
            button.layer.borderColor = [UIColor colorWithWhite:0.0f alpha:0.2f].CGColor;
        }
        button.layer.cornerRadius = 8.0f;
        button.layer.masksToBounds = YES;
    }
    
    [CommonUtilities setView:self.btnRefresh withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    [self resetUnopenedGiftCount];
}

- (void)resetUnopenedGiftCount{
    
    if ([UserController sharedInstance].currentUser.unOpenedActiveGiftCount.intValue > 0) {
        
        [UserController resetUnopenedGiftCount];
        [AppDelegate updateWalletBadge];
        
        [GiftController resetUnopenedGiftsCount:nil];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"pushToGiftCard"]) {
        GiftCardViewController *giftCardView = (GiftCardViewController*)segue.destinationViewController;
        giftCardView.hidesBottomBarWhenPushed = YES;
        if ([sender isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)sender;
            giftCardView.giftDict = dict;
            
        }
    }
    
    if ([segue.identifier isEqualToString:@"pushToGiftPackage"]) {
        GiftPackageViewController *giftPackageView = (GiftPackageViewController*)segue.destinationViewController;
        giftPackageView.hidesBottomBarWhenPushed = YES;
        if ([sender isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)sender;
            giftPackageView.giftDict = dict;
        }
    }
    
    if ([segue.identifier isEqualToString:@"pushToSentCard"]) {
        SentCardViewController *vc = (SentCardViewController*)segue.destinationViewController;
        vc.hidesBottomBarWhenPushed = YES;
        if ([sender isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)sender;
            vc.giftDict = dict;
        }
    }
    
    if ([segue.identifier isEqualToString:@"pushToSentPackagee"]) {
        SentPackageViewController *vc = (SentPackageViewController*)segue.destinationViewController;
        vc.hidesBottomBarWhenPushed = YES;
        if ([sender isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)sender;
            vc.giftDict = dict;
        }
    }
}

- (void)giftMarkAsUnredeemed{
    [self segmentButtonPressed:self.segmentButtons[0]];
}

- (void)giftRedeeded{
     [self segmentButtonPressed:self.segmentButtons[1]];
}

@end
