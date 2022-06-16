//
//  MeViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 19/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "MeViewController.h"
#import "FZWebView2Controller.h"
#import "UserController.h"
#import "UITableView+Reload.h"
#import "BrandTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "PlaceholderMeView.h"
#import "PackageViewController.h"
#import "CardViewController.h"
#import "PackageListViewController.h"
#import "FriendsListViewController.h"
#import "FZTabBarViewController.h"
#import "ActivateViewController.h"
#import "OrderHistoryViewController.h"
#import "PayMethodEditViewController.h"
#import "TopUpFuzzieCreditsViewController.h"
#import "ProfileTableViewCell.h"
#import "RedPacketsViewController.h"

typedef enum : NSUInteger {
    //kProfileMenuLike,
    kProfileMenuCashOut,
    kProfileMenuTopUp,
    kProfileMenuRedPackets,
    kProfileMenuFriends,
    kProfileMenuInviteFriends,
    kProfileMenuPaymentMethods,
    kProfileMenuHistory,
    kProfileMenuFuzzieCode,
    kProfileMenuHelp,
    kProfileMenuFAQ,
    kProfileMenuSettings,
    kProfileMenuCount,
    kProfileMenuTransactions,
    kProfileMenuLoyalty,
} kProfileMenu;

@interface MeViewController () <UITableViewDataSource,UITableViewDelegate, BrandTableViewCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) PlaceholderMeView *placeholderView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bornLabel;

@property (weak, nonatomic) IBOutlet UILabel *creditsLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashbackLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameCenterAnchor;

@property (assign, nonatomic) NSInteger currentSegment;
@property (strong, nonatomic) UIView *headerTableView;
//@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSArray *whishListUser;
@property (strong, nonatomic) NSMutableArray *likeUser;
@property (assign, nonatomic) kProfileMeMenuMode mode;

@property (strong, nonatomic) FZUser *user;

- (IBAction)settingsButtonPressed:(id)sender;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.whishListUser = @[];
    self.likeUser = [@[] mutableCopy];

    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self setStyling];
    
    if (self.fromShop) {
        [self segmentButtonPressed:self.segmentButtons[1]];
        _fromShop = false;
    } else if(self.selectWishlist) {
        [self segmentButtonPressed:self.segmentButtons[2]];
        _selectWishlist = false;
    } else{
        [self segmentButtonPressed:self.segmentButtons[0]];
    }
  
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setupUserInfo];
    [self loadLikedList];
    [self loadwishList];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _initinalized = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setFromShop:(BOOL)fromShop {
    
    _fromShop = fromShop;

    if (fromShop) {
        [self segmentButtonPressed:self.segmentButtons[1]];
    } else{
        [self segmentButtonPressed:self.segmentButtons[0]];
    }
}

- (void)setSelectWishlist:(BOOL)selectWishlist{
    
    _selectWishlist = selectWishlist;

    if (selectWishlist) {
        [self segmentButtonPressed:self.segmentButtons[2]];
    } else{
        [self segmentButtonPressed:self.segmentButtons[0]];
    }
}

- (void)setInitinalized:(BOOL)initinalized{
    
    _initinalized = initinalized;
    
    if (initinalized) {
        [self segmentButtonPressed:self.segmentButtons[0]];
    }
}

