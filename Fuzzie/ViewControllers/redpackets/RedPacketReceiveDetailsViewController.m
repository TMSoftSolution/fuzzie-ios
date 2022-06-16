//
//  RedPacketReceiveDetailsViewController.m
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketReceiveDetailsViewController.h"
#import "RedPacketReceiveDetailsInfoTableViewCell.h"
#import "RedPacketSentOpenedTableViewCell.h"

typedef enum : NSUInteger {
    kSectionInfo,
    kSectionOpened,
    kSectionCount,
} kSection;

@interface RedPacketReceiveDetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation RedPacketReceiveDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadRedPacketBundle];
    [self setStyling];
}

- (void)setStyling{
    
    UINib *infoNib = [UINib nibWithNibName:@"RedPacketReceiveDetailsInfoTableViewCell" bundle:nil];
    [self.tableView registerNib:infoNib forCellReuseIdentifier:@"InfoCell"];
    
    UINib *openedNib = [UINib nibWithNibName:@"RedPacketSentOpenedTableViewCell" bundle:nil];
    [self.tableView registerNib:openedNib forCellReuseIdentifier:@"OpenCell"];
    
}

- (void) loadRedPacketBundle{
    
    [RedPacketController getAssignedRedPackets:self.redPacket[@"red_packet_bundle_id"] completion:^(NSArray *array, NSError *error) {
        
        if (array) {
            
            self.usedRedPackets = [[NSMutableArray alloc] initWithArray:array];
            [self.usedRedPackets insertObject:self.redPacket atIndex:0];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == kSectionInfo) {
        
        return 1;
        
    } else if (section == kSectionOpened){
        
        return self.usedRedPackets.count;
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kSectionInfo) {
        
        RedPacketReceiveDetailsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
        [cell setCell:self.redPacket];
        return cell;
        
    } else if (indexPath.section == kSectionOpened){
        
        RedPacketSentOpenedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpenCell"];
        [cell setCell:[self.usedRedPackets objectAtIndex:indexPath.row] isMe:indexPath.row == 0];
        return cell;
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == kSectionOpened && self.usedRedPackets.count > 0) {
        
        return 40.0f;
        
    }
    
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == kSectionOpened) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, tableView.frame.size.width, 18)];
        [label setFont:[UIFont fontWithName:FONT_NAME_BLACK size:11]];
        NSString *string = @"LUCKY PACKETS SENT TO";
        
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


#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
