//
//  GiftPackageViewController.m
//  Fuzzie
//
//  Created by mac on 5/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "GiftPackageViewController.h"
#import "BrandSliderCell.h"
#import "BrandGiftPackageTitleTableViewCell.h"
#import "GiftCardRedeemTableViewCell.h"
#import "AboutBrandTableViewCell.h"
#import "TripAdvisorBrandTableViewCell.h"
#import "InfoBrandTableViewCell.h"
#import "StoreTableViewController.h"
#import "HowToRedeemViewController.h"
#import "TermsAndConditionsTableViewController.h"
#import "FZWebView2Controller.h"
#import "PackageBrandDetailTableViewCell.h"
#import "FZRedeemPopView.h"
#import "GiftSenderInfoTableViewCell.h"
#import "MarkAsUnredeemedTableViewCell.h"
#import "BrandValidOptionTableViewCell.h"
#import "PhysicalGiftRedeemViewController.h"
#import "OnlineGiftRedeemViewController.h"

@interface GiftPackageViewController ()<UITableViewDelegate, UITableViewDataSource, AboutBrandTableViewCellDelegate, InfoBrandTableViewCellDelegate, TripAdvisorBrandTableViewCellDelegate, GiftCardRedeemTableViewCellDelegate, FZRedeemPopViewDelegate, MarkAsUnredeemedTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) int heightAboutBrand;

@property (strong, nonatomic) FZRedeemPopView *redeemPopView;

@end

typedef enum : NSUInteger{
    kGiftCardSectionBanner,
    kGiftCardSectionCardTitle,
    kGiftCardSectionRedeem,
    kGiftCardSectionValid,
    kGiftCardSectionSenderInfo,
    kGiftCardSectionDescription,
    kGiftCardSectionAboutBrand,
    kGiftCardSectionTripAdvisor,
    kGiftCardSectionInfoConditions,
    kGiftCardSectionInfoRedeem,
    kGiftCardSectionStoreLocation,
    kGiftCardSectionMarkAsUnredeemed,
    kGiftCardSectionCount
    
} kGiftCardSection;

