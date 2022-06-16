//
//  ClubFavoriteViewController.m
//  Fuzzie
//
//  Created by joma on 6/26/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubFavoriteViewController.h"
#import "ClubStoreListTableViewCell.h"
#import "ClubStoreViewController.h"
#import "ClubFavoriteFilterViewController.h"

@interface ClubFavoriteViewController () <UITableViewDelegate, UITableViewDataSource, ClubStoreListTableViewCellDelegate, ClubFavoriteFilterViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)filterButtonPressed:(id)sender;

@end

@implementation ClubFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedBookmarkedStores) name:CLUB_STORE_BOOK_MARK_CHANGED object:nil];

    self.sortDistance = YES;
    
    [self setStyling];
    [self initData];
}

- (void)setStyling{
 
    UINib *nib = [UINib nibWithNibName:@"ClubStoreListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
}

- (void)initData{
    
    self.clubStores = [NSMutableArray new];
    
    for (NSString *storeId in [UserController sharedInstance].currentUser.bookmarkedStoreIds) {
        
        NSDictionary *clubStore = [FZData getClubStore:storeId stores:[FZData sharedInstance].clubStores];
        if (clubStore) {
            
            [self.clubStores addObject:clubStore];
        }
    }

    [self filterClubStores];
}

- (void)filterClubStores{
    
    if (self.selectedBrandTypes.count == 0 || self.selectedBrandTypes.count == [FZData sharedInstance].clubBrandTypes.count) {
        
        self.filteredStores = [[NSMutableArray alloc] initWithArray:self.clubStores];
        
    } else {
        
        self.filteredStores = [NSMutableArray new];
        for (NSDictionary *dict in self.clubStores) {
            
            NSDictionary *brandType = [FZData getBrandType:dict[@"brand_type_id"]];
            if ([self.selectedBrandTypes containsObject:brandType]) {
                
                [self.filteredStores addObject:dict];
            }
        }
    }
    
    [self sortClubStores];
}

- (void) sortClubStores{
    
    self.sortedStores = self.filteredStores;
    
    if (self.sortDistance) {
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
        self.sortedStores = [self.filteredStores sortedArrayUsingDescriptors:@[sortDescriptor]];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sortedStores.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClubStoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell setCell:self.sortedStores[indexPath.row]];
    cell.delegate = self;
    return cell;
    
}

- (void)changedBookmarkedStores{
    
    [self initData];
}

#pragma mark - ClubStoreListTableViewCellDelegate
- (void)clubStoreListCellTapped:(NSDictionary *)dict{
    
    ClubStoreViewController *storeView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubStoreView"];
    storeView.dict = dict;
    [self.navigationController pushViewController:storeView animated:YES];
}

#pragma mark - ClubFavoriteFilterViewControllerDelegate
- (void)filterApplied:(NSMutableArray *)selectedBrandTypes sortDistance:(BOOL)sortDistance{
    
    self.selectedBrandTypes = selectedBrandTypes;
    self.sortDistance = sortDistance;
    
    [self filterClubStores];
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)filterButtonPressed:(id)sender {
    
    ClubFavoriteFilterViewController *filterView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubFavoriteFilterView"];
    filterView.selectedBrandTypes = self.selectedBrandTypes;
    filterView.sortDistance = self.sortDistance;
    filterView.delegate = self;
    [self presentViewController:filterView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLUB_STORE_BOOK_MARK_CHANGED object:nil];
}
@end
