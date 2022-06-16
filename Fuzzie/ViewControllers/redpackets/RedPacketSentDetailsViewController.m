//
//  RedPacketSentDetailsViewController.m
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketSentDetailsViewController.h"
#import "RedPacketSendDetailsInfoTableViewCell.h"
#import "RedPacketSentUnopenedTableViewCell.h"
#import "RedPacketSentOpenedTableViewCell.h"
#import "RedPacketDeliveryViewController.h"

typedef enum : NSUInteger {
    kPacketDetailsSectionInfo,
    kPacketDetailsSectionUnopened,
    kPacketDetailsSectionOpened,
    kPacketDetailsSectionCount
} kPacketDetailsSection;

@interface RedPacketSentDetailsViewController () <UITableViewDataSource, UITableViewDelegate, RedPacketSentUnopenedTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation RedPacketSentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.dictionary) {
        
        [self initData];
        
    } else {
        
        if (self.bundleId) {
            
            [self loadRedPacketBundle];
            
        }
        
    }

    [self setStyling];
}

- (void)initData{
    
    self.openedRedPackcets = [[NSMutableArray alloc] init];
    
    if (self.dictionary) {
        
        NSArray *redPackets = self.dictionary[@"red_packets"];
        if (redPackets) {
            
            for (NSDictionary *redPacket in redPackets) {
                
                if (redPacket[@"used"] && [redPacket[@"used"] boolValue]) {
                    [self.openedRedPackcets addObject:redPacket];
                }
            }
        }
        
        self.allPacketsOpened = self.dictionary[@"all_packets_opened"] && [self.dictionary[@"all_packets_opened"] boolValue];
    }
}

- (void)setStyling{
    
    UINib *infoNib = [UINib nibWithNibName:@"RedPacketSendDetailsInfoTableViewCell" bundle:nil];
    [self.tableView registerNib:infoNib forCellReuseIdentifier:@"InfoCell"];
    
    UINib *unopenedNib = [UINib nibWithNibName:@"RedPacketSentUnopenedTableViewCell" bundle:nil];
    [self.tableView registerNib:unopenedNib forCellReuseIdentifier:@"UnopenedCell"];

    UINib *openedNib = [UINib nibWithNibName:@"RedPacketSentOpenedTableViewCell" bundle:nil];
    [self.tableView registerNib:openedNib forCellReuseIdentifier:@"OpenedCell"];
    
    // Setup Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadRedPacketBundle)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.refreshControl.tintColor = [UIColor clearColor];
}

- (void)loadRedPacketBundle{
    
    if (!self.bundleId) {
        self.bundleId = self.dictionary[@"id"];
    }
    [self showLoader];
    
    [RedPacketController getRedPacketBundle:self.bundleId completion:^(NSDictionary *dictionary, NSError *error) {
        
        [self hideLoader];
        [self.refreshControl endRefreshing];
        
        if (error) {

            [self showError:error.localizedDescription headerTitle:@"OOPS!" buttonTitle:@"OK" image:@"bear-dead" window:NO];
            
        } else {
            
            if (dictionary) {
                
                self.dictionary = dictionary;
                [self initData];
                [self.tableView reloadData];
                
            }
        }
        
    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kPacketDetailsSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == kPacketDetailsSectionInfo) {
        
        return 1;
        
    } else if (section == kPacketDetailsSectionUnopened){
        
        if (!self.allPacketsOpened) {
            
            return 1;
            
        } else {
            
            return 0;
            
        }
        
    } else if (section == kPacketDetailsSectionOpened){
        
        return self.openedRedPackcets.count;
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kPacketDetailsSectionInfo) {
        
        RedPacketSendDetailsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
        [cell setCell:self.dictionary];
        return cell;
        
    } else if (indexPath.section == kPacketDetailsSectionUnopened){
        
        RedPacketSentUnopenedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnopenedCell"];
        [cell setCell:self.dictionary];
        cell.bottomSeparator.hidden = self.openedRedPackcets.count != 0;
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == kPacketDetailsSectionOpened){
        
        RedPacketSentOpenedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpenedCell"];
        [cell setCellWith:[self.openedRedPackcets objectAtIndex:indexPath.row]];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == kPacketDetailsSectionOpened && self.openedRedPackcets && self.openedRedPackcets.count > 0) {
        
        return 40.0f;
        
    }
    
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == kPacketDetailsSectionOpened && self.openedRedPackcets && self.openedRedPackcets.count > 0) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, tableView.frame.size.width, 18)];
        [label setFont:[UIFont fontWithName:FONT_NAME_BLACK size:11]];
        NSString *string = @"FRIENDS WHO HAVE OPENED YOUR LUCKY PACKET";
        [label setText:string];
        [label setTextColor:[UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0]];
        [view addSubview:label];
        [view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
        
        UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
        [topSeparator setBackgroundColor:[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0]];
        [view addSubview:topSeparator];
        
        UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 39, tableView.frame.size.width, 1)];
        [bottomSeparator setBackgroundColor:[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0]];
        [view addSubview:bottomSeparator];
        
        return view;
        
    }
    
    return nil;
    
}

#pragma mark - RedPacketSentUnopenedTableViewCellDelegate
- (void)sendButtonPressed{
    
    if (self.dictionary) {
        
        RedPacketDeliveryViewController *deliveryView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketDeliveryView"];
        deliveryView.fromWalletPage = YES;
        deliveryView.dictionary = self.dictionary;
        [self.navigationController pushViewController:deliveryView animated:YES];
        
    }
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
