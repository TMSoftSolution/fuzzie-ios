//
//  ClubSettingViewController.m
//  Fuzzie
//
//  Created by joma on 6/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubSettingViewController.h"
#import "ClubSettingProfileTableViewCell.h"
#import "ClubOfferRedeemHistoryTableViewCell.h"

typedef enum : NSUInteger {
    kSectionProfile,
    kSectionRedeemHistory,
    kSectionCount,
} kSection;

@interface ClubSettingViewController () <UITableViewDelegate, UITableViewDataSource, ClubSettingProfileTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation ClubSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
    
    if ([FZData sharedInstance].redeemedClubOffers == nil) {
        
        [self loadRedeemedClubOffer];
    }
}

- (void)setStyling{
    
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *profileNib = [UINib nibWithNibName:@"ClubSettingProfileTableViewCell" bundle:nil];
    [self.tableView registerNib:profileNib forCellReuseIdentifier:@"ProfileCell"];
    
    UINib *historyNib = [UINib nibWithNibName:@"ClubOfferRedeemHistoryTableViewCell" bundle:nil];
    [self.tableView registerNib:historyNib forCellReuseIdentifier:@"HistoryCell"];
}

- (void)loadRedeemedClubOffer{
    
    [ClubController getRedeemedClubOffers:^(NSArray *array, NSError *error) {
        
        if (array) {
            
            [FZData sharedInstance].redeemedClubOffers = array;
        }
    }];
}

#pragma mark - UITableViewDataSource
-  (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case kSectionProfile:
            return 1;
            break;
        case kSectionRedeemHistory:
            return [FZData sharedInstance].redeemedClubOffers.count;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case kSectionProfile:
            return UITableViewAutomaticDimension;
            break;
        case kSectionRedeemHistory:
            return 105.0f;
            break;
        default:
            return UITableViewAutomaticDimension;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case kSectionRedeemHistory:
            return 40.0f;
            break;
            
        default:
            return 0.01f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case kSectionRedeemHistory:{
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
            [view setBackgroundColor:[UIColor clearColor]];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, tableView.frame.size.width, 16)];
            [label setFont:[UIFont fontWithName:FONT_NAME_BLACK size:11]];
            [label setText:[NSString stringWithFormat:@"OFFERS REDEEMED(%ld)", [FZData sharedInstance].redeemedClubOffers.count]];
            [label setTextColor:[UIColor colorWithHexString:@"9D9D9D"]];
            [view addSubview:label];
            
            UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 39, tableView.frame.size.width, 1)];
            [bottomSeparator setBackgroundColor:[UIColor colorWithHexString:@"E5E5E5"]];
            [view addSubview:bottomSeparator];
            
            return view;
            break;
        }
            
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case kSectionProfile:{
            
            ClubSettingProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
            cell.delegate = self;
            return cell;
            break;
        }
        case kSectionRedeemHistory:{
            
            ClubOfferRedeemHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
            [cell setCell:[FZData sharedInstance].redeemedClubOffers[indexPath.row]];
            return cell;
            break;
        }
        default:
            return nil;
            break;
    }
    
}

#pragma mark - ClubSettingProfileTableViewCellDelegate
- (void)extendButtonPressed{
    
    UIViewController *payView = [[GlobalConstants paymentStoryboard] instantiateViewControllerWithIdentifier:@"ClubSubscribePayView"];
    [self.navigationController pushViewController:payView animated:YES];
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
