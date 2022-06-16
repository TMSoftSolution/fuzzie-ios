//
//  TermsAndConditionsTableViewController.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/19/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "TermsAndConditionsTableViewController.h"
#import "TermsConditionsTableViewCell.h"

@interface TermsAndConditionsTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@end

@implementation TermsAndConditionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.titleString && ![self.titleString isEqualToString:@""]) {
        self.headerLabel.text = self.titleString;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableview.estimatedRowHeight = 54.0f;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.tableview reloadData];
    [self.tableview reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableview.numberOfSections)] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.termsConditions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"termsConditionsCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ((TermsConditionsTableViewCell *)cell).textConditionView.text = self.termsConditions[indexPath.row];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
