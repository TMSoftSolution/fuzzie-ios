//
//  RedPacketHistoryViewController.m
//  Fuzzie
//
//  Created by Joma on 2/21/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketHistoryViewController.h"
#import "RedPacketCollectedTableViewCell.h"
#import "RedPacketHistoryReceiveTableViewCell.h"
#import "RedPacketHisotrySentTableViewCell.h"
#import "RedPacketSentDetailsViewController.h"
#import "RedPacketOpenViewController.h"
#import "RedPacketReceiveDetailsViewController.h"

typedef enum : NSUInteger {
    kHistoryReceived,
    kHistorySent
} kHistory;

typedef enum : NSUInteger {
    kRedPacketTypeTotalLuck,
    kRedPacketTypeUnopened,
    kRedPacketTypeOpened,
    kRedPacketTypeCount,
} kRedPacketType;

@interface RedPacketHistoryViewController () <UITableViewDataSource, UITableViewDelegate, RedPacketHistoryReceiveTableViewCellDelegate, RedPacketHisotrySentTableViewCellDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *segmentButtons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIImageView *ivEmpty;
@property (weak, nonatomic) IBOutlet UILabel *lbEmpty;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL loaderShowing;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)segmentButtonPressed:(id)sender;

@property (assign, nonatomic) kHistory currentSegment;

@property (strong, nonatomic) NSMutableArray *unopenedRedPackets;
@property (strong, nonatomic) NSMutableArray *openedRedPackets;
@property (strong, nonatomic) NSMutableArray *unopenedRedPacketBundles;
@property (strong, nonatomic) NSMutableArray *openedRedPacketBundles;
@property (assign, nonatomic) CGFloat totalLuck;
@property (assign, nonatomic) int totalTickets;

@end

@implementation RedPacketHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRedPacketRefreshed) name:RECEIVED_RED_PACKETS_REFRESHED object:nil];
    
    [self setStyling];
    [self initData];
}

- (void)initData{
    
    self.totalLuck = 0.0f;
    self.totalTickets = 0;
    
    if (![FZData sharedInstance].receivedRedPackets) {
        [self loadReceivedRedPackets];
    } else{
        [self groupRedPackets];
        [self showRedPackets];
    }
    
    if (![FZData sharedInstance].sentRedPacketBundles) {
        [self loadSentRedPacketBundles];
    } else {
        [self groupSentRedPacketBundles];
        [self showRedPackets];
    }
}

- (void)setStyling{

    if (self.fromDelivery) {
        
        [self segmentButtonPressed:self.segmentButtons[1]];
        
    } else{
        
        [self segmentButtonPressed:self.segmentButtons[0]];
        
    }
    
    for (UIButton *button in self.segmentButtons) {
        
        if (button.tag != 0) {
            button.layer.borderWidth = 1.0f;
            button.layer.borderColor = [UIColor colorWithWhite:0.0f alpha:0.2f].CGColor;
        }
        button.layer.cornerRadius = 8.0f;
        button.layer.masksToBounds = YES;
    }
    
    UINib *collectNib = [UINib nibWithNibName:@"RedPacketCollectedTableViewCell" bundle:nil];
    [self.tableView registerNib:collectNib forCellReuseIdentifier:@"CollectCell"];
    
    UINib *receiveNib = [UINib nibWithNibName:@"RedPacketHistoryReceiveTableViewCell" bundle:nil];
    [self.tableView registerNib:receiveNib forCellReuseIdentifier:@"ReceiveCell"];
    
    UINib *sentNib = [UINib nibWithNibName:@"RedPacketHisotrySentTableViewCell" bundle:nil];
    [self.tableView registerNib:sentNib forCellReuseIdentifier:@"SentCell"];
    
    // Setup Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshButtonClicked:)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.refreshControl.tintColor = [UIColor clearColor];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    self.emptyView.hidden = YES;
}

- (IBAction)refreshButtonClicked:(id)sender {
    
    if (self.currentSegment == kHistoryReceived) {
        
        [self loadReceivedRedPackets];
        
    } else if (self.currentSegment == kHistorySent){
        
        [self loadSentRedPacketBundles];
        
    }
}

- (void)loadReceivedRedPackets{
    
    if (!self.loaderShowing) {
        [self showLoader];
        self.loaderShowing = YES;
    }
    
    [RedPacketController getReceivedRedPackets:^(NSArray *array, NSError *error) {
        
        [self.refreshControl endRefreshing];
        if (self.loaderShowing) {
            [self hideLoader];
            self.loaderShowing = NO;
        }
        
        if (array && array.count > 0) {
            
            [self groupRedPackets];
            [self showRedPackets];
            
        } else{
            
            [self showReceivedEmpty];
        }
    }];
}

