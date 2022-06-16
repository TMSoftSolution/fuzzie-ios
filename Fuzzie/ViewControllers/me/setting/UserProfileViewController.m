//
//  UserProfileViewController.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/23/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "UserProfileViewController.h"
#import "BrandTableViewCell.h"
#import "UserProfileHeaderView.h"
#import "UserProfileSwitchMode.h"
#import "UIScrollView+EmptyDataSet.h"
#import "PlaceHolderUserProfileView.h"
#import "UITableView+Reload.h"
#import "PackageListViewController.h"
#import "CardViewController.h"
#import "PackageViewController.h"
#import "UserProfilePhotoViewController.h"

@interface UserProfileViewController () <UITableViewDelegate, UITableViewDataSource, UserProfileSwitchModeDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, BrandTableViewCellDelegate, UserProfileHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *whishListUser;
@property (strong, nonatomic) NSArray *likeUser;
@property (assign, nonatomic) UserProfileMode mode;
@property (strong, nonatomic) PlaceHolderUserProfileView *placeholderView;
@property (strong, nonatomic) UserProfileSwitchMode *switchMode;
@property (assign, nonatomic) BOOL headerAlreadyLoaded;
@property (assign, nonatomic) BOOL dataWishListLoader;
@property (assign, nonatomic) BOOL dataLikeLoaded;

@property (strong, nonatomic) UserProfileHeaderView *headerView;
@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.whishListUser = [[NSArray alloc] init];
    self.likeUser = [[NSArray alloc] init];
    
    
    UINib *customNib = [UINib nibWithNibName:@"PlaceHolderUserProfileView" bundle:nil];
    self.placeholderView = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    if (self.selectWishList) {
        self.mode = UserProfileModeWhishList;
    } else{
        self.mode = UserProfileModeLike;
    }
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    UINib *UserProfileHeaderViewNib = [UINib nibWithNibName:@"UserProfileHeaderView" bundle:nil];
    self.headerView = [[UserProfileHeaderViewNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.headerView.delegate = self;
    [self.tableView setTableHeaderView:self.headerView];
    self.headerView.frame = CGRectMake(0,0,self.view.frame.size.width,110);
    self.tableView.tableHeaderView.frame = CGRectMake(0,0,self.view.frame.size.width,110);
    
    self.tableView.tableHeaderView = self.tableView.tableHeaderView;
    
    UINib *BrandCellNib = [UINib nibWithNibName:@"BrandTableViewCell" bundle:nil];
    [self.tableView registerNib:BrandCellNib forCellReuseIdentifier:@"BrandCell"];
    
    UINib *SwitchModeNib = [UINib nibWithNibName:@"UserProfileSwitchMode" bundle:nil];
    [self.tableView registerNib:SwitchModeNib forHeaderFooterViewReuseIdentifier:@"switchMode"];
 
    if (self.userInfo) {
        [self setUI];
        [self loadDataUser];
    } else if(self.userId){
        [self loadUserInfo];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeLoaded) name:HOME_DATA_REFRESHED object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HOME_DATA_REFRESHED object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self sizeHeaderToFit];
}

- (void)homeLoaded{
    [self.tableView reloadData];
}

- (void)setUI{
    
    NSString *name = @"";
    if (self.userInfo.firstName) {
        name = self.userInfo.firstName;
    }
    
    if (self.userInfo.lastName) {
        name = [NSString stringWithFormat:@"%@ %@",name,self.userInfo.lastName];
    }
    self.titleLabel.text = [name uppercaseString];
    
    [((UserProfileHeaderView *)self.headerView) setInfoUser:self.userInfo];
}

