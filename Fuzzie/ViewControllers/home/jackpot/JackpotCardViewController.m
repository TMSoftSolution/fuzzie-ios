//
//  JackpotCardViewController.m
//  Fuzzie
//
//  Created by mac on 9/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotCardViewController.h"
#import "JackpotConfirmViewController.h"
#import "BrandSliderCell.h"
#import "JackpotCouponTitleTableViewCell.h"
#import "ClubMemberExclusiveTableViewCell.h"
#import "JackpotCouponTicketTableViewCell.h"
#import "RedeemValidTableViewCell.h"
#import "BrandValidOptionTableViewCell.h"
#import "AboutBrandTableViewCell.h"
#import "FZWebView2Controller.h"
#import "JackpotCouponDescriptionTableViewCell.h"
#import "InfoBrandTableViewCell.h"
#import "StoreTableViewController.h"
#import "HowToRedeemViewController.h"
#import "TermsAndConditionsTableViewController.h"
#import "CashbackViewController.h"
#import "FZRedeemPopView.h"

typedef enum : NSUInteger {
    kCouponSectionBanner,
    kCouponSectionTitle,
    kCouponSectionClubExclusive,
    kCouponSectionTicket,
    kCouponSectionRedeemValid,
    kCouponSectionValidOption,
    kCouponSectionDescription,
    kCouponSectionAbout,
    kCouponSectionTerms,
    kCouponSectionStore,
    kCouponSectionRedeem,
    kCouponSectionCount
} kCouponSection;

