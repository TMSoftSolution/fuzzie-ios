//
//  SettingsTableViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 29/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "SwitchOptionTableViewCell.h"
#import "FZWebView2Controller.h"
#import "AppDelegate.h"
#import "SDVersion.h"

typedef enum : NSUInteger {
    kSettingsSectionAccount,
    kSettingsSectionAbout,
    kSettingsSectionCount,
} kSettingsSection;

typedef enum : NSUInteger {
    kSettingsAccountEditProfile,
    kSettingsAccountEditImage,
    kSettingsAccountEditPassword,
    kSettingsAccountEditShareLikeWishlist
} kSettingsAccount;

//typedef enum : NSUInteger {
//   
//} kSettingsNotification;

typedef enum : NSUInteger {
    kSettingsAboutTerms,
    kSettingsAboutPrivacy,
    kSettingsAboutLogout
} kSettingsAbout;

@interface SettingsTableViewController () <SwitchOptionTableViewCellDelegate>

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyling];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self sizeHeaderToFit];
}

- (void)sizeHeaderToFit {
    
    [self.tableView.tableHeaderView setNeedsLayout];
    [self.tableView.tableHeaderView layoutIfNeeded];
    CGFloat height = 64;
    if ([SDVersion deviceSize] >= Screen5Dot8inch) {
        
        height = 84;
    }
    
    CGRect headerFrame = self.tableView.tableHeaderView.frame;
    headerFrame.size.height = height;
    
    self.tableView.tableHeaderView.frame = headerFrame;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == kSettingsSectionAccount) {
        if (indexPath.row == kSettingsAccountEditShareLikeWishlist) {
            SwitchOptionTableViewCell *switchCell = (SwitchOptionTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"SwitchOptionCell"];
            switchCell.delegate = self;
            [switchCell setId:@"shareLikeWishlist"];
            FZUser *user = [UserController sharedInstance].currentUser;
            [switchCell.switchButton setOn:[user.sharesLikesWishlist boolValue]];
            return switchCell;
        }
    }
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == kSettingsSectionAbout) {
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        return [NSString stringWithFormat:@"FUZZIE - VERSION %@ (%@)", version, build];
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == kSettingsSectionAccount) {
        if (indexPath.row == kSettingsAccountEditShareLikeWishlist) {
            return NO;
        }
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == kSettingsSectionAccount) {
        
        if (indexPath.row == kSettingsAccountEditProfile) {
            UIViewController *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileView"];
            [self.navigationController pushViewController:editView animated:YES];
        } else if (indexPath.row == kSettingsAccountEditImage) {
            UIViewController *imageView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileImageView"];
            [self.navigationController pushViewController:imageView animated:YES];
        } else if (indexPath.row == kSettingsAccountEditPassword) {
            UIViewController *passwordView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPasswordView"];
            [self.navigationController pushViewController:passwordView animated:YES];
        }
        
    } else if (indexPath.section == kSettingsSectionAbout) {
        
        if (indexPath.row == kSettingsAboutTerms) {
            
          [self performSegueWithIdentifier:@"pushToWebview" sender:@{@"url":@"http://fuzzie.com.sg/terms",@"title":@"TERMS OF SERVICES"}];
            
        } else if (indexPath.row == kSettingsAboutPrivacy) {
            
            [self performSegueWithIdentifier:@"pushToWebview" sender:@{@"url":@"http://fuzzie.com.sg/privacy",@"title":@"PRIVACY POLICY"}];
            
        } else if (indexPath.row == kSettingsAboutLogout) {
            
            UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:@"Log out" message:@"Are you sure?"]
            ;
            [alertView bk_addButtonWithTitle:@"Cancel" handler:nil];
            [alertView bk_addButtonWithTitle:@"Log out" handler:^{
                
                [AppDelegate logOut];
                
            }];
            [alertView show];
        }
    }
    
}

#pragma mark - Helper Functions

- (void)setStyling {

    UINib *SwitchOptionTableViewCellNib = [UINib nibWithNibName:@"SwitchOptionTableViewCell" bundle:nil];
    [self.tableView registerNib:SwitchOptionTableViewCellNib forCellReuseIdentifier:@"SwitchOptionCell"];
}

#pragma -mark SwitchOptionTableViewCellDelegate

- (void)switchButton:(UISwitch*)switchButton valueChangedWith:(NSString *)idSwitch state:(BOOL)state {
    NSLog(@"%@ %i", idSwitch, state);
    
    if ([idSwitch isEqualToString:@"shareLikeWishlist"]) {
        [UserController sharedInstance].currentUser.sharesLikesWishlist = @(state);
        [UserController updatePrivacyShareLikeWishlistState:state withErrorBlock:^(NSError *error) {
            if (error) {
                if (error.code == 417) {
                    [AppDelegate logOut];
                    return ;
                }
                if (state) {
                    [switchButton setOn:NO];
                    [UserController sharedInstance].currentUser.sharesLikesWishlist =  @(NO);
                } else {
                    [switchButton setOn:YES];
                    [UserController sharedInstance].currentUser.sharesLikesWishlist =  @(YES);
                }
            }
        }];
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"pushToWebview"]) {
        if ([segue.destinationViewController isKindOfClass:[FZWebView2Controller class]]) {
            FZWebView2Controller *webView2Controller = (FZWebView2Controller *)segue.destinationViewController;
            if (sender){
                if ([sender isKindOfClass:[NSDictionary class]]) {
                    if ([sender[@"url"] isKindOfClass:[NSString class]]) {
                        webView2Controller.URL = ((NSString *)(NSDictionary *)sender[@"url"]);
                    }
                    if ([sender[@"title"] isKindOfClass:[NSString class]]) {
                        webView2Controller.titleHeader = ((NSString *)(NSDictionary *)sender[@"title"]);
                    }
                }
            }
        }
    }
}

@end