- (IBAction)segmentButtonPressed:(id)sender {
    
    UIButton *activeButton = (UIButton *)sender;
    
    if (self.currentSegment == activeButton.tag) {
        return;
    }
    
    self.currentSegment = activeButton.tag;
    
    self.mode = self.currentSegment;
    
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
    
    if (self.currentSegment == 0) {
        
        self.tableView.tableHeaderView = self.headerTableView;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
    } else {
        
        self.tableView.tableHeaderView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (self.currentSegment == 1) {
            
            [self loadLikedList];
            
        } else if (self.currentSegment == 2){
            
            [self loadwishList];
            
        }
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - Button Actions

- (IBAction)settingsButtonPressed:(id)sender {
    UIViewController *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileView"];
    [self.navigationController pushViewController:editView animated:YES];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.mode == kProfileMeMenuModeGeneral) {
        return kProfileMenuCount;
    }
    
    if (self.mode == kProfileMeMenuModeWishlist) {
        return [self.whishListUser count];
    }
    
    if (self.mode == kProfileMeMenuModeLike) {
        return [self.likeUser count];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.mode == kProfileMeMenuModeGeneral) {
        ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell" forIndexPath:indexPath];

        switch (indexPath.row) {
            case kProfileMenuCashOut:
                cell.lbName.text = @"Cash out credits (Coming Soon)";
                cell.ivIcon.image = [UIImage imageNamed:@"me-cashout"];
                break;
            case kProfileMenuTopUp:
                cell.lbName.text = @"Top Up";
                cell.ivIcon.image = [UIImage imageNamed:@"me-topup"];
                break;
            case kProfileMenuRedPackets:
                cell.lbName.text = @"Lucky Packets";
                cell.ivIcon.image = [UIImage imageNamed:@"me-red-packets"];
                break;
            case kProfileMenuFriends:
                cell.lbName.text = @"My friends";
                cell.ivIcon.image = [UIImage imageNamed:@"me-friends"];
                break;
            case kProfileMenuInviteFriends:
                cell.lbName.text = @"Invite friends & earn!";
                cell.ivIcon.image = [UIImage imageNamed:@"me-invite-friends"];
                break;
            case kProfileMenuPaymentMethods:
                cell.lbName.text = @"Manage payment methods";
                cell.ivIcon.image = [UIImage imageNamed:@"me-payment-methods"];
                break;
            case kProfileMenuHistory:
                cell.lbName.text = @"History";
                cell.ivIcon.image = [UIImage imageNamed:@"me-history"];
                break;
            case kProfileMenuLoyalty:
                cell.lbName.text = @"Loyalty Programmes";
                cell.ivIcon.image = [UIImage imageNamed:@"me-loyalty"];
                break;
            case kProfileMenuTransactions:
                cell.lbName.text = @"Transactions";
                cell.ivIcon.image = [UIImage imageNamed:@"me-transactions"];
                break;
            case kProfileMenuFuzzieCode:
                cell.lbName.text = @"Fuzzie Code";
                cell.ivIcon.image = [UIImage imageNamed:@"me-code"];
                break;
            case kProfileMenuHelp:
                cell.lbName.text = @"Need help?";
                cell.ivIcon.image = [UIImage imageNamed:@"me-help"];
                break;
            case kProfileMenuFAQ:
                cell.lbName.text = @"FAQ";
                cell.ivIcon.image = [UIImage imageNamed:@"me-loyalty"];
                break;
            case kProfileMenuSettings:
                cell.lbName.text = @"Settings";
                cell.ivIcon.image = [UIImage imageNamed:@"me-settings"];
                break;
            default:
                break;
        }
        
        return cell;
    } else {
        BrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (self.mode == kProfileMeMenuModeGeneral) {
         return 61.0f;
     } else {
        return 240.0f;
     }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.mode != kProfileMeMenuModeGeneral) {
        BrandTableViewCell *cellBrand = (BrandTableViewCell *)cell;
        FZBrand *brand = nil;
        if (self.mode == kProfileMeMenuModeWishlist) {
            brand = self.whishListUser[indexPath.row];
        } else {
            brand = self.likeUser[indexPath.row];
        }
        
        [cellBrand setupWithBrand:brand];
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.mode == kProfileMeMenuModeGeneral) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        switch (indexPath.row) {
                
            case kProfileMenuCashOut:{
                break;
            }
            case kProfileMenuTopUp:{

                TopUpFuzzieCreditsViewController *topUpView = [[GlobalConstants topUpStoryboard] instantiateViewControllerWithIdentifier:@"TopUpFuzzieCreditsView"];
                topUpView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:topUpView animated:YES];
                break;
            }
            case kProfileMenuRedPackets:{
                RedPacketsViewController *redPacketsView = [[GlobalConstants redPacketsStoryboard] instantiateViewControllerWithIdentifier:@"RedPacketsView"];
                redPacketsView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:redPacketsView animated:YES];
                break;
            }
            case kProfileMenuFriends:
            {
                FriendsListViewController *friendsListView = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsListView"];
                friendsListView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:friendsListView animated:YES];
                break;
            }
            case kProfileMenuInviteFriends:
            {
                UIViewController *inviteView = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteView"];
                inviteView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:inviteView animated:YES];
                break;

            }
            case kProfileMenuPaymentMethods:
            {
                PayMethodEditViewController *payMethodEditView = [[GlobalConstants paymentStoryboard] instantiateViewControllerWithIdentifier:@"PayMethodEditView"];
                payMethodEditView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:payMethodEditView animated:YES];
                break;
            }
            case kProfileMenuHistory:
            {
                OrderHistoryViewController *historyView = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryView"];
                historyView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:historyView animated:YES];
                break;
            }
            case kProfileMenuLoyalty:
                
                break;
            case kProfileMenuTransactions:
                
                break;
          
            case kProfileMenuHelp:
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"Need help?"];
                
                if ([MFMailComposeViewController canSendMail]) {
                    
                    [actionSheet bk_addButtonWithTitle:@"Email us" handler:^{
                        
                        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                        [mailer setSubject: @"Fuzzie Support"];
                        [mailer setToRecipients:@[@"support@fuzzie.com.sg"]];
                        mailer.navigationBar.tintColor = [UIColor whiteColor];
                        mailer.bk_completionBlock = ^( MFMailComposeViewController *mailer, MFMailComposeResult result, NSError* error) {
                            
                            if (result == MFMailComposeResultSent) {
                                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Email sent!", nil)];
                            }
                            
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
                break;
            case kProfileMenuFuzzieCode:
            {
                ActivateViewController *activateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivateView"];
                activateViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:activateViewController animated:YES];
                break;
            }
            case kProfileMenuFAQ:
            {
                [self performSegueWithIdentifier:@"pushToWebview" sender:@{@"url":@"http://fuzzie.com.sg/faq.html",@"title":@"FAQ"}];
            }
                break;
            case kProfileMenuSettings:
            {
                UIViewController *settingsView = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsView"];
                settingsView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:settingsView animated:YES];
                break;
            }
            default:
                break;
        }
    } else {
        
        FZBrand *brand = nil;
        if (self.mode == kProfileMeMenuModeWishlist) {
            brand = self.whishListUser[indexPath.row];
        } else {
            brand = self.likeUser[indexPath.row];
        }
        
        
        if (brand.giftCards && brand.giftCards.count > 0 && brand.services && brand.services.count > 0) {
            
            PackageListViewController *packageListView = [self.storyboard instantiateViewControllerWithIdentifier:@"PackageListView"];
            packageListView.brand = brand;
            packageListView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:packageListView animated:YES];
            
        } else if (brand.giftCards && brand.giftCards.count > 0) {
            
            [self performSegueWithIdentifier:@"pushToBrandCardGift" sender:brand];
            
        } else if (brand.services && brand.services.count == 1) {
            
            NSDictionary *packageDict = [brand.services firstObject];
            
            [self performSegueWithIdentifier:@"pushToPackage"
                                      sender:@{@"brand":brand,@"packageDict":packageDict}];
            
        } else if (brand.services && brand.services.count > 1) {
            
            PackageListViewController *packageListView = [self.storyboard instantiateViewControllerWithIdentifier:@"PackageListView"];
            packageListView.brand = brand;
            packageListView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:packageListView animated:YES];
            
        }
    }
}

