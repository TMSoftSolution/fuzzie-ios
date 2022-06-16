//
//  PowerUpPackCardViewController.m
//  Fuzzie
//
//  Created by Joma on 2/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "PowerUpPackCardViewController.h"
#import "PowerUpPackPhotoCoverTableViewCell.h"
#import "JackpotCouponTitleTableViewCell.h"
#import "PowerUpRewardTableViewCell.h"
#import "RedeemValidTableViewCell.h"
#import "BrandValidOptionTableViewCell.h"
#import "JackpotCouponDescriptionTableViewCell.h"
#import "InfoBrandTableViewCell.h"
#import "CashbackViewController.h"
#import "TermsAndConditionsTableViewController.h"
#import "JackpotPayViewController.h"
#import "HowToRedeemViewController.h"
#import "PowerUpPreviewTableViewCell.h"
#import "PackageListViewController.h"
#import "CardViewController.h"
#import "PackageViewController.h"

typedef enum : NSUInteger {
    kCouponSectionPhotoCover,
    kCouponSectionTitle,
    kCouponSectionTicket,
    kCouponSectionRedeemValid,
    kCouponSectionValidOption,
    kCouponSectionDescription,
    kCouponSectionTerms,
    kCouponSectionRedeem,
    kCouponSectionPreview,
    kCouponSectionCount
} kCouponSection;

@interface PowerUpPackCardViewController () <UITableViewDelegate, UITableViewDataSource, PowerUpRewardTableViewCellDelegate, InfoBrandTableViewCellDelegate, PowerUpPreviewTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonPressed:(id)sender;
@end

@implementation PowerUpPackCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{

    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *photoCoverNib = [UINib nibWithNibName:@"PowerUpPackPhotoCoverTableViewCell" bundle:nil];
    [self.tableView registerNib:photoCoverNib forCellReuseIdentifier:@"PhotoCoverCell"];
    
    UINib *titleNib = [UINib nibWithNibName:@"JackpotCouponTitleTableViewCell" bundle:nil];
    [self.tableView registerNib:titleNib forCellReuseIdentifier:@"TitleCell"];
    
    UINib *valideNib = [UINib nibWithNibName:@"BrandValidOptionTableViewCell" bundle:nil];
    [self.tableView registerNib:valideNib forCellReuseIdentifier:@"ValidCell"];
    
    UINib *ticketNib = [UINib nibWithNibName:@"PowerUpRewardTableViewCell" bundle:nil];
    [self.tableView registerNib:ticketNib forCellReuseIdentifier:@"RewardCell"];
    
    UINib *redeemValidCellNib = [UINib nibWithNibName:@"RedeemValidTableViewCell" bundle:nil];
    [self.tableView registerNib:redeemValidCellNib forCellReuseIdentifier:@"RedeemValidCell"];
    
    UINib *descNib = [UINib nibWithNibName:@"JackpotCouponDescriptionTableViewCell" bundle:nil];
    [self.tableView registerNib:descNib forCellReuseIdentifier:@"DescCell"];
    
    UINib *infoNib = [UINib nibWithNibName:@"InfoBrandTableViewCell" bundle:nil];
    [self.tableView registerNib:infoNib forCellReuseIdentifier:@"InfoBrandCell"];
    
    UINib *previeNib = [UINib nibWithNibName:@"PowerUpPreviewTableViewCell" bundle:nil];
    [self.tableView registerNib:previeNib forCellReuseIdentifier:@"PreviewCell"];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kCouponSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == kCouponSectionValidOption && self.coupon.options.count < 1) {
        return 0;
        
    } else if (section == kCouponSectionDescription && self.coupon.about.length == 0){
        return 0;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kCouponSectionPhotoCover) {
        
        PowerUpPackPhotoCoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCoverCell"];
        [cell setCell:self.coupon];
        return cell;
        
    } else if (indexPath.section == kCouponSectionTitle){
        
        JackpotCouponTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        [cell setBrandInfo:self.brand coupon:self.coupon isPowerUpPackMode:true];
        return cell;
        
    } else if (indexPath.section == kCouponSectionTicket){
        
        PowerUpRewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardCell"];
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
        return cell;
        
    } else if (indexPath.section == kCouponSectionDescription){
        
        JackpotCouponDescriptionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DescCell"];
        [cell setCell:self.coupon.about];
        return cell;
        
    } else if (indexPath.section == kCouponSectionTerms) {
        
        InfoBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoBrandCell"];
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
        
    } else if (indexPath.section == kCouponSectionPreview){
        
        PowerUpPreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PreviewCell"];
        cell.delegate = self;
        return cell;
        
    } else {
        
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == kCouponSectionPhotoCover) {
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        return screenWidth * 0.75f;
        
    } else if (indexPath.section == kCouponSectionValidOption) {
        return 70.0f;
        
    } else if (indexPath.section == kCouponSectionTerms ||
               indexPath.section == kCouponSectionRedeem) {
        return 62.0f;
        
    }
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == kCouponSectionDescription) {
        
        NSString *description = self.coupon.about;
        
        if (description.length == 0) {
            return 0.0f;
        } else{
            return 10.0f;
        }
    } else if (section == kCouponSectionTerms){
        return 10.0f;
        
    } else if (section == kCouponSectionPreview){
        return 10.0f;
        
    }

    return 0.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    //Set the background color of the View
    view.tintColor = [UIColor colorWithHexString:@"F7F7F7"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == kCouponSectionPreview) {
        return 10.0f;
    }
    
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    //Set the background color of the View
    view.tintColor = [UIColor colorWithHexString:@"F7F7F7"];
}


#pragma mark - PowerUpRewardTableViewCellDelegate
- (void)chooseButtonPressed:(FZCoupon *)coupon{
    [self chooseCoupon];
}

- (void)learnMoreButtonPressed{

    UIViewController *cashbackView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"CashbackView"];
    cashbackView.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:cashbackView animated:YES completion:nil];
    
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
        redeemView.isPowerUp = true;
        
        [self.navigationController pushViewController:redeemView animated:YES];
    }
}

#pragma mark - BrandListCollectionViewCellDelegate
- (void)brandWasClicked:(FZBrand *)brand {
    
    if (brand.giftCards && brand.giftCards.count > 0 && brand.services && brand.services.count > 0) {

        PackageListViewController *packageListView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"PackageListView"];
        packageListView.brand = brand;
        [self.navigationController pushViewController:packageListView animated:YES];
        
    } else if (brand.giftCards && brand.giftCards.count > 0) {
        
        CardViewController *cardView = [[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"CardViewController"];
        cardView.brand = brand;
        [self.navigationController pushViewController:cardView animated:YES];
        
    } else if (brand.services && brand.services.count == 1) {
        
        NSDictionary *packageDict = [brand.services firstObject];
        
        PackageViewController *packageView = [[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"PackageViewController"];
        packageView.brand = brand;
        packageView.packageDict = packageDict;
        [self.navigationController pushViewController:packageView animated:YES];

        
    } else if (brand.services && brand.services.count > 1) {

        PackageListViewController *packageListView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"PackageListView"];
        packageListView.brand = brand;
        [self.navigationController pushViewController:packageListView animated:YES];
        
    }
}

- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state {
    [self likeBrand:brand withState:state];
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

- (void) chooseCoupon{

    JackpotPayViewController *payView = [[GlobalConstants paymentStoryboard] instantiateViewControllerWithIdentifier:@"JackpotPayView"];
    payView.coupon = self.coupon;
    [self.navigationController pushViewController:payView animated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
