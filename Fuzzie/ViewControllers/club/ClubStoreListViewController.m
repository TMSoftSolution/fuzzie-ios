//
//  ClubStoreListViewController.m
//  Fuzzie
//
//  Created by joma on 6/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreListViewController.h"
#import "ClubStoreListTableViewCell.h"
#import "ClubStoreFilterViewController.h"
#import "ClubFlashTableViewCell.h"
#import "ClubStoreViewController.h"

@interface ClubStoreListViewController () <UITableViewDelegate, UITableViewDataSource, ClubStoreListTableViewCellDelegate, ClubStoreFilterViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnFilter;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)filterButtonPressed:(id)sender;

@end

@implementation ClubStoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self filterClub];
    [self setStyling];
}

- (void)setStyling{
    
    UINib *nib = [UINib nibWithNibName:@"ClubStoreListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    UINib *flashNib = [UINib nibWithNibName:@"ClubFlashTableViewCell" bundle:nil];
    [self.tableView registerNib:flashNib forCellReuseIdentifier:@"FlashCell"];
    
    self.lbTitle.text = [self.titleString uppercaseString];
    
    self.btnFilter.hidden = self.hideFilter;
}

- (void)filterClub{
    
    if (!self.hideFilter) {
        
        if (self.selectedBrandTypes.count < 1) {
            
            self.filteredArray = [[NSMutableArray alloc] initWithArray:self.array];
            
        } else {
            
            self.filteredArray = [NSMutableArray new];
            for (NSDictionary *dict in self.array) {
                
                NSDictionary *brandType = [FZData getBrandType:dict[@"brand_type_id"]];
                if ([self.selectedBrandTypes containsObject:brandType]) {
                    
                    [self.filteredArray addObject:dict];
                }
            }
        }
        
        [self.tableView reloadData];
    }

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.flashMode) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        return width / 2.0f;
        
    } else {
        
        return 100.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.flashMode) {
        
        ClubFlashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlashCell"];
        [cell setCell:self.filteredArray[indexPath.row]];
        return cell;
        
    } else {
        
        ClubStoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        [cell setCell:self.filteredArray[indexPath.row]];
        cell.delegate = self;
        return cell;
    }

}

#pragma mark - UITapGestureRecognizer
- (void)clubStoreListCellTapped:(NSDictionary *)dict{
    
    ClubStoreViewController *storeView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubStoreView"];
    storeView.dict = dict;
    [self.navigationController pushViewController:storeView animated:YES];
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)filterButtonPressed:(id)sender {
    
    ClubStoreFilterViewController *filterView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubStoreFilterView"];
    filterView.selectedBrandTypes = self.selectedBrandTypes;
    filterView.delegate = self;
    [self presentViewController:filterView animated:YES completion:nil];
}

#pragma mark - ClubStoreFilterViewControllerDelegate
- (void)filterApplied:(NSMutableArray *)selectedBrandTypes{

    self.selectedBrandTypes = selectedBrandTypes;
    [self filterClub];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
