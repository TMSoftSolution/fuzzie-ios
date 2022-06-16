//
//  ClubSearchViewController.m
//  Fuzzie
//
//  Created by joma on 6/25/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubSearchViewController.h"
#import "ClubStoreListTableViewCell.h"
#import "ClubStoreLocationTableViewCell.h"
#import "ClubStoreViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "NoResultView.h"
#import "ClubStoreListViewController.h"

typedef enum : NSUInteger {
    kSearchModePlaces,
    kSearchModeStores,
} kSearchMode;

@interface ClubSearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ClubStoreListTableViewCellDelegate, ClubStoreLocationTableViewCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UILabel *lbPlace;
@property (weak, nonatomic) IBOutlet FZHeaderView *placeIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lbStore;
@property (weak, nonatomic) IBOutlet FZHeaderView *storeIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NoResultView *emptyView;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)searchModeSwitched:(id)sender;


@property (assign, nonatomic) kSearchMode searchMode;

@end

@implementation ClubSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelButtonPressed:) name:SHOULD_DISMISS_VIEW object:nil];
    
    [self initData];
    [self setStyling];
}

- (void)initData{
    
    self.searchMode = kSearchModePlaces;
    
    self.searchClubStores = [[NSMutableArray alloc] initWithArray:self.clubStores];
    self.searchClubPlaces = [[NSMutableArray alloc] initWithArray:self.clubPlaces];
}

- (void)setStyling{
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    UINib *placeNib = [UINib nibWithNibName:@"ClubStoreLocationTableViewCell" bundle:nil];
    [self.tableView registerNib:placeNib forCellReuseIdentifier:@"PlaceCell"];
    
    UINib *storeNiib = [UINib nibWithNibName:@"ClubStoreListTableViewCell" bundle:nil];
    [self.tableView registerNib:storeNiib forCellReuseIdentifier:@"StoreCell"];
    
    UINib *emptyViewNib = [UINib nibWithNibName:@"NoResultView" bundle:nil];
    self.emptyView = [[emptyViewNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    [CommonUtilities setView:self.searchView withCornerRadius:2.5f];
    
    [self updatePlaceButton];
    [self updateStoreButton];
    
    [self.tfSearch becomeFirstResponder];
}

- (void)updatePlaceButton{
    
    if (self.searchMode == kSearchModePlaces) {
        
        self.lbPlace.textColor = [UIColor colorWithHexString:HEX_COLOR_RED];
        self.placeIndicator.layer.opacity = 1.0f;
        
        
    } else {
        
        self.lbPlace.textColor = [UIColor colorWithHexString:@"#939393"];
        self.placeIndicator.layer.opacity = 0.0f;
        
    }
}

- (void)updateStoreButton{
    
    if (self.searchMode == kSearchModeStores) {
        
        self.lbStore.textColor = [UIColor colorWithHexString:HEX_COLOR_RED];
        self.storeIndicator.layer.opacity = 1.0f;
        
        
    } else {
        
        self.lbStore.textColor = [UIColor colorWithHexString:@"#939393"];
        self.storeIndicator.layer.opacity = 0.0f;
        
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *searchTerm = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (searchTerm.length > 0) {

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brand_name CONTAINS[cd] %@ OR brand_name LIKE[cd] %@", searchTerm, searchTerm];
        self.searchClubStores = [self.clubStores filteredArrayUsingPredicate:predicate];

        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ OR name LIKE[cd] %@", searchTerm, searchTerm];
        self.searchClubPlaces = [self.clubPlaces filteredArrayUsingPredicate:predicate1];

    } else {

        self.searchClubStores = [[NSMutableArray alloc] initWithArray:self.clubStores];
        self.searchClubPlaces = [[NSMutableArray alloc] initWithArray:self.clubPlaces];
    }

    [self.tableView reloadData];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.tfSearch resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (self.searchMode) {
        case kSearchModePlaces:
            return self.searchClubPlaces.count;
            break;
        case kSearchModeStores:
            return self.searchClubStores.count;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.searchMode) {
        case kSearchModePlaces:
            return UITableViewAutomaticDimension ;
            break;
        case kSearchModeStores:
            return 100.0f;
            break;
            
        default:
            return 0.0f;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.searchMode) {
        case kSearchModePlaces:{
            
            ClubStoreLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCell"];
            [cell setCellWith:self.searchClubPlaces[indexPath.row]];
            cell.delegate = self;
            return cell;
            break;
            
        }
        case kSearchModeStores:{
            
            ClubStoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCell"];
            [cell setCell:self.searchClubStores[indexPath.row]];
            cell.delegate = self;
            return cell;
            break;
            
        }
        default:
            return nil;
            break;
    }
}

#pragma -mark DZNEmptyDataSet
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    return self.emptyView;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -self.tableView.frame.size.height/2 + 50;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}

- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView {
    [self.emptyView refreshSize];
}

#pragma mark - ClubStoreListTableViewCellDelegate
- (void)clubStoreListCellTapped:(NSDictionary *)dict{
    
    ClubStoreViewController *storeView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubStoreView"];
    storeView.dict = dict;
    [self.navigationController pushViewController:storeView animated:YES];
}

#pragma mark - ClubStoreLocationTableViewCellDelegate
- (void)storeLocationCellTapped:(NSDictionary *)dict{
    
    NSMutableArray *clubStores = [NSMutableArray new];
    for (NSString *storeId in dict[@"store_ids"]) {
        
        NSDictionary *clubStore = [FZData getClubStore:storeId stores:self.clubStores];
        if (clubStore) {
            
            [clubStores addObject:clubStore];
        }
    }
    
    ClubStoreListViewController *storeListView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubStoreListView"];
    storeListView.titleString = dict[@"name"];
    storeListView.filteredArray = clubStores;
    storeListView.hideFilter = YES;
    [self.navigationController pushViewController:storeListView animated:YES];
}

#pragma mark - IBAction Helper

- (IBAction)cancelButtonPressed:(id)sender {

    [self.tfSearch resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)searchModeSwitched:(id)sender {
    
    self.searchMode = ((UIButton*)sender).tag;

    [self updatePlaceButton];
    [self updateStoreButton];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
