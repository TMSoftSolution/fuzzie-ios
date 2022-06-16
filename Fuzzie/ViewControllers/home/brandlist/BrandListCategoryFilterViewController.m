//
//  BrandListCategoryFilterViewController.m
//  Fuzzie
//
//  Created by mac on 9/1/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BrandListCategoryFilterViewController.h"
#import "BrandListCategoryFilterTableViewCell.h"

@interface BrandListCategoryFilterViewController () <UITableViewDataSource, UITableViewDelegate, BrandListCategoryFilterTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbClear;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

- (IBAction)clearButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

@end

@implementation BrandListCategoryFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnDone withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    UINib *cellNib = [UINib nibWithNibName:@"BrandListCategoryFilterTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
     [self updateClearLabel];
}

- (void)updateClearLabel{
    if ([FZData sharedInstance].selectedCategoryIds.count == 0) {
        self.lbClear.text = @"Select all";
    } else{
        self.lbClear.text = @"Clear";
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categoriesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BrandListCategoryFilterTableViewCell *cell = (BrandListCategoryFilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell setCell:[self.categoriesArray objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

#pragma mark - BrandListCategoryFilterTableViewCellDelegate
- (void)cellTapped:(UITableViewCell *)cell withDict:(NSDictionary *)dictionary{
    BrandListCategoryFilterTableViewCell *filterCell = (BrandListCategoryFilterTableViewCell*)cell;
    if (filterCell.isSelected) {
        [[FZData sharedInstance].selectedCategoryIds addObject:dictionary[@"id"]];
    } else{
        [[FZData sharedInstance].selectedCategoryIds removeObject:dictionary[@"id"]];
    }
    
    [self updateClearLabel];
    
}

#pragma mark - IBAction Helper
- (IBAction)doneButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(filterViewDoneButtonPressed)]) {
        [self.delegate filterViewDoneButtonPressed];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clearButtonPressed:(id)sender {
    if ([FZData sharedInstance].selectedCategoryIds.count > 0) {
        [[FZData sharedInstance].selectedCategoryIds removeAllObjects];
    } else{
        for (NSDictionary *dict in self.categoriesArray) {
            [[FZData sharedInstance].selectedCategoryIds addObject:dict[@"id"]];
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
