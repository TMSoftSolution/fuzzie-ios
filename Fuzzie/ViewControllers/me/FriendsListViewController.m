//
//  FriendsListViewController.m
//  Fuzzie
//
//  Created by mac on 6/8/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FriendsListViewController.h"
#import "FriendsTableViewCell.h"
#import "UserProfileViewController.h"
#import "InviteFriendsViewController.h"
#import "FuzzieLoaderView.h"

typedef enum : NSUInteger {
    kSortByName,
    kSortByBirth
    
} kSort;

@interface FriendsListViewController () <UITableViewDelegate, UITableViewDataSource, FriendsTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *facebookView;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIView *friendsEmptyView;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *search;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionViewHeightAnchor;
@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet UIImageView *sortImageView;
@property (weak, nonatomic) IBOutlet UIView *searchTempView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noResultView;
@property (weak, nonatomic) IBOutlet UIImageView *ivBack;

@property (assign, nonatomic) kSort sort;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *sortedFriends;
@property (nonatomic, strong) NSArray *searchFriends;
@property (nonatomic, strong) NSMutableArray *sectionTitle;
@property (nonatomic, strong) NSMutableDictionary *sectionFriends;

@property (strong, nonatomic) FZUser *user;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)sortButtonPressed:(id)sender;
- (IBAction)searchButtonPressed:(id)sender;
- (IBAction)facebookButtonPressed:(id)sender;
- (IBAction)inviteButtonPressed:(id)sender;

@end

@implementation FriendsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.user = [UserController sharedInstance].currentUser;
    
    [self setStyling];
    if ([FZData sharedInstance].goFriendsListFromHome) {
        [self.ivBack setImage:[UIImage imageNamed:@"close-icon"]];
        [self fetchFriends];
    } else{
        [self.ivBack setImage:[UIImage imageNamed:@"back-icon"]];
        if (self.user.facebookId) {
            if ([FZData sharedInstance].fuzzieFriends) {
                if ([FZData sharedInstance].fuzzieFriends.count == 0) {
                    [self showFriendsEmptyView];
                } else{
                    [self showMainView];
                    self.friends = [FZData sharedInstance].fuzzieFriends;
                    [self sortByBirth];
                }
            } else{
                [self fetchFriends];
            }
            
        } else{
            [self showFacebookView];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchFriends{
    
    [self showLoader];
    __weak __typeof__(self) weakSelf = self;
    
    [UserController getMyFuzzieFriends:^(NSArray *array, NSError *error) {
        
        [self hideLoader];
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
            }
        }
        
        if (array) {
            
            if (array.count == 0) {
                [self showFriendsEmptyView];
            } else{
                [self showMainView];
                weakSelf.friends = array;
                [[FZData sharedInstance] setFuzzieFriends:array];
                [weakSelf sortByBirth];
            }
            
            
        }
    }];
}

#pragma mark - Button Action

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self tapCancel];
}

- (IBAction)sortButtonPressed:(id)sender {
    [self tapSort];
}

- (IBAction)searchButtonPressed:(id)sender {
    [self tapSearch];
}

- (IBAction)facebookButtonPressed:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    
    [login logInWithReadPermissions:@[@"public_profile",@"email",@"user_friends",@"user_birthday"]fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            
            [self showFail:[error localizedDescription] window:NO];
            
        } else if (result.isCancelled){
            
        } else{
            
            __weak __typeof__(self) weakSelf = self;
            [self showNormalWith:@"LOADING" window:NO];
            [[APIClient sharedInstance] setFacebookToken:[FBSDKAccessToken currentAccessToken].tokenString];
            [UserController getFacebookLinkedFuzzieUsers:^(NSArray *array, NSError *error) {
                [self hidePopView];
                
                if (error) {
                    if (error.code == 417) {
                        [AppDelegate logOut];
                    }
                } else{
                    
                    [UserController getUserProfileWithCompletion:nil];
                    
                    if (array) {
                        
                        if (array.count == 0) {
                            [self showFriendsEmptyView];
                        } else{
                            [self showMainView];
                            weakSelf.friends = array;
                            [[FZData sharedInstance] setFuzzieFriends:array];
                            [weakSelf sortByBirth];
                        }
                        
                        
                    }

                }
                
            }];
        }
    }];
}

- (IBAction)inviteButtonPressed:(id)sender {

    InviteFriendsViewController *inviteView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"InviteFriendsView"];
    [self.navigationController pushViewController:inviteView animated:YES];
}

