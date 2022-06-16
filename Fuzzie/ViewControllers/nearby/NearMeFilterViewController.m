//
//  NearMeFilterViewController.m
//  Fuzzie
//
//  Created by mac on 7/9/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "NearMeFilterViewController.h"
#import "MapFilterTableViewCell.h"


@interface NearMeFilterViewController () <UITableViewDelegate, UITableViewDataSource, MapFilterTableViewCellDelegate>


@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *clearButton;

@property (strong, nonatomic) NSArray *subCategoryArray;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;

@end

@implementation NearMeFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setStyling];
}

- (void)initData{
//    self.subCategoryArray = [[FZData sharedInstance].subCategoryArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        return [obj1 valueForKey:@"id"] > [obj2 valueForKey:@"id"];
//    }];
    
    self.subCategoryArray = [FZData getUsedSubCategories];
}

- (void)setStyling{
   
    [CommonUtilities setView:self.doneButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    UINib *nib = [UINib nibWithNibName:@"MapFilterTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MapFilterTableViewCell"];
    
    [self updateClearButton];
}
- (void)updateClearButton{
    if ([FZData sharedInstance].filterSubCategoryIds.count > 0) {
        [self.clearButton setText:@"Clear"];
    } else{
        [self.clearButton setText:@"Select all"];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.subCategoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MapFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapFilterTableViewCell" forIndexPath:indexPath];
    NSDictionary *dictionary = [self.subCategoryArray objectAtIndex:indexPath.row];
    [cell setCell:dictionary];
    cell.delegate = self;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(doneButtonClicked)]) {
        [self.delegate doneButtonClicked];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearButtonPressed:(id)sender {
    
    if ([FZData sharedInstance].filterSubCategoryIds.count > 0) {
        [[FZData sharedInstance].filterSubCategoryIds removeAllObjects];
    } else{
        [FZData setFullFilterSubCategoris];
    }
    
    [self updateClearButton];
    [self.tableView reloadData];
}

#pragma mark - MapFilterTableViewCellDelegate
- (void)cellTapped:(UITableViewCell *)cell with:(NSDictionary *)dictionary{
    MapFilterTableViewCell *filterCell = (MapFilterTableViewCell*)cell;
    if (filterCell.isSelected) {
        [[FZData sharedInstance].filterSubCategoryIds addObject:dictionary[@"id"]];
    } else{
        [[FZData sharedInstance].filterSubCategoryIds removeObject:dictionary[@"id"]];
    }
    
    [self updateClearButton];
}

@end