- (void)sizeHeaderToFit {
    [self.tableView.tableHeaderView setNeedsLayout];
    [self.tableView.tableHeaderView layoutIfNeeded];
    
    CGFloat height = [self.tableView.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    CGRect headerFrame = self.tableView.tableHeaderView.frame;
    headerFrame.size.height = height;
    
    self.tableView.tableHeaderView.frame = headerFrame;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.mode == UserProfileModeWhishList) {
        return self.whishListUser.count;
    } else {
        return self.likeUser.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandCell" forIndexPath:indexPath];
    cell.delegate = self;

    return cell;
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BrandTableViewCell *cellBrand = (BrandTableViewCell *)cell;
    FZBrand *brand = nil;
    if (self.mode == UserProfileModeWhishList) {
        brand = self.whishListUser[indexPath.row];
        
    } else {
        brand = self.likeUser[indexPath.row];
    }
    
    [cellBrand setupWithBrand:brand];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FZBrand *brand = nil;
    if (self.mode == UserProfileModeWhishList) {
        brand = self.whishListUser[indexPath.row];
    } else {
        brand = self.likeUser[indexPath.row];
    }
    
    
    if (brand.giftCards && brand.giftCards.count > 0 && brand.services && brand.services.count > 0) {
        
        PackageListViewController *packageListView = [self.storyboard instantiateViewControllerWithIdentifier:@"PackageListView"];
        packageListView.brand = brand;
        packageListView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:packageListView animated:YES];
        
    } else if (brand.giftCards && brand.giftCards.count > 0) {
        
        [self performSegueWithIdentifier:@"pushToBrandCardGift" sender:brand];
        
    } else if (brand.services && brand.services.count == 1) {
        
        NSDictionary *packageDict = [brand.services firstObject];
        
        [self performSegueWithIdentifier:@"pushToPackage"
                                  sender:@{@"brand":brand,@"packageDict":packageDict}];
        
    } else if (brand.services && brand.services.count > 1) {
        
        PackageListViewController *packageListView = [self.storyboard instantiateViewControllerWithIdentifier:@"PackageListView"];
        packageListView.brand = brand;
        packageListView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:packageListView animated:YES];
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.switchMode == nil) {
        self.switchMode = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"switchMode"];
        [self.switchMode refreshMode:self.mode];
        self.switchMode.delegate = self;
    }
    return self.switchMode;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 42.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240.0f;
}


- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark UserProfileSwitchModeDelegate
- (void)modeChanged:(NSInteger)mode {
    if (mode == UserProfileModeWhishList) {
        self.mode = UserProfileModeWhishList;
        //__typeof__(self) __weak weakSelf = self;
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{

        }];
        
        [self.tableView reloadRowsInSection:0
                           withRowAnimation:UITableViewRowAnimationFade
                                   oldCount:self.likeUser.count
                                   newCount:self.whishListUser.count];
        
        [CATransaction commit];
       
    } else {
        self.mode = UserProfileModeLike;
        //__typeof__(self) __weak weakSelf = self;
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{

        }];
        
        [self.tableView reloadRowsInSection:0
                           withRowAnimation:UITableViewRowAnimationFade
                                   oldCount:self.whishListUser.count
                                   newCount:self.likeUser.count];
        
        [CATransaction commit];
    }


}

#pragma -mark DZNEmptyDataSet

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    
    if (self.mode == UserProfileModeWhishList) {
        if (self.whishListUser.count > 0) {
            [self.placeholderView stopLoader];
        } else {
            if (self.dataWishListLoader) {
                [self.placeholderView changePlaceHolderMode:self.mode];
            } else {
                if (![FZData sharedInstance].isHomeLoading) {
                    [self.placeholderView startLoader];
                }
            }
            
        }
    } else {
        if (self.likeUser.count > 0) {
            [self.placeholderView stopLoader];
        } else {
            if (self.dataLikeLoaded) {
                [self.placeholderView changePlaceHolderMode:self.mode];
            } else {
                if (![FZData sharedInstance].isHomeLoading) {
                    [self.placeholderView startLoader];
                }
            }
        }
    }
    
    return self.placeholderView;
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0;

}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView {
    
    [self.placeholderView refreshSize];
    //[scrollView setContentOffset:CGPointMake(0, -scrollView.contentInset.top) animated:NO];
}