- (void)loadSentRedPacketBundles{
    
    if (!self.loaderShowing) {
        [self showLoader];
        self.loaderShowing = YES;
    }
    
    [RedPacketController getSentRedPacketBundles:^(NSArray *array, NSError *error) {
        
        [self.refreshControl endRefreshing];
        if (self.loaderShowing) {
            [self hideLoader];
            self.loaderShowing = NO;
        }
        
        if (array && array.count > 0) {
            
            [self groupSentRedPacketBundles];
            [self showRedPackets];
            
        } else {
            
            [self showSentEmpty];
        }
    }];
}

- (void)groupRedPackets{
    
    self.totalLuck = 0.0f;
    self.totalTickets = 0;
    
    self.openedRedPackets = [[NSMutableArray alloc] init];
    self.unopenedRedPackets = [[NSMutableArray alloc] init];
    
    if ([FZData sharedInstance].receivedRedPackets && [FZData sharedInstance].receivedRedPackets.count > 0) {
        
        for (NSDictionary *redPacket in [FZData sharedInstance].receivedRedPackets) {
            
            if ([redPacket[@"used"] boolValue]) {
                
                [self.openedRedPackets addObject:redPacket];
                self.totalLuck = self.totalLuck + [redPacket[@"value"] floatValue];
                self.totalTickets = self.totalTickets + [redPacket[@"number_of_jackpot_tickets"] intValue];
                
            } else{
                
                [self.unopenedRedPackets addObject:redPacket];
                
            }
        }
    }
}

- (void)groupSentRedPacketBundles{
    
    self.openedRedPacketBundles = [[NSMutableArray alloc] init];
    self.unopenedRedPacketBundles = [[NSMutableArray alloc] init];
    
    if ([FZData sharedInstance].sentRedPacketBundles && [FZData sharedInstance].sentRedPacketBundles.count > 0) {
        
        for (NSDictionary *redPacketBundle in [FZData sharedInstance].sentRedPacketBundles) {
            
            if ([redPacketBundle[@"all_packets_opened"] boolValue]) {
                
                [self.openedRedPacketBundles addObject:redPacketBundle];
                
            } else {
                
                [self.unopenedRedPacketBundles addObject:redPacketBundle];
                
            }
        }
    }
}

- (void)receivedRedPacketRefreshed{
    
    [self groupRedPackets];
    [self showRedPackets];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kRedPacketTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == kRedPacketTypeTotalLuck) {
        
        switch (self.currentSegment) {
            case kHistoryReceived:
                return 1;
                break;
            case kHistorySent:
                return 0;
                break;
            default:
                return 0;
                break;
        }
        
    } else if (section == kRedPacketTypeUnopened){
        
        switch (self.currentSegment) {
            case kHistoryReceived:
                return self.unopenedRedPackets.count;
                break;
            case kHistorySent:
                return self.unopenedRedPacketBundles.count;
                break;
            default:
                return 0;
                break;
        }
        
    } else if (section == kRedPacketTypeOpened){
        
        switch (self.currentSegment) {
            case kHistoryReceived:
                return self.openedRedPackets.count;
                break;
            case kHistorySent:
                return self.openedRedPacketBundles.count;
                break;
            default:
                return 0;
                break;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kRedPacketTypeTotalLuck) {
        
        RedPacketCollectedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectCell"];
        [cell setCell:self.totalLuck ticket:self.totalTickets];
        return cell;
        
    } else if (indexPath.section == kRedPacketTypeUnopened){
        
        if (self.currentSegment == kHistoryReceived) {
            
            RedPacketHistoryReceiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveCell"];
            [cell setCell:[self.unopenedRedPackets objectAtIndex:indexPath.row]];
            cell.delegate = self;
            return cell;
            
        } else if (self.currentSegment == kHistorySent){
            
            RedPacketHisotrySentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SentCell"];
            cell.delegate = self;
            [cell setCell:[self.unopenedRedPacketBundles objectAtIndex:indexPath.row]];
            return cell;
            
        }
        
    } else if (indexPath.section == kRedPacketTypeOpened){
        
        if (self.currentSegment == kHistoryReceived) {
            
            RedPacketHistoryReceiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveCell"];
            [cell setCell:[self.openedRedPackets objectAtIndex:indexPath.row]];
            cell.delegate = self;
            return cell;
            
        } else if (self.currentSegment == kHistorySent){
            
            RedPacketHisotrySentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SentCell"];
            [cell setCell:[self.openedRedPacketBundles objectAtIndex:indexPath.row]];
            cell.delegate = self;
            return cell;
            
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kRedPacketTypeTotalLuck) {
        
        if (self.currentSegment == kHistoryReceived) {
            
            return 70.0f;
        }
        
    } else if (indexPath.section == kRedPacketTypeUnopened || indexPath.section == kRedPacketTypeOpened){
        
        return 70.0f;
        
    }
    
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case kRedPacketTypeTotalLuck:
            return 0.0f;
            break;
            
        case kRedPacketTypeUnopened:{
            
            if ((self.currentSegment == kHistoryReceived && self.unopenedRedPackets.count > 0) ||
                (self.currentSegment == kHistorySent && self.unopenedRedPacketBundles.count > 0)) {
                
                return 40.0f;
                
            } else {
                
                return 0.0f;
                
            }
            
            break;
        }
            
        case kRedPacketTypeOpened:{
            
            if ((self.currentSegment == kHistoryReceived && self.openedRedPackets.count > 0) ||
                (self.currentSegment == kHistorySent && self.openedRedPacketBundles.count > 0)) {
                
                return 40.0f;
                
            } else {
                
                return 0.0f;
                
            }
            break;
        }
            
        default:
            return 0.0f;
            break;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ((section == kRedPacketTypeUnopened && ((self.currentSegment == kHistoryReceived && self.unopenedRedPackets.count > 0) ||
                                               (self.currentSegment == kHistorySent && self.unopenedRedPacketBundles.count > 0)))
        || (section == kRedPacketTypeOpened && ((self.currentSegment == kHistoryReceived && self.openedRedPackets.count > 0) ||
                                                (self.currentSegment == kHistorySent && self.openedRedPacketBundles.count > 0)))) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, tableView.frame.size.width, 18)];
        [label setFont:[UIFont fontWithName:FONT_NAME_BLACK size:11]];
        NSString *string = @"";
        
        if (section == kRedPacketTypeUnopened) {
            if (self.currentSegment == kHistoryReceived) {
                string = @"TO OPEN";
            } else {
                string = @"NOT OPENED YET";
            }
        } else if (section == kRedPacketTypeOpened){
            string = @"OPENED";
        }
        
        [label setText:string];
        [label setTextColor:[UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0]];
        [view addSubview:label];
        [view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
        
        UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 39, tableView.frame.size.width, 1)];
        [bottomSeparator setBackgroundColor:[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0]];
        [view addSubview:bottomSeparator];
        
        return view;
        
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

