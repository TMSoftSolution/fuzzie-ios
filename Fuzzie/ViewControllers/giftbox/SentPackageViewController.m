//
//  SentPackageViewController.m
//  Fuzzie
//
//  Created by mac on 7/26/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "SentPackageViewController.h"
#import "BrandSliderCell.h"
#import "BrandGiftPackageTitleTableViewCell.h"
#import "SentCardActionTableViewCell.h"
#import "SentCardSenderInfoTableViewCell.h"
#import "DeliveryMethodViewController.h"
#import "GiftEditViewController.h"
#import "BrandValidOptionTableViewCell.h"

@interface SentPackageViewController () <UITableViewDelegate, UITableViewDataSource, SentCardActionTableViewCellDelegate, SentCardSenderInfoTableViewCellDelegate>

@end

typedef enum : NSUInteger{
    kSentPackageSectionBanner,
    kSentPackageSectionTitle,
    kSentPackageSectionSend,
    kSentPackageSectionValid,
    kSentPackageSectionSenderInfo,
    kSentPackageSectionCount
    
    
} kSentPackageSection;

@implementation SentPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSenderInfo:) name:SENT_GIFT_UPDATED object:nil];
    
    [self initData];
    [self setStyling];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
}

- (void)updateSenderInfo:(NSNotification*)notification{
    
    NSDictionary *gift = [notification.userInfo valueForKey:@"gift"];
    if (gift) {
        self.giftDict = gift;
        [self.tableView reloadData];
    }
}

- (void)setStyling{

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    
    UINib *brandSliderCellNib = [UINib nibWithNibName:@"BrandSliderCell" bundle:nil];
    [self.tableView registerNib:brandSliderCellNib forCellReuseIdentifier:@"BrandSliderCell"];
    
    UINib *brandCardTitleCellNib = [UINib nibWithNibName:@"BrandGiftPackageTitleTableViewCell" bundle:nil];
    [self.tableView registerNib:brandCardTitleCellNib forCellReuseIdentifier:@"BrandGiftPackageTitleCell"];
    
    UINib *validCellNib = [UINib nibWithNibName:@"BrandValidOptionTableViewCell" bundle:nil];
    [self.tableView registerNib:validCellNib forCellReuseIdentifier:@"ValidCell"];
    
    UINib *sendActionCellNib = [UINib nibWithNibName:@"SentCardActionTableViewCell" bundle:nil];
    [self.tableView registerNib:sendActionCellNib forCellReuseIdentifier:@"SendActionCell"];
    
    UINib *senderInfoCellNib = [UINib nibWithNibName:@"SentCardSenderInfoTableViewCell" bundle:nil];
    [self.tableView registerNib:senderInfoCellNib forCellReuseIdentifier:@"SenderInfoCell"];
    
    self.headerLabel.text = [self.brand.name uppercaseString];
}

#pragma mark - TableViewDataSoruce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kSentPackageSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == kSentPackageSectionValid && self.brand.textOptionGiftCard.count < 1) {
        return 0;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kSentPackageSectionBanner) {
        
        BrandSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandSliderCell" forIndexPath:indexPath];
        [cell initSliderIfNeeded];
        [cell setBrandInfo:self.brand withMode:BrandSliderCellModePackage package:self.serviceCardDict showSoldOut:false];
        return cell;
        
    } else if(indexPath.section == kSentPackageSectionTitle){
        
        BrandGiftPackageTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandGiftPackageTitleCell" forIndexPath:indexPath];
        [cell setBrandInfo:self.brand andPackageInfo:self.serviceCardDict];
        return cell;
        
    } else if(indexPath.section == kSentPackageSectionValid){
        
        BrandValidOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValidCell"];
        cell.options = self.brand.textOptionGiftCard;
        cell.bottomSeparator.hidden = NO;
        return cell;
        
    } else if(indexPath.section == kSentPackageSectionSend){
        
        SentCardActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendActionCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setCellWith:self.giftDict];
        return cell;
        
    } else if (indexPath.section == kSentPackageSectionSenderInfo){
        SentCardSenderInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenderInfoCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setCellWith:self.giftDict];
        return cell;
        
    } else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kSentPackageSectionValid) {
        return 70.0f;
        
    }
    
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    //Set the background color of the View
    view.tintColor = [UIColor colorWithHexString:@"F7F7F7"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == kSentPackageSectionSenderInfo) {
        return 10;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    //Set the background color of the View
    view.tintColor = [UIColor colorWithHexString:@"F7F7F7"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == kSentPackageSectionSenderInfo) {
        return 10;
    }
    return 0;
}

#pragma mark - SentCardActionTableViewCellDelegate
- (void)sendButtonPressed{
    
    NSDictionary *dict = self.giftDict[@"receiver"];
    NSError *error = nil;
    FZFacebookFriend *receiver = [MTLJSONAdapter modelOfClass:FZFacebookFriend.class fromJSONDictionary:dict error:&error];
    if (!error) {
        DeliveryMethodViewController *deliveryView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"DeliveryMethodView"];
        deliveryView.giftDict = self.giftDict;
        deliveryView.receiver = receiver;
        deliveryView.showBack = YES;
        [self.navigationController pushViewController:deliveryView animated:YES];
        
    }
}

#pragma mark - SentCardSenderInfoTableViewCellDelegate
- (void)editButtonPressed{
    GiftEditViewController *giftEditView = (GiftEditViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"GiftEditView"];
    giftEditView.giftDict = [[NSMutableDictionary alloc] initWithDictionary:self.giftDict];
    [self.navigationController pushViewController:giftEditView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