- (void)loadUserInfo{
    [UserController getUserInfoWithId:self.userId withCompletion:^(NSDictionary *dictionary, NSError *error) {
        
        if (dictionary) {
            NSError *error = nil;
            FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:dictionary error:&error];
            self.userInfo = user;
            [self setUI];
            [self loadDataUser];

        }
        
        if (error && error.code == 417) {
            [AppDelegate logOut];
        }
    }];
}

- (void)loadDataUser {
    __typeof__(self) __weak weakSelf = self;
    
    [UserController getUserLikeBrandWithUserId:self.userInfo.fuzzieId And:^(NSArray *array, NSError *error) {
        
        weakSelf.dataLikeLoaded = YES;
        
        if (error) {
            NSLog(@"ERROR %@",error);
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }

        }
        //NSLog(@"like : %@",array);
        weakSelf.likeUser = array;
        int nbLike = (int)[self.likeUser count];
        [weakSelf.switchMode setNbLike:nbLike];
        if(weakSelf.mode == UserProfileModeLike) {
            if (nbLike > 0) {
                [weakSelf.tableView reloadRowsInSection:0
                                   withRowAnimation:UITableViewRowAnimationFade
                                           oldCount:0
                                           newCount:nbLike];
            } else {
               [self.placeholderView changePlaceHolderMode:self.mode];
            }
        }
    }];
    
    [UserController getUserWishlistBrandWithUserId:self.userInfo.fuzzieId And:^(NSArray *array, NSError *error) {
        
        self.dataWishListLoader = YES;
        
        if (error) {
            NSLog(@"ERROR %@",error);
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
        }
        //NSLog(@"WHISHTLIST : %@",array);
        weakSelf.whishListUser = array;
        int nbWishlisted = (int)[self.whishListUser count];
        [weakSelf.switchMode setNbWishlisted:nbWishlisted];
        if(weakSelf.mode == UserProfileModeWhishList) {
            if (nbWishlisted > 0) {
                [weakSelf.tableView reloadRowsInSection:0
                                   withRowAnimation:UITableViewRowAnimationFade
                                           oldCount:0
                                           newCount:nbWishlisted];
            } else {
                [self.placeholderView changePlaceHolderMode:self.mode];
            }
        }

    }];
}

#pragma mark - UserProfileHeaderViewDelegate
- (void)profilePhotoPressed{
    [self performSegueWithIdentifier:@"pushToUserProfilePhoto" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pushToUserProfilePhoto"]) {
        if ([segue.destinationViewController isKindOfClass:[UserProfilePhotoViewController class]]){
            UserProfilePhotoViewController *photoViewController = (UserProfilePhotoViewController*)segue.destinationViewController;
            photoViewController.userInfo = self.userInfo;
        }
    }
    
    if ([segue.identifier isEqualToString:@"pushToBrandCardGift"]) {
        if ([segue.destinationViewController isKindOfClass:[CardViewController class]]) {
            CardViewController *cardViewController = (CardViewController *)segue.destinationViewController;
            cardViewController.hidesBottomBarWhenPushed = YES;
            if (sender){
                if ([sender isKindOfClass:[FZBrand class]]) {
                    cardViewController.brand = (FZBrand *)sender;
                }
            }
        }
    }
    
    if ([segue.identifier isEqualToString:@"pushToPackage"]) {
        if ([segue.destinationViewController isKindOfClass:[PackageViewController class]]) {
            PackageViewController *packageViewController = (PackageViewController *)segue.destinationViewController;
            packageViewController.hidesBottomBarWhenPushed = YES;
            if (sender){
                if ([sender isKindOfClass:[NSDictionary class]]) {
                    packageViewController.brand = [(NSDictionary *)sender objectForKey:@"brand"];
                    packageViewController.packageDict = [(NSDictionary *)sender objectForKey:@"packageDict"];
                }
            }
        }
    }
}

#pragma mark - BrandTableViewCellDelegate

- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state {
    [self likeBrand:brand withState:state];
}

@end
