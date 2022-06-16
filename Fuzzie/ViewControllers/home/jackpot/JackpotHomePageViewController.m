//
//  JackpotEnterViewController.m
//  Fuzzie
//
//  Created by mac on 9/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotHomePageViewController.h"
#import "JackpotEnterTableViewCell.h"
#import "JackpotHeaderView.h"
#import "JackpotSectionTableViewCell.h"
#import "FZHeaderView.h"
#import "JackpotLearnMoreViewController.h"
#import "JackpotSortViewController.h"
#import "JackpotRefineViewController.h"
#import "JackpotCardViewController.h"
#import "JackpotLiveDrawViewController.h"
#import "JackpotHomePowrupPackTableViewCell.h"
#import "PowerUpPackViewController.h"
#import "PowerUpPackCardViewController.h"

typedef enum : NSUInteger {
    kJackpotHomeSectionPowerupPack,
    kJackpotHomeSectionOfferList,
    kJackpotHomeSectionCount,
} kJackpotHomeSection;

@interface JackpotHomePageViewController () <UITableViewDataSource, UITableViewDelegate, JackpotEnterTableViewCellDelegate, JackpotHeaderViewDelegate, JackpotSectionTableViewCellDelegate, JackpotSortViewControllerDelegate, JackpotRefineViewControllerDelegate, JackpotHomePowrupPackTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet FZHeaderView *headerNav;
@property (weak, nonatomic) IBOutlet UIView *backgroundNav;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lbTicketsCount;
@property (weak, nonatomic) IBOutlet UILabel *lbEntitledTicketsCount;

@property (strong, nonatomic) JackpotHeaderView *headerView;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;

@end

@implementation JackpotHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveDrawStart) name:JACKPOT_LIVE_DRAW_START object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveDrawEnd) name:JACKPOT_LIVE_DRAW_END object:nil];
    
    [FZData sharedInstance].selectedJackpotSortIndex = 0;
    [FZData sharedInstance].selectedJackpotRefineSubCategoryIds = [[NSMutableSet alloc] init];
    
    [self setStyling];
    
//    [self loadIssuedTicketsCount];
    if ([FZData sharedInstance].coupons) {
        self.couponArray = [FZData sharedInstance].coupons;
        self.sortedCouponArray = self.couponArray;
        self.refinedCouponArray = self.couponArray;
    } else{
        [self loadCoupons];
    }

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.headerView setNeedsLayout];
    [self.headerView layoutIfNeeded];
    
    self.headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [JackpotHeaderView estimateHeight]);
    [self.tableView setTableHeaderView:self.headerView];

    [self.tableView setContentOffset:CGPointMake(0, 64)];
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.headerView updateLiveDrawState];
    [self showTicketsCountPurchased];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.headerView endTimer];
}

