//
//  BrandListSortViewController.m
//  Fuzzie
//
//  Created by mac on 9/1/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BrandListSortViewController.h"
#import "BrandListSortTableViewCell.h"

@interface BrandListSortViewController () <UITableViewDataSource, UITableViewDelegate, BrandListSortTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation BrandListSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void) setStyling{
    
    UINib *cellNib = [UINib nibWithNibName:@"BrandListSortTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [FZData sharedInstance].brandListSortItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BrandListSortTableViewCell *cell = (BrandListSortTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    BOOL selected = indexPath.row == [FZData sharedInstance].selectedSortIndex;
    [cell setCellWith:(int)indexPath.row withSelect:selected];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

#pragma mark - BrandListSortTableViewCellDelegate
- (void)cellTapped:(int)position{
    [FZData sharedInstance].selectedSortIndex = position;
    [self.tableView reloadData];
    if ([self.delegate respondsToSelector:@selector(changeSortItem)]) {
        [self.delegate changeSortItem];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