@implementation GiftPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setStyling];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
    [self.tableView reloadData];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)initData{

    NSDictionary *brandDict = self.giftDict[@"brand"];
    NSError *error = nil;
    FZBrand *brand =[MTLJSONAdapter modelOfClass:FZBrand.class fromJSONDictionary:brandDict error:&error];
    if (error) {
        return;
    } else {
        self.brand = brand;
    }
    self.serviceCardDict = self.giftDict[@"service"];
    
    self.gifted = self.giftDict[@"gifted"] && ![self.giftDict[@"gifted"] isKindOfClass:[NSNull class]] && [self.giftDict[@"gifted"] boolValue];
    if (self.giftDict[@"message"] && [self.giftDict[@"message"] isKindOfClass:[NSString class]]) {
        self.message = self.giftDict[@"message"];
    }
    if (self.giftDict[@"sender"] && [self.giftDict[@"sender"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *sender = self.giftDict[@"sender"];
        NSError *error = nil;
        self.sender = [MTLJSONAdapter modelOfClass:FZFacebookFriend.class fromJSONDictionary:sender error:&error];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableViewDataSoruce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == kGiftCardSectionTripAdvisor) {
        if (self.brand.tripadvisorLink && ![self.brand.tripadvisorLink isEqualToString:@""] && self.brand.tripadvisorReviewCount && [self.brand.tripadvisorReviewCount intValue] > 0) {
            return 1;
        } else{
            return 0;
        }
        
    } else if (section == kGiftCardSectionSenderInfo && !self.gifted) {
        return 0;
        
    } else if (section == kGiftCardSectionValid &&
        self.brand.textOptionGiftCard.count < 1) {
        return 0;
        
    } else if (section == kGiftCardSectionDescription) {
        if (!(self.serviceCardDict && self.serviceCardDict[@"description"] && [self.serviceCardDict[@"description"] isKindOfClass:[NSString class]] && ![self.serviceCardDict[@"description"] isEqualToString:@""])) {
            return 0;
        }
        
    } else if (section == kGiftCardSectionStoreLocation){
        
        if (self.brand.stores.count < 1) {
            return 0;
        }
        
    } else if (section == kGiftCardSectionMarkAsUnredeemed) {
        
        if (self.giftDict[@"redeem_timer_started_at"] && ![self.giftDict[@"redeem_timer_started_at"] isKindOfClass:[NSString class]]) {
            return 0;
        }
    }

    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kGiftCardSectionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == kGiftCardSectionBanner) {
        
        BrandSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandSliderCell" forIndexPath:indexPath];
        [cell initSliderIfNeeded];
        [cell setBrandInfo:self.brand withMode:BrandSliderCellModePackage package:self.serviceCardDict showSoldOut:false];
        return cell;
        
    } else if(indexPath.section == kGiftCardSectionCardTitle){
        
        BrandGiftPackageTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandGiftPackageTitleCell" forIndexPath:indexPath];
        [cell setBrandInfo:self.brand andPackageInfo:self.serviceCardDict];
        return cell;
        
    } else if(indexPath.section == kGiftCardSectionValid){
        BrandValidOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValidCell"];
        cell.options = self.brand.textOptionGiftCard;
        cell.bottomSeparator.hidden = NO;
        return cell;
        
    } else if (indexPath.section ==  kGiftCardSectionDescription) {
        PackageBrandDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PackageBrandDetailCell" forIndexPath:indexPath];
        if (self.serviceCardDict && self.serviceCardDict[@"description"]) {
            [cell setPackageBrandDetailText:self.serviceCardDict[@"description"]];
        }
        return cell;
        
    } else if(indexPath.section == kGiftCardSectionRedeem){
        
        GiftCardRedeemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedeemCell" forIndexPath:indexPath];
        [cell setCellWith:self.giftDict];
        cell.delegate = self;
        return cell;
        
    } else if(indexPath.section == kGiftCardSectionSenderInfo){
        
        GiftSenderInfoTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"SenderInfoCell" forIndexPath:indexPath];
        [cell setGiftSenderInfo:self.sender withMessage:self.message];
        return cell;
        
    } else if(indexPath.section == kGiftCardSectionAboutBrand){
        
        AboutBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutBrandCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.topSeparator.hidden = NO;
        cell.bottomSeparator.hidden = NO;
        [cell setAboutBrandTextWithBrand:self.brand];
        return cell;
        
    } else if(indexPath.section == kGiftCardSectionTripAdvisor){
        
        TripAdvisorBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripAdvisorBrandCell" forIndexPath:indexPath];
        if (self.brand.tripadvisorLink) {
            [cell getTripAdvisorInfoWithBrandId:self.brand];
            cell.delegate = self;
        }
        return cell;
        
    }else if (indexPath.section == kGiftCardSectionInfoConditions){
        
        InfoBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoBrandCell" forIndexPath:indexPath];
        cell.topSeparator.hidden = NO;
        cell.typeCell = InfoBrandTypeCondition;
        cell.delegate = self;
        cell.infoBrandLabel.text = @"Terms and conditions";
        [cell.ivIcon setImage:[UIImage imageNamed:@"icon-terms-condition"]];
        return cell;
        
    } else if (indexPath.section == kGiftCardSectionInfoRedeem){
        
        InfoBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoBrandCell" forIndexPath:indexPath];
        cell.topSeparator.hidden = YES;
        if (self.giftDict[@"online"] && ![self.giftDict[@"online"] isKindOfClass:[NSNull class]] && [self.giftDict[@"online"] boolValue]) {
            
            if (self.giftDict[@"redeem_timer_started_at"] && ![self.giftDict[@"redeem_timer_started_at"] isKindOfClass:[NSString class]]) {
                cell.bottomSeparator.hidden = NO;
            } else{
                cell.bottomSeparator.hidden = YES;
            }
            
        } else if (self.brand.stores && self.brand.stores.count <= 0){
            cell.bottomSeparator.hidden = NO;
        } else{
            cell.bottomSeparator.hidden = YES;
        }
        cell.typeCell = InfoBrandTypeRedeem;
        cell.delegate = self;
        cell.infoBrandLabel.text = @"How to redeem";
        [cell.ivIcon setImage:[UIImage imageNamed:@"icon-how-to-redeem"]];
        return cell;
        
    } else if(indexPath.section == kGiftCardSectionStoreLocation){
        
        InfoBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoBrandCell" forIndexPath:indexPath];
        cell.topSeparator.hidden = YES;
        cell.bottomSeparator.hidden = YES;
        cell.typeCell = InfoBrandTypeStoreLocator;
        cell.delegate = self;
        cell.infoBrandLabel.text = @"Store Location & contact";
        [cell.ivIcon setImage:[UIImage imageNamed:@"icon-store-location"]];
        return cell;
        
    } else if(indexPath.section == kGiftCardSectionMarkAsUnredeemed){
        
        MarkAsUnredeemedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarkAsUnredeemedCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
        
    } else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kGiftCardSectionValid) {
        if (self.brand.textOptionGiftCard.count > 0) {
            return 70.0f;
        }
        
    } else if (indexPath.section == kGiftCardSectionAboutBrand){
        return self.heightAboutBrand;
        
    } else if (indexPath.section == kGiftCardSectionTripAdvisor){
        return 60;
        
    } else if(indexPath.section == kGiftCardSectionInfoConditions ||
              indexPath.section == kGiftCardSectionInfoRedeem ||
              indexPath.section == kGiftCardSectionStoreLocation){
        
        return 62;
        
    } else if(indexPath.section == kGiftCardSectionMarkAsUnredeemed){
        return 62;
        
    }
    
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    //Set the background color of the View
    view.tintColor = [UIColor colorWithHexString:@"F7F7F7"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == kGiftCardSectionInfoConditions || section == kGiftCardSectionDescription || section == kGiftCardSectionAboutBrand) {
        return 10;
    }
    
    if (section == kGiftCardSectionSenderInfo && self.gifted) {
        return 0;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    //Set the background color of the View
    view.tintColor = [UIColor colorWithHexString:@"F7F7F7"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setStyling{

    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *brandSliderCellNib = [UINib nibWithNibName:@"BrandSliderCell" bundle:nil];
    [self.tableView registerNib:brandSliderCellNib forCellReuseIdentifier:@"BrandSliderCell"];
    
    UINib *brandCardTitleCellNib = [UINib nibWithNibName:@"BrandGiftPackageTitleTableViewCell" bundle:nil];
    [self.tableView registerNib:brandCardTitleCellNib forCellReuseIdentifier:@"BrandGiftPackageTitleCell"];
    
    UINib *validCellNib = [UINib nibWithNibName:@"BrandValidOptionTableViewCell" bundle:nil];
    [self.tableView registerNib:validCellNib forCellReuseIdentifier:@"ValidCell"];
    
    UINib *packageDescriptionNib = [UINib nibWithNibName:@"PackageBrandDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:packageDescriptionNib forCellReuseIdentifier:@"PackageBrandDetailCell"];
    
    UINib *redeemCellNib = [UINib nibWithNibName:@"GiftCardRedeemTableViewCell" bundle:nil];
    [self.tableView registerNib:redeemCellNib forCellReuseIdentifier:@"RedeemCell"];
    
    UINib *senderInfoCellNib = [UINib nibWithNibName:@"GiftSenderInfoTableViewCell" bundle:nil];
    [self.tableView registerNib:senderInfoCellNib forCellReuseIdentifier:@"SenderInfoCell"];
    
    UINib *aboutBrandCellNib = [UINib nibWithNibName:@"AboutBrandTableViewCell" bundle:nil];
    [self.tableView registerNib:aboutBrandCellNib forCellReuseIdentifier:@"AboutBrandCell"];
    self.heightAboutBrand = 150;
    
    UINib *tripAdvisorBrandNib = [UINib nibWithNibName:@"TripAdvisorBrandTableViewCell" bundle:nil];
    [self.tableView registerNib:tripAdvisorBrandNib forCellReuseIdentifier:@"TripAdvisorBrandCell"];
    
    UINib *infoBrandTableViewCellNib = [UINib nibWithNibName:@"InfoBrandTableViewCell" bundle:nil];
    [self.tableView registerNib:infoBrandTableViewCellNib forCellReuseIdentifier:@"InfoBrandCell"];
    
    UINib *markAsUnredeemedCellNib = [UINib nibWithNibName:@"MarkAsUnredeemedTableViewCell" bundle:nil];
    [self.tableView registerNib:markAsUnredeemedCellNib forCellReuseIdentifier:@"MarkAsUnredeemedCell"];
    
    self.headerLabel.text = [self.brand.name uppercaseString];
    
    UINib *redeemPopViewNib = [UINib nibWithNibName:@"FZRedeemPopView" bundle:nil];
    self.redeemPopView = [[redeemPopViewNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self.redeemPopView setRedeemNormalStyle];
    self.redeemPopView.delegate = self;
    [self.view addSubview:self.redeemPopView];
    self.redeemPopView.frame = self.view.frame;
    self.redeemPopView.hidden = YES;
    
    
}

#pragma mark - GiftCardRedeemTableViewCellDelegate

- (void)redeemButtonClicked{

    if (self.giftDict[@"online"] && [self.giftDict[@"online"] boolValue]) {
        
        [self showRedeemConfirm];
        
    } else{
        
        NSString *redeemType = self.serviceCardDict[@"redemption_type"];
        NSString *qrCode = self.giftDict[@"qr_code"];
        if (redeemType && ![redeemType isKindOfClass:[NSNull class]] && ([redeemType isEqualToString:@"qr_code"] || [redeemType isEqualToString:@"bar_code"]) && qrCode && ![qrCode isKindOfClass:[NSNull class]]) {
            
            [self showRedeemConfirm];
            
        } else {
            
            [self goRedeemPage];
        }
    }
}

- (void)showRedeemConfirm{
    
    NSDate *redeemStartDate = self.giftDict[@"redeem_timer_started_at"];
    
    if (redeemStartDate && ![redeemStartDate isEqual:[NSNull null]]) {
        
        [self goRedeemPage];
        
    } else {
        
        self.redeemPopView.hidden = NO;
        [self hidePopView];
        
    }
}

- (void)goRedeemPage{
    
    if (self.giftDict[@"online"] && [self.giftDict[@"online"] boolValue]) {
        
        OnlineGiftRedeemViewController *redeemView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"OnlineGiftRedeemView"];
        redeemView.giftDict = self.giftDict;
        [self.navigationController pushViewController:redeemView animated:YES];
        
    } else{
        
        PhysicalGiftRedeemViewController *redeemView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"PhysicalGiftRedeemView"];
        redeemView.giftDict = self.giftDict;
        [self.navigationController pushViewController:redeemView animated:YES];
    }
}

#pragma mark - AboutBrandTableViewCellDelegate

- (void)aboutBrandCell:(UITableViewCell *)aboutBrandCell tappedWithHeightCell:(int)heightCell{
    AboutBrandTableViewCell *aboutBrandTableViewCell = (AboutBrandTableViewCell*) aboutBrandCell;
    self.heightAboutBrand = heightCell;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [aboutBrandTableViewCell expandCellContent];
}

- (void) buttonSocialTapped:(NSInteger)buttonSocialType{
    NSString *urlString = nil;
    NSString *title = nil;
    
    if (buttonSocialType == AboutBrandButtonTypeFacebook) {
        urlString = self.brand.facebook;
        title = @"FACEBOOK";
    } else if (buttonSocialType == AboutBrandButtonTypeTwitter){
        urlString = self.brand.twitter;
        title = @"TWITTER";
    } else if(buttonSocialType == AboutBrandButtonTypeInstagram){
        urlString = self.brand.instagram;
        title = @"INSTAGRAM";
    } else if(buttonSocialType == AboutBrandButtonTypeWebsite){
        urlString = self.brand.website;
        title = self.brand.name;
        
    }
    if (urlString) {
        [self performSegueWithIdentifier:@"pushToWebview" sender:@{@"url":urlString,@"title":title}];
    }
    
}

#pragma mark - TripAdvisorTalbeViewCellDelegate

- (void)goToTripAdvisorPageWith:(NSString *)URL{
    [self performSegueWithIdentifier:@"pushToWebview" sender:@{@"url":URL,@"title":@"TRIPADVISOR"}];
}

#pragma mark - InfoBrandTableViewCellDelegate

- (void)cellInfoTapped:(NSUInteger)typeInfoCell{
    if (typeInfoCell == InfoBrandTypeCondition) {
        [self performSegueWithIdentifier:@"pushToTermConditions" sender:nil];
    } else if (typeInfoCell == InfoBrandTypeRedeem){
        [self performSegueWithIdentifier:@"pushToRedeem" sender:nil];
    } else if (typeInfoCell == InfoBrandTypeStoreLocator){
        
        StoreTableViewController *storeView = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreView"];
        storeView.brand = self.brand;
        [self.navigationController pushViewController:storeView animated:YES];
    }
}

#pragma mark - MarkAsUnredeemedTableViewCellDelegate
- (void)unredeemedTapped{
    
    [self showProcessing:YES];

    [GiftController markAsUnredeemedOnlineGift:self.giftDict[@"id"] withCompletion:^(NSDictionary *dictionary, NSError *error) {
        
        [self hidePopView];
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            [self showEmptyError:[error localizedDescription] window:YES];
        }
        
        if (dictionary && dictionary[@"gift"]) {
            
            [self showSuccess:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self hidePopView];
            });
            
            if ([self.giftDict[@"used"] boolValue]) {
                
                [GiftController getUsedGiftBox:1 withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:YES with:^(NSArray *array, NSError *error) {
                    if (!error) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:USED_GIFTBOX_REFRESHED object:nil];
                    }
                }];
                
                [GiftController getActiveGiftBox:1 withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:YES with:^(NSArray *array, NSError *error) {
                    if (!error) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
                    }
                }];
                
                // Increase Active Gift Count
                [UserController increaseActiveGiftCount:1];
                
            } else {
                
                [FZData replaceActiveGift:dictionary[@"gift"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
            }
            
            self.giftDict = dictionary[@"gift"];
            [self initData];
            [self.tableView reloadData];
            
        }
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat heightSlider = screenWidth * 0.75f - 64;
    
    
    int realPosition = scrollView.contentOffset.y+20;
    if (realPosition >= heightSlider) {
        float ratio = realPosition-heightSlider;
        double coef = MIN(1,ratio/32);
        self.backgroundNav.alpha = (float)coef;
    } else {
        self.backgroundNav.alpha = 0;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y < 0) {
        [self disableScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self enableScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y < 0) {
        [self disableScroll];
    }
}

- (void)enableScroll {
    self.tableView.scrollEnabled = YES;
}

- (void)disableScroll {
    self.tableView.scrollEnabled = YES;
}

#pragma mark - FZRedeemPopViewDelegate

- (void)redeemButtonPressed{
    
    self.redeemPopView.hidden = YES;

    [self showProcessing:YES];
    
    [GiftController markAsOpenedForGiftCard:self.giftDict withCompletion:^(NSDictionary *dictionary, NSError *error) {
        
        [self hidePopView];
        
        if (error) {
            
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            [self showEmptyError:[error localizedDescription] window:YES];
        }
        
        if (dictionary) {
            
            NSDictionary *giftDict =dictionary[@"gift"];
            
            if (giftDict) {
                
                [FZData replaceActiveGift:giftDict];
                self.giftDict = giftDict;
                [self initData];
                [self.tableView reloadData];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
                
                [self goRedeemPage];
            }
            
        }
        
    }];
    
}

- (void)cancelButtonPressed{
    self.redeemPopView.hidden = YES;
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"pushToRedeem"]) {
        if ([segue.destinationViewController isKindOfClass:[HowToRedeemViewController class]]) {
            HowToRedeemViewController *howToRedeemView = (HowToRedeemViewController*)segue.destinationViewController;
            howToRedeemView.brand = self.brand;
        }
    }
    
    if ([segue.identifier isEqualToString:@"pushToTermConditions"]) {
        if ([segue.destinationViewController isKindOfClass:[TermsAndConditionsTableViewController class]]) {
            TermsAndConditionsTableViewController *termConditionView = (TermsAndConditionsTableViewController*)segue.destinationViewController;
            if (self.serviceCardDict[@"terms_and_conditions_text"] && [self.serviceCardDict[@"terms_and_conditions_text"] isKindOfClass:[NSArray class]]) {
                termConditionView.termsConditions = self.serviceCardDict[@"terms_and_conditions_text"];
            }
        }
        
        
    }
    
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
}


@end