- (void)setStyling{
    
    UINib *headerNib = [UINib nibWithNibName:@"JackpotHeaderView" bundle:nil];
    self.headerView = [[headerNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.headerView.delegate = self;
    [self.tableView setTableHeaderView:self.headerView];
    
    UINib *sectionNib = [UINib nibWithNibName:@"JackpotSectionTableViewCell" bundle:nil];
    [self.tableView registerNib:sectionNib forCellReuseIdentifier:@"Section"];
    
    UINib *cellNib = [UINib nibWithNibName:@"JackpotEnterTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    UINib *packNib = [UINib nibWithNibName:@"JackpotHomePowrupPackTableViewCell" bundle:nil];
    [self.tableView registerNib:packNib forCellReuseIdentifier:@"PackCell"];
  
    self.headerNav.backgroundColor = [UIColor clearColor];
    self.backgroundNav.alpha = 0;
    self.lbTitle.hidden = YES;

}

- (void)showTicketsCountPurchased{
    NSString *firstString = @"YOU'VE GOT ";
    int jackpotTicketsCount = 0;
    if ([FZData isCuttingOffLiveDraw]) {
        jackpotTicketsCount = [[UserController sharedInstance].currentUser.nextJackpotTicketsCount intValue];
    } else{
        jackpotTicketsCount = [[UserController sharedInstance].currentUser.currentJackpotTicketsCount intValue];
    }
    NSString *secondString =  @"";
    if (jackpotTicketsCount > 1) {
        secondString = [NSString stringWithFormat:@"%d/%d JACKPOT TICKETS", jackpotTicketsCount, [FZData sharedInstance].ticketsLimitPerWeek];
    } else{
        secondString = [NSString stringWithFormat:@"%d/%d JACKPOT TICKET", jackpotTicketsCount, [FZData sharedInstance].ticketsLimitPerWeek];
    }
    NSString *thirdString = @" FOR THE NEXT DRAW";
    NSMutableAttributedString *attributtedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", firstString, secondString, thirdString]];
    [attributtedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#F8C736"] range: NSMakeRange(firstString.length, secondString.length)];
    self.lbTicketsCount.attributedText = attributtedString;
    
    self.lbEntitledTicketsCount.text = [NSString stringWithFormat:@"You are entitled to %d Jackpot tickets per week", [FZData sharedInstance].ticketsLimitPerWeek];
}

#pragma mark - Load Coupons
- (void)loadCoupons{
    
    [self showLoader];

    [JackpotController getCouponTemplate:^(NSDictionary *dictionary, NSError *error) {
        
        [self hideLoader];
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
            } else{
                [self showEmptyError:[error localizedDescription] window:NO];
                return ;
            }
        }
        
        if (dictionary) {
            
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            for (NSDictionary *couponDict in dictionary[@"coupons"]) {
                NSError *error = nil;
                FZCoupon *coupon = [MTLJSONAdapter modelOfClass:FZCoupon.class fromJSONDictionary:couponDict error:&error];
                if (error) {
                    DDLogError(@"FZCoupon Error: %@", [error localizedDescription]);
                } else if (coupon) {
                    FZBrand *brand = [FZData getBrandById:coupon.brandId];
                    if (brand) {
                        coupon.brandName = brand.name;
                        coupon.subcategoryId = brand.subcategoryId;
                    }
                    
                    double pricePerTicket = ([coupon.priceValue doubleValue] - [coupon.cashbackValue doubleValue]) / [coupon.ticketCount intValue];
                    coupon.pricePerTicket = [NSNumber numberWithDouble:pricePerTicket];
                    
                    [temp addObject:coupon];
                }
            }
            
            [FZData sharedInstance].coupons = temp;
            self.couponArray = temp;
            self.sortedCouponArray = self.couponArray;
            self.refinedCouponArray = self.couponArray;
            
            [self.tableView reloadData];
        }
    }];
}

//- (void)loadIssuedTicketsCount{
//    [JackpotController getIssuedTicketsCount:^(NSDictionary *dictionary, NSError *error) {
//
//        if (dictionary) {
//            [FZData sharedInstance].ticketsCount = dictionary[@"count"];
//            if ([[FZData sharedInstance].ticketsCount intValue] > 1) {
//                NSNumberFormatter *formatter = [NSNumberFormatter new];
//                [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
//                self.headerView.lbTicketsCount.text = [NSString stringWithFormat:@"%@ Jackpot tickets given", [formatter stringFromNumber:[FZData sharedInstance].ticketsCount]];
//
//            } else {
//                self.headerView.lbTicketsCount.text = [NSString stringWithFormat:@"%d Jackpot ticket given", [[FZData sharedInstance].ticketsCount intValue]];
//
//            }
//        }
//
//    }];
//}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kJackpotHomeSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == kJackpotHomeSectionPowerupPack) {
        if ([FZData getPowerUpPacks].count > 0){
            
            return 1;
            
        }
    }
    
    if (section == kJackpotHomeSectionOfferList) {
        return self.refinedCouponArray.count;
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kJackpotHomeSectionPowerupPack) {
        
        JackpotHomePowrupPackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PackCell"];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == kJackpotHomeSectionOfferList){
        
        JackpotEnterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        FZCoupon *coupon = [self.refinedCouponArray objectAtIndex:indexPath.row];
        if (coupon.powerUpPack) {
            [cell setCell:coupon mode:kJackpotEnterCellModePack];
        } else {
            [cell setCell:coupon mode:kJackpotEnterCellModeNormal];
        }
        cell.delegate = self;
        return cell;
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kJackpotHomeSectionOfferList){
        
        return 112.0f;
    }
    
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == kJackpotHomeSectionOfferList) {
        JackpotSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Section"];
        cell.delegate = self;
        return cell;
    }
    
    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == kJackpotHomeSectionOfferList) {
        
        return 60.0f;
    }
    
    return 0.0f;
}

