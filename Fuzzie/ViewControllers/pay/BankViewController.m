//
//  BankViewController.m
//  Fuzzie
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BankViewController.h"
#import "BankTableViewCell.h"
#import "BankDetailViewController.h"

@interface BankViewController () <UITableViewDataSource, UITableViewDelegate, BankTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) int selectedIndex;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation BankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
    
}

- (void)setStyling{
    
    UINib *bankCellNib = [UINib nibWithNibName:@"BankTableViewCell" bundle:nil];
    [self.tableView registerNib:bankCellNib forCellReuseIdentifier:@"Cell"];
    
    self.lbHeader.text = self.bankDict[@"name"];
    self.creditsArray = self.bankDict[@"credit_cards"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.creditsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.delegate = self;
    [cell setCellWith:self.creditsArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.creditsArray.count == 0) {
        return 0.0f;
    }
    
    return 80.0f;
}

#pragma mark - BankTableViewCellDelegate
- (void)cellTapped:(NSDictionary *)dict{
    BankDetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"BankDetailView"];
    detailView.cardDict = dict;
    [self.navigationController pushViewController:detailView animated:YES];
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
