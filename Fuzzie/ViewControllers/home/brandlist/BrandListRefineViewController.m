//
//  BrandListRefineViewController.m
//  Fuzzie
//
//  Created by mac on 9/1/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BrandListRefineViewController.h"
#import "BrandListRefineTableViewCell.h"

@interface BrandListRefineViewController () <UITableViewDataSource, UITableViewDelegate, BrandListRefineTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbClear;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;

@end

@implementation BrandListRefineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnDone withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    UINib *cellNib = [UINib nibWithNibName:@"BrandListRefineTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    [self updateClearLabel];

}

- (void)updateClearLabel{
    if ([FZData sharedInstance].selectedRefineSubCategoryIds.count == 0) {
        self.lbClear.text = @"Select all";
    } else{
        self.lbClear.text = @"Clear";
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.subCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BrandListRefineTableViewCell *cell = (BrandListRefineTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell setCell:[self.subCategories objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

#pragma mark - BrandListRefineTableViewCellDelegate
- (void)cellTapped:(UITableViewCell *)cell withDict:(NSDictionary *)dictionary{
    BrandListRefineTableViewCell *refineCell = (BrandListRefineTableViewCell*)cell;
    if (refineCell.isSelected) {
        [[FZData sharedInstance].selectedRefineSubCategoryIds addObject:dictionary[@"id"]];
    } else{
        [[FZData sharedInstance].selectedRefineSubCategoryIds removeObject:dictionary[@"id"]];
    }
    
    [self updateClearLabel];
}

#pragma mark - IBAction Helper

- (IBAction)doneButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(refineViewDoneButtonPressed)]) {
        [self.delegate refineViewDoneButtonPressed];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clearButtonPressed:(id)sender {
    if ([FZData sharedInstance].selectedRefineSubCategoryIds.count > 0) {
        [[FZData sharedInstance].selectedRefineSubCategoryIds removeAllObjects];
    } else{
        for (NSDictionary *dict in self.subCategories) {
            [[FZData sharedInstance].selectedRefineSubCategoryIds addObject:dict[@"id"]];
        }
    }
    
    [self updateClearLabel];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