#pragma mark - Helper Functions

- (void)setStyling {
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UINib *customNib = [UINib nibWithNibName:@"PlaceholderMeView" bundle:nil];
    self.placeholderView = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    UINib *profileCellNib = [UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil];
    [self.tableView registerNib:profileCellNib forCellReuseIdentifier:@"ProfileCell"];
    
    self.profileImageView.layer.cornerRadius = 35.0f;
    self.profileImageView.layer.masksToBounds = YES;
    
    for (UIButton *button in self.segmentButtons) {
        
        if (button.tag != 0) {
            button.layer.borderWidth = 1.0f;
            button.layer.borderColor = [UIColor colorWithWhite:0.0f alpha:0.2f].CGColor;
        }
        button.layer.cornerRadius = 8.0f;
        button.layer.masksToBounds = YES;
    }
    
    self.headerTableView = self.tableView.tableHeaderView;
    
    
    UINib *BrandCellNib = [UINib nibWithNibName:@"BrandTableViewCell" bundle:nil];
    [self.tableView registerNib:BrandCellNib forCellReuseIdentifier:@"BrandCell"];
    
}

- (void)setupUserInfo {
    
     self.user = [UserController sharedInstance].currentUser;
    
    if (self.user) {
        
        self.nameLabel.text = self.user.name;
        
        static NSDateFormatter *dateFormatter;
        static NSDateFormatter *displayFormatter;
        
        if (!dateFormatter) {
            dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        
        if (!displayFormatter) {
            displayFormatter = [NSDateFormatter new];
            [displayFormatter setDateFormat:@"d MMMM yyyy"];
        }
        
        if (self.user.birthday && self.user.birthday.length > 0) {
            NSDate *birthDate = [dateFormatter dateFromString:self.user.birthday];
            self.bornLabel.text = [NSString stringWithFormat:@"Born %@", [displayFormatter stringFromDate:birthDate]];
            self.nameCenterAnchor.constant = -8;
        } else {
            self.bornLabel.text = nil;
            self.nameCenterAnchor.constant = 0;
        }
        
        if (self.user.profileImage && ![self.user.profileImage isEqualToString:@""]) {
            NSURL *profileUrl = [NSURL URLWithString:self.user.profileImage];
            [self.profileImageView sd_setImageWithURL:profileUrl placeholderImage:[UIImage imageNamed:@"profile-image"]];
        } else {
            self.profileImageView.image = [UIImage imageNamed:@"profile-image"];
        }
        
        self.creditsLabel.attributedText = [CommonUtilities getFormattedValue:[UserController sharedInstance].currentUser.credits fontSize:17.0f smallFontSize:13.0f];
        
         self.cashbackLabel.attributedText = [CommonUtilities getFormattedValue:[UserController sharedInstance].currentUser.cashbackEarned fontSize:17.0f smallFontSize:13.0f];
        
    }
    
}
- (IBAction)editButtonTapped:(id)sender {
    UIViewController *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileView"];
    editView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editView animated:YES];
}