- (void)tapSort{
    switch (self.sort) {
        case kSortByName:
            self.sort = kSortByBirth;
            [self sortByBirth];
            break;
            
        case kSortByBirth:
            self.sort = kSortByName;
            [self sortByName];
            break;
            
        default:
            break;
    }
}

- (void)sortByName{
    
    [self.sortImageView setImage:[UIImage imageNamed:@"birthday-icon"]];
    
    NSSortDescriptor* sortOrderByName = [NSSortDescriptor sortDescriptorWithKey: @"self.name" ascending: YES];
    self.sortedFriends = [self.friends sortedArrayUsingDescriptors:
                              @[sortOrderByName]];
    self.searchFriends = self.sortedFriends;
    
    [self setSearchArrayByName];
    [self.tableView reloadData];
}

- (void)setSearchArrayByName{
    self.sectionTitle = [[NSMutableArray alloc] init];
    self.sectionFriends = [[NSMutableDictionary alloc] init];
    
    for (FZUser *user in self.searchFriends){
        NSString *prefix = [[user.name substringToIndex:1] lowercaseString];
        if (![self.sectionTitle containsObject:[prefix uppercaseString]]) {
            [self.sectionTitle addObject:[prefix uppercaseString]];
        }
    }
    
    for (NSString *prefix in self.sectionTitle) {
        NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
        for (FZUser *user in self.searchFriends) {
            if ([[[user.name substringToIndex:1] lowercaseString] isEqualToString:[prefix lowercaseString]]) {
                [sectionArray addObject:user];
            }
        }
        
        [self.sectionFriends setValue:sectionArray forKey:prefix];
    }
}

- (void)sortByBirth{
    [self.sortImageView setImage:[UIImage imageNamed:@"alphabetical-icon"]];
    self.sortedFriends = self.friends;
    self.searchFriends = self.sortedFriends;

    [self setSearchArrayByBirth];
    [self.tableView reloadData];

}

- (void)setSearchArrayByBirth{
    self.sectionTitle = [[NSMutableArray alloc] init];
    self.sectionFriends = [[NSMutableDictionary alloc] init];
    
    for (int i = 0 ; i < MONTHS.count + 1 ; i ++){
        
        NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
        NSDate *now = [NSDate date];
        
        for (FZUser *user in self.searchFriends) {
            
            NSDate *birthdayDate = [GlobalConstants.dateApiFormatter dateFromString:user.birthday];
            
            if (i == 0) {
                if (![self.sectionTitle containsObject:@"BIRTHDAYS TODAY"]) {
                    [self.sectionTitle addObject:@"BIRTHDAYS TODAY"];
                }
                if (([now month] == [birthdayDate month]) && ([now day] == [birthdayDate day])) {
                    [sectionArray addObject:user];
                }
            } else if (i == 1) {
                if (![self.sectionTitle containsObject:@"BIRTHDAYS THIS MONTH"]) {
                    [self.sectionTitle addObject:@"BIRTHDAYS THIS MONTH"];
                }
                if ([now month] == [birthdayDate month]) {
                    if ([now day] != [birthdayDate day]) {
                        [sectionArray addObject:user];
                    }
                }
            } else{
                NSString *title = [NSString stringWithFormat:@"BIRTHDAYS IN %@", MONTHS[([now month] + i - 2) % 12]];
                if (![self.sectionTitle containsObject:title]) {
                    [self.sectionTitle addObject:title];
                }
                switch (i) {
                    case 2:
                        if (([birthdayDate month] % 12) == (([now month] + 1) % 12)) {
                            [sectionArray addObject:user];
                        }
                        break;
                    case 3:
                        if (([birthdayDate month] % 12) == (([now month] + 2) % 12)) {
                            [sectionArray addObject:user];
                        }
                        break;
                    case 4:
                        if (([birthdayDate month] % 12) == (([now month] + 3) % 12)) {
                            [sectionArray addObject:user];
                        }
                        break;
                    case 5:
                        if (([birthdayDate month] % 12) == (([now month] + 4) % 12)) {
                            [sectionArray addObject:user];
                        }
                        break;
                    case 6:
                        if (([birthdayDate month] % 12) == (([now month] + 5) % 12)) {
                            [sectionArray addObject:user];
                        }
                        break;
                    case 7:
                        if (([birthdayDate month] % 12) == (([now month] + 6) % 12)) {
                            [sectionArray addObject:user];
                        }
                        break;
                    case 8:
                        if (([birthdayDate month] % 12) == (([now month] + 7) % 12)) {
                            [sectionArray addObject:user];
                        }
                        break;
                    case 9:
                        if (([birthdayDate month] % 12) == (([now month] + 8) % 12)) {
                            [sectionArray addObject:user];
                        }
                        break;
                    case 10:
                        if (([birthdayDate month] % 12) == (([now month] + 9) % 12)) {
                            [sectionArray addObject:user];
                        }
                        break;
                    case 11:
                        if (([birthdayDate month] % 12) == (([now month] + 10) % 12)) {
                            [sectionArray addObject:user];
                        }
                        break;
                    case 12:
                        if (([birthdayDate month] % 12) == (([now month] + 11) % 12)) {
                            [sectionArray addObject:user];
                        }
                        break;
                    default:
                        break;
                }
                
            }
            
        }
        
        if (sectionArray.count != 0) {
            [self.sectionFriends setValue:sectionArray forKey:self.sectionTitle[i]];
        }
    }
}

