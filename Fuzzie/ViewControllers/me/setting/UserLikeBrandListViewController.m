//
//  UserLikeBrandListViewController.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/22/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "UserLikeBrandListViewController.h"
#import "UserLikeTableViewCell.h"
#import "UserProfileViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface UserLikeBrandListViewController () <UserLikeTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation UserLikeBrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.usersLike count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserLikeCell" forIndexPath:indexPath];
    return cell;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UserLikeTableViewCell *userCell = (UserLikeTableViewCell *)cell;
    userCell.delegate = self;
    [userCell setInfo:self.usersLike[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

#pragma -mark UserLikeTableViewCellDelegate

- (void)cellTapped:(FZUser *)userInfo {
    [self performSegueWithIdentifier:@"pushToUserProfile" sender:@{@"userInfo":userInfo}];
}

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