- (void)loadLikedList{
    
    self.user = [UserController sharedInstance].currentUser;
    
    NSMutableArray *brands = [NSMutableArray new];
    for (NSString *brandId in self.user.likedListIds) {
        for (FZBrand *brand in [FZData sharedInstance].brandArray) {
            if ([brand.brandId isEqualToString:brandId]) {
                [brands addObject:brand];
                break;
            }
        }
    }
    
    self.likeUser = [brands mutableCopy];
    
    if(self.mode == kProfileMeMenuModeLike) {
        if (self.likeUser.count == 0) {
            [self.placeholderView changePlaceHolderMode:self.mode];
        }
        
        [self.tableView reloadData];
    }
    
    if (self.mode == kProfileMeMenuModeGeneral) {
        [self.placeholderView stopLoader];
    }

}

- (void)loadwishList{
    
    self.user = [UserController sharedInstance].currentUser;
    
    NSMutableArray *brands = [NSMutableArray new];
    for (NSString *brandId in self.user.wishListIds) {
        for (FZBrand *brand in [FZData sharedInstance].brandArray) {
            if ([brand.brandId isEqualToString:brandId]) {
                [brands addObject:brand];
                break;
            }
        }
    }
    
    self.whishListUser = brands;
    
    if(self.mode == kProfileMeMenuModeWishlist) {
        if (self.whishListUser.count == 0) {
            [self.placeholderView changePlaceHolderMode:self.mode];
        }
        
        [self.tableView reloadData];
    }
    
    if (self.mode == kProfileMeMenuModeGeneral) {
        [self.placeholderView stopLoader];
    }

}

