//
//  JackpotRefineViewController.m
//  Fuzzie
//
//  Created by mac on 9/14/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotRefineViewController.h"
#import "JackpotRefineTableViewCell.h"

@interface JackpotRefineViewController () <UITableViewDataSource, UITableViewDelegate, JackpotRefineTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbClear;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;
@end

@implementation JackpotRefineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnDone withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    UINib *cellNib = [UINib nibWithNibName:@"JackpotRefineTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    [self updateClearLabel];
}

- (void)updateClearLabel{
    if ([FZData sharedInstance].selectedJackpotRefineSubCategoryIds.count == 0) {
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
    JackpotRefineTableViewCell *cell = (JackpotRefineTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell setCell:[self.subCategories objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

#pragma mark - JackpotRefineTableViewCellDelegate
- (void)cellTapped:(UITableViewCell *)cell withDict:(NSDictionary *)dictionary{
    JackpotRefineTableViewCell *refineCell = (JackpotRefineTableViewCell*)cell;
    if (refineCell.isSelected) {
        [[FZData sharedInstance].selectedJackpotRefineSubCategoryIds addObject:dictionary[@"id"]];
    } else{
        [[FZData sharedInstance].selectedJackpotRefineSubCategoryIds removeObject:dictionary[@"id"]];
    }
    
    [self updateClearLabel];
}


#pragma mark - IBAction Helper
- (IBAction)doneButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(jackpotRefineDoneButtonPressed)]) {
        [self.delegate jackpotRefineDoneButtonPressed];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clearButtonPressed:(id)sender {
    if ([FZData sharedInstance].selectedJackpotRefineSubCategoryIds.count > 0) {
        [[FZData sharedInstance].selectedJackpotRefineSubCategoryIds removeAllObjects];
    } else{
        for (NSDictionary *dict in self.subCategories) {
            [[FZData sharedInstance].selectedJackpotRefineSubCategoryIds addObject:dict[@"id"]];
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