@interface JackpotCardViewController () <UITableViewDataSource, UITableViewDelegate, JackpotCouponTicketTableViewCellDelegate, AboutBrandTableViewCellDelegate, InfoBrandTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) int heightAboutBrand;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation JackpotCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
 
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.headerLabel.text = [self.brand.name uppercaseString];
    
    UINib *brandSliderCellNib = [UINib nibWithNibName:@"BrandSliderCell" bundle:nil];
    [self.tableView registerNib:brandSliderCellNib forCellReuseIdentifier:@"BrandSliderCell"];
    
    UINib *titleNib = [UINib nibWithNibName:@"JackpotCouponTitleTableViewCell" bundle:nil];
    [self.tableView registerNib:titleNib forCellReuseIdentifier:@"TitleCell"];
    
    UINib *clubExclusiveNib = [UINib nibWithNibName:@"ClubMemberExclusiveTableViewCell" bundle:nil];
    [self.tableView registerNib:clubExclusiveNib forCellReuseIdentifier:@"ClubExclusiveCell"];
    
    UINib *ticketNib = [UINib nibWithNibName:@"JackpotCouponTicketTableViewCell" bundle:nil];
    [self.tableView registerNib:ticketNib forCellReuseIdentifier:@"TicketCell"];
    
    UINib *redeemValidCellNib = [UINib nibWithNibName:@"RedeemValidTableViewCell" bundle:nil];
    [self.tableView registerNib:redeemValidCellNib forCellReuseIdentifier:@"RedeemValidCell"];
    
    UINib *valideNib = [UINib nibWithNibName:@"BrandValidOptionTableViewCell" bundle:nil];
    [self.tableView registerNib:valideNib forCellReuseIdentifier:@"ValidCell"];
    
    UINib *descNib = [UINib nibWithNibName:@"JackpotCouponDescriptionTableViewCell" bundle:nil];
    [self.tableView registerNib:descNib forCellReuseIdentifier:@"DescCell"];
    
    UINib *aboutNib = [UINib nibWithNibName:@"AboutBrandTableViewCell" bundle:nil];
    [self.tableView registerNib:aboutNib forCellReuseIdentifier:@"AboutCell"];
    self.heightAboutBrand =  150;
    
    UINib *infoNib = [UINib nibWithNibName:@"InfoBrandTableViewCell" bundle:nil];
    [self.tableView registerNib:infoNib forCellReuseIdentifier:@"InfoBrandCell"];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kCouponSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == kCouponSectionClubExclusive) {
        
        if ([self.brand.isClubOnly boolValue]) {
            
            return 1;
            
        } else{
            
            return 0;
        }
        
    } else if (section == kCouponSectionValidOption && self.coupon.options.count == 0) {
        return 0;
        
    } else if (section == kCouponSectionDescription && self.coupon.about.length == 0){
        return 0;
        
    } else if (section == kCouponSectionStore && self.coupon.stores.count == 0){
        return 0;
        
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == kCouponSectionBanner) {
        
        BrandSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandSliderCell" forIndexPath:indexPath];
        [cell initSliderIfNeeded];
        [cell setBrandInfo:self.brand withMode:BrandSliderCellModeCoupon coupon:self.coupon];
        return cell;
        
    } else if (indexPath.section == kCouponSectionTitle){
        
        JackpotCouponTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        [cell setBrandInfo:self.brand coupon:self.coupon isPowerUpPackMode:false];
        return cell;
        
    } else if (indexPath.section == kCouponSectionClubExclusive){
        
        ClubMemberExclusiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubExclusiveCell"];
        
        return cell;
        
    } else if (indexPath.section == kCouponSectionTicket){
        
        JackpotCouponTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketCell"];
        cell.delegate = self;
        [cell setCell:self.brand coupon:self.coupon];
        return cell;
        
    } else if (indexPath.section == kCouponSectionRedeemValid){
        
        RedeemValidTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RedeemValidCell"];
        [cell setCell:self.coupon.redemptionEndDate];
        return cell;
        
    } else if (indexPath.section == kCouponSectionValidOption) {
        
        BrandValidOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValidCell"];
        cell.options = self.coupon.options;
        cell.bottomSeparator.hidden = NO;
        return cell;
        
    } else if (indexPath.section == kCouponSectionDescription){
        
        JackpotCouponDescriptionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DescCell"];
        [cell setCell:self.coupon.about];
        return cell;
        
    } else if (indexPath.section == kCouponSectionAbout){
        
        AboutBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutCell" forIndexPath:indexPath];
        cell.topSeparator.hidden = NO;
        cell.bottomSeparator.hidden = NO;
        cell.delegate = self;
        [cell setAboutBrandTextWithBrand:self.brand];
        return cell;
        
    } else if (indexPath.section == kCouponSectionTerms){
        
        InfoBrandTableViewCell *cell = (InfoBrandTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"InfoBrandCell"];
        cell.topSeparator.hidden = NO;
        cell.bottomSeparator.hidden = YES;
        cell.typeCell = InfoBrandTypeCondition;
        cell.delegate = self;
        cell.infoBrandLabel.text = @"Terms and conditions";
        [cell.ivIcon setImage:[UIImage imageNamed:@"icon-terms-condition"]];
        return cell;
        
    } else if (indexPath.section == kCouponSectionRedeem) {
        
        InfoBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoBrandCell" forIndexPath:indexPath];
        cell.topSeparator.hidden = YES;
        cell.bottomSeparator.hidden = NO;
        cell.typeCell = InfoBrandTypeRedeem;
        cell.delegate = self;
        cell.infoBrandLabel.text = @"How to redeem";
        [cell.ivIcon setImage:[UIImage imageNamed:@"icon-how-to-redeem"]];
        return cell;
        
    } else if (indexPath.section == kCouponSectionStore) {
        
        InfoBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoBrandCell" forIndexPath:indexPath];
        cell.topSeparator.hidden = YES;
        cell.bottomSeparator.hidden = YES;
        cell.delegate = self;
        cell.typeCell = InfoBrandTypeStoreLocator;
        cell.infoBrandLabel.text = @"Store location & contact";
        [cell.ivIcon setImage:[UIImage imageNamed:@"icon-store-location"]];
        return cell;
        
    } else {
        
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     if (indexPath.section == kCouponSectionValidOption) {
        return 70.0f;
        
    } else if (indexPath.section == kCouponSectionAbout) {
        return self.heightAboutBrand;
        
    } else if (indexPath.section == kCouponSectionTerms ||
               indexPath.section == kCouponSectionRedeem ||
               indexPath.section == kCouponSectionStore) {
        return 62.0f;
        
    }
    
    return UITableViewAutomaticDimension;
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == kCouponSectionDescription) {
        
        NSString *description = self.coupon.about;
        
        if (description.length == 0) {
            return 0.0f;
        } else{
            return 10.0f;
        }
    }
    
    if (section == kCouponSectionAbout) {
        
        return 10.0f;
    }
    
    if (section == kCouponSectionTerms){
        return 10.0f;
    }

    return 0.0f;
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    //Set the background color of the View
    view.tintColor = [UIColor colorWithHexString:@"F7F7F7"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == kCouponSectionRedeem) {
        return 10.0f;
    }
    
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    //Set the background color of the View
    view.tintColor = [UIColor colorWithHexString:@"F7F7F7"];
}