- (IBAction)avatarTapped:(id)sender {
    UIViewController *imageView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileImageView"];
    imageView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:imageView animated:YES];
}

#pragma -mark DZNEmptyDataSet

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    
    if (self.mode == kProfileMeMenuModeWishlist) {
        if (self.whishListUser.count > 0) {
            [self.placeholderView stopLoader];
        } else {
            [self.placeholderView changePlaceHolderMode:kProfileMeMenuModeWishlist];
        }
    } else if (self.mode == kProfileMeMenuModeLike){
        if (self.likeUser.count > 0) {
            [self.placeholderView stopLoader];
        } else {
            [self.placeholderView changePlaceHolderMode:kProfileMeMenuModeLike];
        }
    }
    
    return self.placeholderView;
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0;
    
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView {
    
    [self.placeholderView refreshSize];
    [scrollView setContentOffset:CGPointMake(0, -scrollView.contentInset.top) animated:NO];
}

- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state cell:(UITableViewCell *)cell {
    
    [super likeButtonTappedOn:brand WithState:state cell:cell];
    if (self.mode == kProfileMeMenuModeLike){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.likeUser removeObject:brand];
        //[self.tableView reloadData];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

#pragma mark - BrandTableViewCellDelegate

- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state {
    [self likeBrand:brand withState:state];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"pushToWebview"]) {
        if ([segue.destinationViewController isKindOfClass:[FZWebView2Controller class]]) {
            FZWebView2Controller *webView2Controller = (FZWebView2Controller *)segue.destinationViewController;
            if (sender){
                if ([sender isKindOfClass:[NSDictionary class]]) {
                    if ([sender[@"url"] isKindOfClass:[NSString class]]) {
                        webView2Controller.URL = ((NSString *)(NSDictionary *)sender[@"url"]);
                    }
                    if ([sender[@"title"] isKindOfClass:[NSString class]]) {
                        webView2Controller.titleHeader = ((NSString *)(NSDictionary *)sender[@"title"]);
                    }
                }
            }
        }
    }
    
    if ([segue.identifier isEqualToString:@"pushToBrandCardGift"]) {
        if ([segue.destinationViewController isKindOfClass:[CardViewController class]]) {
            CardViewController *cardViewController = (CardViewController *)segue.destinationViewController;
            cardViewController.hidesBottomBarWhenPushed = YES;
            if (sender){
                if ([sender isKindOfClass:[FZBrand class]]) {
                    cardViewController.brand = (FZBrand *)sender;
                }
            }
        }
    }
    
    if ([segue.identifier isEqualToString:@"pushToPackage"]) {
        if ([segue.destinationViewController isKindOfClass:[PackageViewController class]]) {
            PackageViewController *packageViewController = (PackageViewController *)segue.destinationViewController;
            packageViewController.hidesBottomBarWhenPushed = YES;
            if (sender){
                if ([sender isKindOfClass:[NSDictionary class]]) {
                    packageViewController.brand = [(NSDictionary *)sender objectForKey:@"brand"];
                    packageViewController.packageDict = [(NSDictionary *)sender objectForKey:@"packageDict"];
                }
            }
        }
    }

}
@end
