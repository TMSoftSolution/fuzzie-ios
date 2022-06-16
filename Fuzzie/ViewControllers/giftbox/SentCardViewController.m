//
//  SentCardViewController.m
//  Fuzzie
//
//  Created by mac on 7/26/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "SentCardViewController.h"
#import "BrandSliderCell.h"
#import "BrandGiftCardTitleCell.h"
#import "SentCardActionTableViewCell.h"
#import "SentCardSenderInfoTableViewCell.h"
#import "DeliveryMethodViewController.h"
#import "GiftEditViewController.h"
#import "BrandValidOptionTableViewCell.h"

@interface SentCardViewController () <UITableViewDelegate, UITableViewDataSource, SentCardActionTableViewCellDelegate, SentCardSenderInfoTableViewCellDelegate>

@end

typedef enum : NSUInteger{
    kSentCardSectionBanner,
    kSentCardSectionTitle,
    kSentCardSectionSend,
    kSentCardSectionValid,
    kSentCardSectionSenderInfo,
    kSentCardSectionCount
    
    
} kSentCardSection;

@implementation SentCardViewController

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
    self.giftCardDict = self.giftDict[@"gift_card"];

}

- (void)updateSenderInfo:(NSNotification*)notification{
    
    NSDictionary *gift = [notification.userInfo valueForKey:@"gift"];
    if (gift) {
        self.giftDict = gift;
        [self.tableView reloadData];
    }
}

#pragma mark - TableViewDataSoruce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kSentCardSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == kSentCardSectionValid && self.brand.textOptionGiftCard.count < 1) {
        return 0;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kSentCardSectionBanner) {
        
        BrandSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandSliderCell" forIndexPath:indexPath];
        [cell setBrandInfo:self.brand withMode:BrandSliderCellModeGiftCard showSoldOut:false];
        [cell initSliderIfNeeded];
        return cell;
        
    } else if(indexPath.section == kSentCardSectionTitle){
        
        BrandGiftCardTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandGiftCardTitleCell" forIndexPath:indexPath];
        [cell setBrandInfo:self.brand withGiftCard:self.giftCardDict];
        return cell;
        
    } else if(indexPath.section == kSentCardSectionValid){
        
        BrandValidOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValidCell"];
        cell.options = self.brand.textOptionGiftCard;
         cell.bottomSeparator.hidden = NO;
        return cell;
        
        
    } else if(indexPath.section == kSentCardSectionSend){
        
        SentCardActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendActionCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setCellWith:self.giftDict];
        return cell;
        
    } else if (indexPath.section == kSentCardSectionSenderInfo){
        
        SentCardSenderInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenderInfoCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setCellWith:self.giftDict];
        return cell;
        
    } else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (indexPath.section == kSentCardSectionValid) {
        return 70.0f;
        
    }
    
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    //Set the background color of the View
    view.tintColor = [UIColor colorWithHexString:@"F7F7F7"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == kSentCardSectionSenderInfo) {
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
    if (section == kSentCardSectionSenderInfo) {
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

- (void)setStyling{
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    
    UINib *brandSliderCellNib = [UINib nibWithNibName:@"BrandSliderCell" bundle:nil];
    [self.tableView registerNib:brandSliderCellNib forCellReuseIdentifier:@"BrandSliderCell"];
    
    UINib *brandCardTitleCellNib = [UINib nibWithNibName:@"BrandGiftCardTitleCell" bundle:nil];
    [self.tableView registerNib:brandCardTitleCellNib forCellReuseIdentifier:@"BrandGiftCardTitleCell"];
    
    UINib *validCellNib = [UINib nibWithNibName:@"BrandValidOptionTableViewCell" bundle:nil];
    [self.tableView registerNib:validCellNib forCellReuseIdentifier:@"ValidCell"];
    
    UINib *sendActionCellNib = [UINib nibWithNibName:@"SentCardActionTableViewCell" bundle:nil];
    [self.tableView registerNib:sendActionCellNib forCellReuseIdentifier:@"SendActionCell"];
    
    UINib *senderInfoCellNib = [UINib nibWithNibName:@"SentCardSenderInfoTableViewCell" bundle:nil];
    [self.tableView registerNib:senderInfoCellNib forCellReuseIdentifier:@"SenderInfoCell"];
    
    self.headerLabel.text = [self.brand.name uppercaseString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