#pragma mark - JackpotCouponTicketTableViewCellDelegate
- (void)chooseButtonPressed:(FZCoupon *)coupon{
    [self chooseCoupon];
}

- (void)learnMoreButtonPressed{
   
    CashbackViewController *cashbackView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"CashbackView"];
    cashbackView.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:cashbackView animated:YES completion:nil];
    
}

#pragma - mark AboutBrandTableViewCellDelegate
- (void)aboutBrandCell:(UITableViewCell *)aboutBrandCell tappedWithHeightCell:(int)heightCell {
    NSLog(@"%i",heightCell);
    AboutBrandTableViewCell *aboutBrandCellCast = (AboutBrandTableViewCell *)aboutBrandCell;
    self.heightAboutBrand = heightCell;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [aboutBrandCellCast expandCellContent];
}

- (void)buttonSocialTapped:(NSInteger)buttonSocialType {
    
    NSString *urlString = nil;
    NSString *title = nil;
    if (buttonSocialType == AboutBrandButtonTypeFacebook) {
        urlString = self.brand.facebook;
        title = @"FACEBOOK";
    }
    
    if (buttonSocialType == AboutBrandButtonTypeTwitter) {
        urlString = self.brand.twitter;
        title = @"TWITTER";
    }
    
    if (buttonSocialType == AboutBrandButtonTypeInstagram) {
        urlString = self.brand.instagram;
        title = @"INSTAGRAM";
    }
    
    if (buttonSocialType == AboutBrandButtonTypeWebsite) {
        urlString = self.brand.website;
        title = self.brand.name;
    }
    
    if (urlString) {
        [self performSegueWithIdentifier:@"pushToWebview" sender:@{@"url":urlString,@"title":title}];
    }
    
}

#pragma mark - InfoBrandTableViewCellDelegate
- (void)cellInfoTapped:(NSUInteger)typeInfoCell{
    
    if (typeInfoCell == InfoBrandTypeCondition) {
    
        TermsAndConditionsTableViewController *termsView = [[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"TermsAndConditionsView"];
        termsView.termsConditions = self.coupon.terms;
        
        [self.navigationController pushViewController:termsView animated:YES];
    }
    
    if (typeInfoCell == InfoBrandTypeRedeem) {
        
        HowToRedeemViewController *redeemView = [[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"HowToRedeemView"];
        redeemView.brand = self.brand;
        
        [self.navigationController pushViewController:redeemView animated:YES];
    }
    
    if (typeInfoCell == InfoBrandTypeStoreLocator) {
        
        StoreTableViewController *storeView = [[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"StoreView"];
        storeView.storeArray = self.coupon.stores;
        
        [self.navigationController pushViewController:storeView animated:YES];
    }
}

#pragma - mark UIScrollView
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

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
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

- (void) chooseCoupon{
    
    if ([self.brand.isClubOnly boolValue]) {
        
        if ([[UserController sharedInstance].currentUser.clubMember boolValue]) {
            
            [self goJackpotConfirmPage];
            
        } else {
            
            [self showClubExclusiveView];
            
        }
        
    } else {
        
        [self goJackpotConfirmPage];
        
    }
}

- (void)goJackpotConfirmPage{
    
    JackpotConfirmViewController *confirmView = (JackpotConfirmViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"JackpotConfirmView"];
    confirmView.coupon = self.coupon;
    [self.navigationController pushViewController:confirmView animated:YES];
    
}

#pragma mark - ClubExclusiveViewDelegate
- (void)clubExclusiveViewExploreButtonPressed{
    
    [super clubExclusiveViewExploreButtonPressed];
    
    UIViewController *viewController = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubSubscribeView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