- (void)showFriendsEmptyView{
    [self.navTitle setText:@"MY FUZZIE FRIENDS"];
    self.mainView.hidden = YES;
    self.facebookView.hidden = YES;
    self.friendsEmptyView.hidden = NO;
}

- (void)showMainView{
    [self.navTitle setText:@"MY FUZZIE FRIENDS"];
    self.mainView.hidden = NO;
    self.facebookView.hidden = YES;
    self.friendsEmptyView.hidden = YES;
}

- (void)showFacebookView{
    [self.navTitle setText:@"FIND YOUR FRIENDS"];
    self.mainView.hidden = YES;
    self.facebookView.hidden = NO;
    self.friendsEmptyView.hidden = YES;
}

- (void)tapSearch{
    self.actionViewHeightAnchor.constant = 0;
    self.searchView.hidden = NO;
    self.navView.hidden = YES;
    [self.search becomeFirstResponder];
}

- (void)tapCancel{
    self.actionViewHeightAnchor.constant = 44;
    self.navView.hidden = NO;
    self.searchView.hidden = YES;
    [self.search setText:@""];
    [self.search resignFirstResponder];
    
    self.searchFriends = self.sortedFriends;
    self.noResultView.hidden = YES;
    self.tableView.hidden = NO;
    if (self.sort == kSortByBirth) {
        [self setSearchArrayByBirth];
    } else{
        [self setSearchArrayByName];
    }
    
    [self.tableView reloadData];
}

- (void)setStyling{
    
    if (self.user.facebookId) {
        self.friendsEmptyView.hidden = YES;
        self.facebookView.hidden = YES;
        self.mainView.hidden = NO;
    } else{
        self.friendsEmptyView.hidden = NO;
        self.facebookView.hidden = YES;
        self.mainView.hidden = YES;
    }

    [CommonUtilities setView:self.facebookButton withBackground:[UIColor colorWithHexString:@"#263D6C"] withRadius:4.0f];
    [CommonUtilities setView:self.inviteButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    self.facebookView.hidden = YES;
    self.sort = kSortByBirth;
    self.searchView.hidden = YES;
    
    self.sectionTitle = [[NSMutableArray alloc] init];
    self.sectionFriends = [[NSMutableDictionary alloc] init];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionArray = [self.sectionFriends objectForKey:[self.sectionTitle objectAtIndex:section]];
    return sectionArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 3, tableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:11]];
    NSString *string =[self.sectionTitle objectAtIndex:section];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsCell" forIndexPath:indexPath];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendsTableViewCell *friendCell = (FriendsTableViewCell *)cell;
    friendCell.delegate = self;
    NSArray *sectionArray = [self.sectionFriends objectForKey:[self.sectionTitle objectAtIndex:indexPath.section]];
    [friendCell setInfo:sectionArray[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *searchTerm = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (searchTerm.length > 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ OR name LIKE[cd] %@", searchTerm, searchTerm];
        self.searchFriends = [self.sortedFriends filteredArrayUsingPredicate:predicate];
        
    } else {
        self.searchFriends = self.sortedFriends;
    }

    if (self.searchFriends.count == 0) {
        self.noResultView.hidden = NO;
        self.tableView.hidden = YES;
    } else{
        self.noResultView.hidden = YES;
        self.tableView.hidden = NO;
        if (self.sort == kSortByBirth) {
            [self setSearchArrayByBirth];
        } else{
            [self setSearchArrayByName];
        }
        
        [self.tableView reloadData];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - FriendsTableViewCellDelegate
- (void)cellTapped:(FZUser *)userInfo{
    [self.search resignFirstResponder];
     [self performSegueWithIdentifier:@"pushToUserProfile" sender:@{@"userInfo":userInfo}];
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
