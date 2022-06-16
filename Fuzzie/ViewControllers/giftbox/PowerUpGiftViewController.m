//
//  PowerUpGiftViewController.m
//  Fuzzie
//
//  Created by Joma on 2/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "PowerUpGiftViewController.h"
#import "PowerUpPackPhotoCoverTableViewCell.h"
#import "PowerUpGiftTitleTableViewCell.h"
#import "PowerUpCardRedeemTableViewCell.h"
#import "JackpotCouponDescriptionTableViewCell.h"
#import "InfoBrandTableViewCell.h"
#import "BrandValidOptionTableViewCell.h"
#import "TermsAndConditionsTableViewController.h"
#import "HowToRedeemViewController.h"
#import "ActivateSuccessViewController.h"

typedef enum : NSUInteger{
    kGiftCardSectionPhotoCover,
    kGiftCardSectionCardTitle,
    kGiftCardSectionRedeem,
    kGiftCardSectionValid,
    kGiftCardSectionDescription,
    kGiftCardSectionInfoConditions,
    kGiftCardSectionInfoRedeem,
    kGiftCardSectionCount
    
} kGiftCardSection;

@interface PowerUpGiftViewController () <UITableViewDataSource, UITableViewDataSource, PowerUpCardRedeemTableViewCellDelegate, InfoBrandTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation PowerUpGiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setStyling];
}

- (void)initData{
    
    NSDictionary *couponTemplate = self.giftDict[@"jackpot_coupon_template"];
    if (couponTemplate) {
        
        NSError *error = nil;
        FZCoupon *coupon = [MTLJSONAdapter modelOfClass:FZCoupon.class fromJSONDictionary:couponTemplate error:&error];
        if (error) {
            DDLogError(@"FZCoupon Error: %@", [error localizedDescription]);
        } else if (coupon) {
            
            double pricePerTicket = ([coupon.priceValue doubleValue] - [coupon.cashbackValue doubleValue]) / [coupon.ticketCount intValue];
            coupon.pricePerTicket = [NSNumber numberWithDouble:pricePerTicket];
            
            self.coupon = coupon;
        }
    }
}

- (void)setStyling{

    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *photoCoverNib = [UINib nibWithNibName:@"PowerUpPackPhotoCoverTableViewCell" bundle:nil];
    [self.tableView registerNib:photoCoverNib forCellReuseIdentifier:@"PhotoCoverCell"];
    
    UINib *titleNib = [UINib nibWithNibName:@"PowerUpGiftTitleTableViewCell" bundle:nil];
    [self.tableView registerNib:titleNib forCellReuseIdentifier:@"TitleCell"];
    
    UINib *redeemCellNib = [UINib nibWithNibName:@"PowerUpCardRedeemTableViewCell" bundle:nil];
    [self.tableView registerNib:redeemCellNib forCellReuseIdentifier:@"RedeemCell"];
    
    UINib *valideNib = [UINib nibWithNibName:@"BrandValidOptionTableViewCell" bundle:nil];
    [self.tableView registerNib:valideNib forCellReuseIdentifier:@"ValidCell"];
    
    UINib *descNib = [UINib nibWithNibName:@"JackpotCouponDescriptionTableViewCell" bundle:nil];
    [self.tableView registerNib:descNib forCellReuseIdentifier:@"DescCell"];
    
    UINib *infoNib = [UINib nibWithNibName:@"InfoBrandTableViewCell" bundle:nil];
    [self.tableView registerNib:infoNib forCellReuseIdentifier:@"InfoBrandCell"];
}

#pragma mark - TableViewDataSoruce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kGiftCardSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == kGiftCardSectionValid && self.coupon.options.count < 1) {
        return 0;
        
    } else if (section == kGiftCardSectionDescription && self.coupon.about.length == 0){
        return 0;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kGiftCardSectionPhotoCover) {
        
        PowerUpPackPhotoCoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCoverCell"];
        [cell setCellWith:self.giftDict];
        return cell;
        
    } else if (indexPath.section == kGiftCardSectionCardTitle){
        
        PowerUpGiftTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        [cell setCell:self.giftDict];
        return cell;
    
    } else if(indexPath.section == kGiftCardSectionRedeem){
        PowerUpCardRedeemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedeemCell" forIndexPath:indexPath];
        [cell setCellWith:self.giftDict];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == kGiftCardSectionValid) {
        
        BrandValidOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValidCell"];
        cell.options = self.coupon.options;
        return cell;
        
    }  else if (indexPath.section == kGiftCardSectionDescription){
        
        JackpotCouponDescriptionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DescCell"];
        [cell setCell:self.coupon.about];
        return cell;
        
    } else if (indexPath.section == kGiftCardSectionInfoConditions) {
        
        InfoBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoBrandCell"];
        cell.topSeparator.hidden = NO;
        cell.bottomSeparator.hidden = YES;
        cell.typeCell = InfoBrandTypeCondition;
        cell.delegate = self;
        cell.infoBrandLabel.text = @"Terms and conditions";
        [cell.ivIcon setImage:[UIImage imageNamed:@"icon-terms-condition"]];
        return cell;
        
    } else if (indexPath.section == kGiftCardSectionInfoRedeem) {
        
        InfoBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoBrandCell" forIndexPath:indexPath];
        cell.topSeparator.hidden = YES;
        cell.bottomSeparator.hidden = NO;
        cell.typeCell = InfoBrandTypeRedeem;
        cell.delegate = self;
        cell.infoBrandLabel.text = @"How to redeem";
        [cell.ivIcon setImage:[UIImage imageNamed:@"icon-how-to-redeem"]];
        return cell;
        
    } else {
        
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == kGiftCardSectionPhotoCover) {
    
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        return screenWidth * 0.75f;
    
    } else if (indexPath.section == kGiftCardSectionInfoConditions ||
               indexPath.section == kGiftCardSectionInfoRedeem) {
        return 62.0f;
        
    } else if (indexPath.section == kGiftCardSectionValid) {
        return 70.0f;
        
    }
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == kGiftCardSectionDescription && self.coupon) {
        
        NSString *description = self.coupon.about;
        
        if (description.length == 0) {
            return 0.0f;
        } else{
            return 10.0f;
        }
    }
    
    if (section == kGiftCardSectionInfoConditions){
        return 10.0f;
    }
 
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    //Set the background color of the View
    view.tintColor = [UIColor colorWithHexString:@"F7F7F7"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == kGiftCardSectionInfoRedeem) {
        return 10.0f;
    }
    
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    //Set the background color of the View
    view.tintColor = [UIColor colorWithHexString:@"F7F7F7"];
}

