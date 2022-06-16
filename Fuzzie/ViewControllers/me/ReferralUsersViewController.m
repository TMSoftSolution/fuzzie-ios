//
//  ReferralUsersViewController.m
//  Fuzzie
//
//  Created by mac on 6/5/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "ReferralUsersViewController.h"
#import "ReferralUsersTableViewCell.h"
#import "UserProfileViewController.h"

@interface ReferralUsersViewController () <UITableViewDelegate, UITableViewDataSource, ReferralUsersTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSMutableArray *sectionTitle;
@property (nonatomic, strong) NSMutableDictionary *sectionFriends;

@end

@implementation ReferralUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setStyling];
    [self loadReferralUsers];
}

- (void)initData{
    self.sectionTitle = [[NSMutableArray alloc] init];
    self.sectionFriends = [[NSMutableDictionary alloc] init];
}

- (void)setStyling{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadReferralUsers)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.refreshControl.tintColor = [UIColor lightGrayColor];

}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadReferralUsers{
    
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
    
    if (self.isClubReferral) {
        
        [self loadClubReferralUsers];
        
    } else {
        
        [self loadNormalReferralUsers];
    }
}

- (void)loadClubReferralUsers{
    
    [self showLoader];
    __weak __typeof__(self) weakSelf = self;
    [UserController getClubReferralUsers:^(NSArray *array, NSError *error) {
        
        [self hideLoader];
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
            }
        }
        
        if (array) {
            if ([array count] > 0) {
            
                [weakSelf sortFriends:array];
                self.tableView.hidden = NO;
                
            } else{
                self.tableView.hidden = YES;
            }
            
        }
    }];
}

- (void)loadNormalReferralUsers{
    
    [self showLoader];
    __weak __typeof__(self) weakSelf = self;
    [UserController getFriendReferralUsers:^(NSArray *array, NSError *error) {
        
        [self hideLoader];
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
            }
        }
        
        if (array) {
            if ([array count] > 0) {
                
                //http://stackoverflow.com/questions/11098959/can-you-use-nssortdescriptor-to-sort-by-a-value-not-being-null
                
                //                NSSortDescriptor* sortOrderByFriend = [NSSortDescriptor sortDescriptorWithKey: @"self.isFriend" ascending: NO];
                //                NSSortDescriptor* sortOrderPictureAvailable = [NSSortDescriptor sortDescriptorWithKey: @"self.profileImage" ascending: NO];
                //                NSSortDescriptor* sortOrderByBearAvatar = [NSSortDescriptor sortDescriptorWithKey: @"self.bearAvatar" ascending: NO];
                //
                //
                //                weakSelf.referralUsers = [array sortedArrayUsingDescriptors:
                //                                      @[sortOrderByFriend, sortOrderPictureAvailable, sortOrderByBearAvatar]];
                
                [weakSelf sortFriends:array];
                self.tableView.hidden = NO;
                
            } else{
                self.tableView.hidden = YES;
            }
            
        }
    }];
}

- (void)sortFriends:(NSArray*)array{
    for (FZUser *user in array) {
        if (![self.sectionTitle containsObject:user.status]) {
            [self.sectionTitle addObject:user.status];
        }
        
    }
    
    for (NSString *string in self.sectionTitle) {
        NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
        for (FZUser *user in array) {
            if ([user.status isEqualToString:string]) {
                [sectionArray addObject:user];
            }
        }
        [self.sectionFriends setValue:sectionArray forKey:string];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitle.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSArray *sectionArray = [self.sectionFriends objectForKey:[self.sectionTitle objectAtIndex:section]];
    if (sectionArray.count == 0) {
        return 0;
    } else{
        return 22;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 3, tableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:11]];
    NSString *string = @"";
    if ([[self.sectionTitle objectAtIndex:section] isEqualToString:@"referer_awarded_bonus"]) {
        
        string = @"SUCCESSFUL REFERRALS";
        
    } else {
        
        if (self.isClubReferral) {
            
            string = @"PENDING FIRST PURCHASE";
            
        } else {
            
          string = @"PENDING MINIMUM SPEND";
            
        }
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [string length])];
    
    [label setAttributedText:attributedString];
    [label setTextColor:[UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1.0]];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = [self.sectionFriends objectForKey:[self.sectionTitle objectAtIndex:section]];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReferralUsersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReferralUserCell" forIndexPath:indexPath];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ReferralUsersTableViewCell *userCell = (ReferralUsersTableViewCell *)cell;
    userCell.delegate = self;
    NSArray *sectionArray = [self.sectionFriends objectForKey:[self.sectionTitle objectAtIndex:indexPath.section]];
    [userCell setInfo:sectionArray[indexPath.row] isClubReferral:self.isClubReferral];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

#pragma -mark ReferralUsersTableViewCellDelegate

- (void)cellTapped:(FZUser *)userInfo {
    [self performSegueWithIdentifier:@"pushToUserProfile" sender:@{@"userInfo":userInfo}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToUserProfile"]) {
        if ([segue.destinationViewController isKindOfClass:[UserProfileViewController class]]) {
            UserProfileViewController *userProfileViewController = (UserProfileViewController *)segue.destinationViewController;
            if (sender){
                if ([sender isKindOfClass:[NSDictionary class]]) {
                    if ([sender[@"userInfo"] isKindOfClass:[FZUser class]]) {
                        userProfileViewController.userInfo = ((FZUser *)(NSDictionary *)sender[@"userInfo"]);
                    }
                }
            }
            
        }
    }
}


@end