#pragma mark - RedPacketHistoryReceiveTableViewCellDelegate
- (void)openButtonPressed:(NSDictionary *)redPacket{
    
    RedPacketOpenViewController *openView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketOpenView"];
    openView.redPacket = redPacket;
    [self.navigationController pushViewController:openView animated:YES];
    
}

- (void)receivedRedPacketPressed:(NSDictionary *)redPacket{
    
    RedPacketReceiveDetailsViewController *receiveDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketReceiveDetailsView"];
    receiveDetailsView.redPacket = redPacket;
    [self.navigationController pushViewController:receiveDetailsView animated:YES];
    
}

#pragma mark - RedPacketHisotrySentTableViewCellDelegate
- (void)sentRedPacketPressed:(NSDictionary *)redPacketBundle{
    
    RedPacketSentDetailsViewController *sentDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketSentDetailsView"];
    sentDetailsView.dictionary = redPacketBundle;
    [self.navigationController pushViewController:sentDetailsView animated:YES];
    
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentButtonPressed:(id)sender{
    
    UIButton *activeButton = (UIButton*)sender;
    self.currentSegment = activeButton.tag;
    
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
    
    [self showRedPackets];
    
}

- (void)showRedPackets{
    
    switch (self.currentSegment) {
            
        case kHistoryReceived:
        {
            if ([FZData sharedInstance].receivedRedPackets && [FZData sharedInstance].receivedRedPackets.count > 0) {
                
                self.emptyView.hidden = YES;
                self.tableView.hidden = NO;
                
                [self.tableView reloadData];
                
            } else{
                
                [self showReceivedEmpty];
            }
            
            break;
            
        }
            
        case kHistorySent:
        {
            if ([FZData sharedInstance].sentRedPacketBundles && [FZData sharedInstance].sentRedPacketBundles.count > 0) {
                
                self.emptyView.hidden = YES;
                self.tableView.hidden = NO;
                
                [self.tableView reloadData];
                
            } else{
                
                [self showSentEmpty];
            }
            
            break;
        }
            
        default:
            break;
    }
}

- (void)showReceivedEmpty{
    
    if (self.currentSegment == kHistoryReceived) {
        
        self.tableView.hidden = YES;
        self.emptyView.hidden = NO;
        
        self.lbEmpty.text = @"No Lucky Packets received yet.";
        self.ivEmpty.image = [UIImage imageNamed:@"bear-female-red"];
    }
}

- (void)showSentEmpty{
    
    if (self.currentSegment == kHistorySent) {
        
        self.tableView.hidden = YES;
        self.emptyView.hidden = NO;
        
        self.lbEmpty.text = @"No Lucky Packets sent yet.";
        self.ivEmpty.image = [UIImage imageNamed:@"bear-mustache"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