#pragma mark - GiftCardRedeemTableViewCellDelegate

- (void)activateButtonPressed{
    
    if ([UserController sharedInstance].currentUser && [UserController sharedInstance].currentUser.powerUpExpiryDate) {
        
        [self showError:@"You have another Power Up in session, which this activation will override. Do you wish to  continue?" headerTitle:@"HANG ON!" buttonTitle:@"YES, ACTIVATE" image:@"icon-power-up-card" window:YES];
        self.popView.btnCancel.hidden = NO;
        
    } else {
        
        int powerUpHour = [self.giftDict[@"time_to_expire"] intValue];
        NSString *powerUpHourString = @"";
        if (powerUpHour > 1) {
            powerUpHourString = [NSString stringWithFormat:@"%d hours.", powerUpHour];
        } else {
            powerUpHourString = [NSString stringWithFormat:@"%d hour.", powerUpHour];
        }
        
        NSString *string = [NSString stringWithFormat:@"After activation, all brands will be powered up for %@", powerUpHourString];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BOLD
                                                                                 size:14.0f] range:[string rangeOfString:powerUpHourString]];
        [self showErrorWith:attributedString headerTitle:@"ARE YOU SURE?" buttonTitle:@"ACTIVATE NOW" image:@"icon-power-up-card" window:YES];
        self.popView.btnCancel.hidden = NO;
        
    }
    
    self.isPowerUpPack = true;
}

#pragma mark - InfoBrandTableViewCellDelegate
- (void)cellInfoTapped:(NSUInteger)typeInfoCell{
    
    if (typeInfoCell == InfoBrandTypeCondition) {
        
        TermsAndConditionsTableViewController *termsView = (TermsAndConditionsTableViewController *)[[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"TermsAndConditionsView"];
        if (self.coupon) {
            termsView.termsConditions = self.coupon.terms;
        }
        
        [self.navigationController pushViewController:termsView animated:YES];
    }
    
    if (typeInfoCell == InfoBrandTypeRedeem) {
        
        HowToRedeemViewController *redeemView = (HowToRedeemViewController *)[[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"HowToRedeemView"];
        redeemView.isPowerUp = true;
        [self.navigationController pushViewController:redeemView animated:YES];
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

#pragma mark - FZPopViewDelegate
- (void)okButtonClicked{
    [super okButtonClicked];
    
    if (self.isPowerUpPack){
        
        self.isPowerUpPack = false;
        [self activatePowerUpPack];
    }
}

- (void)cancelButtonClicked{
    [super cancelButtonClicked];
    
    self.isPowerUpPack = false;
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)activatePowerUpPack{
    
    [self showProcessing:YES];
    
    [GiftController redeemPowerUpGiftCard:self.giftDict[@"id"] withSuccess:^(NSDictionary *dictionary) {
        
        [self hidePopView];
        
        // Remove This Gift from ActiveGifts
        [FZData removeActiveGift:self.giftDict];
        [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
        
        // Decrease Active Gift Count
        [UserController decreaseActiveGiftCount:1];
        
        [GiftController getUsedGiftBox:1 withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:YES with:^(NSArray *array, NSError *error) {
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:USED_GIFTBOX_REFRESHED object:nil];
            }
        }];
        
        ActivateSuccessViewController *successView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"ActivateSuccessView"];
        successView.successDict = dictionary;
        successView.fromPowerUpPack = YES;
        [self.navigationController pushViewController:successView animated:YES];
        
    } failure:^(NSError *error) {
        
        [self showFail:[error localizedDescription] buttonTitle:@"GOT IT" window:YES];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