#pragma mark - JackpotEnterTableViewCellDelegate

- (void)jackpotEnterCellTapped:(FZCoupon *)coupon brand:(FZBrand *)brand{
    
    if (coupon.powerUpPack) {
        
        PowerUpPackCardViewController *cardView = [self.storyboard instantiateViewControllerWithIdentifier:@"PowerUpPackCardView"];
        cardView.coupon = coupon;
        [self.navigationController pushViewController:cardView animated:YES];
        
    } else {
        
        JackpotCardViewController *cardView = (JackpotCardViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"JackpotCardView"];
        cardView.coupon = coupon;
        cardView.brand = brand;
        [self.navigationController pushViewController:cardView animated:YES];
    }
}

#pragma -mark UIScrollView 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat headerViewHight = [JackpotHeaderView estimateHeight];
    
    int realPosition = scrollView.contentOffset.y;
    
    if (realPosition >= headerViewHight) {
        float ratio = realPosition-headerViewHight;
        double coef = MIN(1,ratio/32);
        self.backgroundNav.alpha = (float)coef;
        self.lbTitle.hidden = NO;
    } else {
        self.backgroundNav.alpha = 0;
        self.lbTitle.hidden = YES;
    }
    
    if (scrollView.contentOffset.y < 64) {
        [self.tableView setContentOffset:CGPointMake(0, 64)];
    }
}

#pragma mark - JackpotHeaderViewDelegate
- (void)learnMoreButtonPressed{
    JackpotLearnMoreViewController *learnView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotLearnMoreView"];
    [self.navigationController pushViewController:learnView animated:YES];
}

- (void)liveDrawButtonPressed{
    JackpotLiveDrawViewController *liveView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotLiveDrawView"];
    [self.navigationController pushViewController:liveView animated:YES];
}

#pragma mark - JackpotHomePowrupPackTableViewCellDelegate
- (void)powerupPackBannerClicked{

    if ([FZData getPowerUpPacks].count > 0) {
        
        if ([FZData getPowerUpPacks].count == 1) {
            
            PowerUpPackCardViewController *cardView = [self.storyboard instantiateViewControllerWithIdentifier:@"PowerUpPackCardView"];
            cardView.coupon = [[FZData getPowerUpPacks] firstObject];
            [self.navigationController pushViewController:cardView animated:YES];
            
            
        } else {
            
            PowerUpPackViewController *powerupPackView = [self.storyboard instantiateViewControllerWithIdentifier:@"PowerUpPackView"];
            powerupPackView.coupons = [FZData getPowerUpPacks];
            [self.navigationController pushViewController:powerupPackView animated:YES];
            
        }
    }

    
    
}

#pragma mark - JackpotSectionTableViewCellDelegate
- (void)sortButtonPressed{
    JackpotSortViewController *sortView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotSortView"];
    sortView.delegate = self;
    [self.navigationController pushViewController:sortView animated:YES];
}

- (void)refineButtonPressed{
    JackpotRefineViewController *refineView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotRefineView"];
    refineView.delegate = self;
    refineView.subCategories = [FZData getSubCategoriesWithCouponArray:self.sortedCouponArray];
    [self.navigationController pushViewController:refineView animated:YES];
}

