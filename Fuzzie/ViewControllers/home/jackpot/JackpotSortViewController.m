//
//  JackpotSortViewController.m
//  Fuzzie
//
//  Created by mac on 9/13/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotSortViewController.h"
#import "JackpotSortTableViewCell.h"

@interface JackpotSortViewController () <UITableViewDataSource, UITableViewDelegate, JackpotSortTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonPressed:(id)sender;
@end

@implementation JackpotSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void) setStyling{
    
    UINib *cellNib = [UINib nibWithNibName:@"JackpotSortTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [FZData sharedInstance].jackpotListSortItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JackpotSortTableViewCell *cell = (JackpotSortTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    BOOL selected = indexPath.row == [FZData sharedInstance].selectedJackpotSortIndex;
    [cell setCellWith:(int)indexPath.row withSelect:selected];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

#pragma mark - JackpotSortTableViewCellDelegate
- (void)cellTapped:(int)position{
    [FZData sharedInstance].selectedJackpotSortIndex = position;
    [self.tableView reloadData];
    if ([self.delegate respondsToSelector:@selector(changeSortItem)]) {
        [self.delegate changeSortItem];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
