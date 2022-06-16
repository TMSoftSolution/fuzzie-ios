//
//  BrandJackpotViewController.m
//  Fuzzie
//
//  Created by mac on 9/19/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BrandJackpotViewController.h"
#import "JackpotEnterTableViewCell.h"
#import "JackpotCardViewController.h"
#import "JackpotHomePageViewController.h"

@interface BrandJackpotViewController () <UITableViewDataSource, UITableViewDelegate, JackpotEnterTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnViewAll;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)viewAllButtonPressed:(id)sender;

@end

@implementation BrandJackpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    if (self.brand) {
        
        self.lbHeader.text = [[NSString stringWithFormat:@"%@ %@", self.brand.name, @"JACKPOT"] uppercaseString];
        
    } else if (self.titleString){
        
        self.lbHeader.text = [self.titleString uppercaseString];
        
    } else {
        
        self.lbHeader.text = @"";
        
    }

    [CommonUtilities setView:self.btnViewAll withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    UINib *cellNib = [UINib nibWithNibName:@"JackpotEnterTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#282828"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.couponsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JackpotEnterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell setCell:[self.couponsArray objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112.0f;
}

#pragma mark - JackpotEnterTableViewCellDelegate
- (void)jackpotEnterCellTapped:(FZCoupon *)coupon brand:(FZBrand *)brand{
    JackpotCardViewController *cardView = (JackpotCardViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"JackpotCardView"];
    cardView.coupon = coupon;
    cardView.brand = brand;
    [self.navigationController pushViewController:cardView animated:YES];
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)viewAllButtonPressed:(id)sender {
    JackpotHomePageViewController *jackpotHomePage = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotHomePageView"];
    [self.navigationController pushViewController:jackpotHomePage animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
