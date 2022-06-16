//
//  JackpotEnterViewController.m
//  Fuzzie
//
//  Created by mac on 9/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotBrandListViewController.h"
#import "JackpotEnterTableViewCell.h"
#import "JackpotHeaderView.h"
#import "JackpotSectionTableViewCell.h"
#import "FZHeaderView.h"
#import "JackpotConfirmViewController.h"
#import "JackpotLearnMoreViewController.h"
#import "JackpotSortViewController.h"

@interface JackpotBrandListViewController () <UITableViewDataSource, UITableViewDelegate, JackpotEnterTableViewCellDelegate, JackpotHeaderViewDelegate, JackpotSectionTableViewCellDelegate, JackpotSortViewControllerDelegate>

@property (weak, nonatomic) IBOutlet FZHeaderView *headerNav;
@property (weak, nonatomic) IBOutlet UIView *backgroundNav;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnBackTop;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) JackpotHeaderView *headerView;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)backTopButtonPressed:(id)sender;

@end

@implementation JackpotBrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [FZData sharedInstance].selectedJackpotSortIndex = 0;
    
    [self setStyling];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.headerView setNeedsLayout];
    [self.headerView layoutIfNeeded];
    
    self.headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [JackpotHeaderView estimateHeight]);
    [self.tableView setTableHeaderView:self.headerView];

    [self.tableView setContentOffset:CGPointMake(0, 64)];
    
}

- (void)setStyling{
    
    UINib *headerNib = [UINib nibWithNibName:@"JackpotHeaderView" bundle:nil];
    self.headerView = [[headerNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.headerView.delegate = self;
    [self.tableView setTableHeaderView:self.headerView];
    
    UINib *sectionNib = [UINib nibWithNibName:@"JackpotSectionTableViewCell" bundle:nil];
    [self.tableView registerNib:sectionNib forCellReuseIdentifier:@"Section"];
    
    UINib *cellNib = [UINib nibWithNibName:@"JackpotEnterTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    self.headerNav.backgroundColor = [UIColor clearColor];
    self.backgroundNav.alpha = 0;
    self.lbTitle.hidden = YES;
    self.btnBackTop.hidden = YES;
    

    [self.btnBackTop setImage:[UIImage imageNamed:@"icon-back-top"] forState:UIControlStateNormal];
    [self.btnBackTop setImage:[UIImage imageNamed:@"icon-back-top-tapping"] forState:UIControlStateHighlighted];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JackpotEnterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    JackpotSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Section"];
    cell.delegate = self;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0f;
}

#pragma mark - JackpotEnterTableViewCellDelegate
- (void)jackpotEnterCellTapped{
    [self endTimer];
    
    JackpotConfirmViewController *confirmView = (JackpotConfirmViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"JackpotConfirmView"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:confirmView];
    nav.navigationBar.hidden = YES;
    nav.view.backgroundColor = [UIColor clearColor];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma -mark UIScrollView 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat headerViewHight = [JackpotHeaderView estimateHeight];
    
    int realPosition = scrollView.contentOffset.y;
    
    if (realPosition >= headerViewHight) {
        float ratio = realPosition-headerViewHight;
        double coef = MIN(1,ratio/32);
        self.backgroundNav.alpha = (float)coef;
        self.lbTitle.hidden = NO;
        self.btnBackTop.hidden = NO;
    } else {
        self.backgroundNav.alpha = 0;
        self.lbTitle.hidden = YES;
        self.btnBackTop.hidden = YES;
    }
    
    if (scrollView.contentOffset.y < 64) {
        [self.tableView setContentOffset:CGPointMake(0, 64)];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endTimer];
}

#pragma mark - JackpotHeaderViewDelegate
- (void)learnMoreButtonPressed{
    JackpotLearnMoreViewController *learnView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotLearnMoreView"];
    [self.navigationController pushViewController:learnView animated:YES];
}

#pragma mark - JackpotSectionTableViewCellDelegate
- (void)sortButtonPressed{
    JackpotSortViewController *sortView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotSortView"];
    sortView.delegate = self;
    [self.navigationController pushViewController:sortView animated:YES];
}

- (void)refineButtonPressed{
    
}

#pragma mark - JackpotSortViewControllerDelegate
- (void)changeSortItem{
    [[NSNotificationCenter defaultCenter] postNotificationName:JACKPOT_SORT object:nil];
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backTopButtonPressed:(id)sender {
//    [self.tableView setContentOffset:CGPointMake(0, 64)];
//    [self updateBackTopButton:YES];

    __block CGFloat lastOffest = self.tableView.contentOffset.y;
    if (!self.timer) {
        self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:0.1 block:^(NSTimer *timer) {
            lastOffest = lastOffest - 30;
            [self.tableView setContentOffset:CGPointMake(0, lastOffest)];
            if (lastOffest <= 64) {
                [self endTimer];
            }

        } repeats:YES];
    }
}

- (void)endTimer{
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
        
//        [self updateBackTopButton:NO];
    }
}

- (void)updateBackTopButton:(BOOL)tapping{
    if (tapping) {
        [self.btnBackTop setImage:[UIImage imageNamed:@"icon-back-top-tapping"] forState:UIControlStateNormal];
    } else{
        [self.btnBackTop setImage:[UIImage imageNamed:@"icon-back-top"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