#pragma mark - JackpotSortViewControllerDelegate
- (void)changeSortItem{
    [[NSNotificationCenter defaultCenter] postNotificationName:JACKPOT_SORT object:nil];
    
    [self sortCoupons];
}

#pragma mark - JackpotRefineViewControllerDelegate
- (void)jackpotRefineDoneButtonPressed{
    [[NSNotificationCenter defaultCenter] postNotificationName:JACKPOT_REFINE object:nil];
    
    [self sortCoupons];
}

- (void)sortCoupons{
    switch ([FZData sharedInstance].selectedJackpotSortIndex) {
        case 0:
            self.sortDescriptor = nil;
            self.sortedCouponArray = self.couponArray;
            break;
        case 1:
            self.sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priceValue" ascending:NO];
            self.sortedCouponArray = [self.couponArray sortedArrayUsingDescriptors:@[self.sortDescriptor]];
            break;
        case 2:
            self.sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priceValue" ascending:YES];
            self.sortedCouponArray = [self.couponArray sortedArrayUsingDescriptors:@[self.sortDescriptor]];
            break;
        case 3:
            self.sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pricePerTicket" ascending:YES];
            self.sortedCouponArray = [self.couponArray sortedArrayUsingDescriptors:@[self.sortDescriptor]];
            break;
        case 4:
            self.sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ticketCount" ascending:NO];
            self.sortedCouponArray = [self.couponArray sortedArrayUsingDescriptors:@[self.sortDescriptor]];
            break;
        case 5:
            self.sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cashbackPercentage" ascending:NO];
            self.sortedCouponArray = [self.couponArray sortedArrayUsingDescriptors:@[self.sortDescriptor]];
            break;
        case 6:
            self.sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"brandName" ascending:YES];
            self.sortedCouponArray = [self.couponArray sortedArrayUsingDescriptors:@[self.sortDescriptor]];
            break;
        default:
            self.sortDescriptor = nil;
            self.sortedCouponArray = self.couponArray;
            break;
    }
    
    [self refineCoupons];
}

- (void)refineCoupons{
    if ([FZData sharedInstance].selectedJackpotRefineSubCategoryIds.count == 0) {
        self.refinedCouponArray = self.sortedCouponArray;
    } else {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSNumber *subId in [FZData sharedInstance].selectedJackpotRefineSubCategoryIds) {
            for (FZCoupon *coupon in self.sortedCouponArray) {
                if ([subId isEqual:coupon.subcategoryId]) {
                    [tempArray addObject:coupon];
                }
            }
        }
        
        if (self.sortDescriptor) {
            self.refinedCouponArray = [tempArray sortedArrayUsingDescriptors:@[self.sortDescriptor]];
        } else{
            self.refinedCouponArray = tempArray;
        }
    }
    
//    [self.tableView setContentOffset:CGPointZero animated:YES];
    [self.tableView reloadData];
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonPressed:(id)sender {
    NSString *body = @"Check out The Fuzzie Jackpot! You can win S$150,000 cash prizes EVERY WEEK with your own 4D number. Get free Jackpot tickets simply by buying their e-vouchers from popular brands. https://fuzzie.com.sg/jackpot";
    NSArray *activityItems = @[body];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:activityItems applicationActivities:nil];
    
    activityViewController.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - Jackpot Live Draw Start / End
- (void)liveDrawStart{
    [FZData sharedInstance].isLiveDraw = true;
    [self.headerView updateLiveDrawState];
    self.headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [JackpotHeaderView estimateHeight]);
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView reloadData];
}

- (void)liveDrawEnd{
    [FZData sharedInstance].isLiveDraw = false;
    self.headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [JackpotHeaderView estimateHeight]);
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView reloadData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JACKPOT_LIVE_DRAW_START object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JACKPOT_LIVE_DRAW_END object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
