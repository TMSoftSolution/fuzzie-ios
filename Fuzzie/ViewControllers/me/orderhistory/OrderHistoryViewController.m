//
//  OrderHistoryViewController.m
//  Fuzzie
//
//  Created by mac on 8/4/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "OrderHistoryViewController.h"
#import "OrderHistoryTableViewCell.h"
#import "OrderDetailsViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "OrderHistoryHeaderView.h"
#import "OrderHistoryEmptyView.h"

const int LIMIT_PER_PAGE = 10;

@interface OrderHistoryViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, OrderHistoryTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) OrderHistoryHeaderView *headerView;
@property (strong, nonatomic) OrderHistoryEmptyView *emptyView;

@property (strong, nonatomic) UIView *footerView;

@property (strong, nonatomic) NSMutableArray *orderArrays;

@property (assign, nonatomic) int page;
@property (assign, nonatomic) BOOL loading;
@property (assign, nonatomic) BOOL isLast;


@end

@implementation OrderHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
    [self loadFirstOrderPage];
}

- (void)setStyling{
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadFirstOrderPage)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.refreshControl.tintColor = [UIColor clearColor];
    
    UINib *headerNib = [UINib nibWithNibName:@"OrderHistoryHeaderView" bundle:nil];
    self.headerView = [[headerNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self.tableView setTableHeaderView:self.headerView];
    self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 15 / 32);
    
    UINib *emptyViewNib = [UINib nibWithNibName:@"OrderHistoryEmptyView" bundle:nil];
    self.emptyView = [[emptyViewNib instantiateWithOwner:self options:nil] objectAtIndex:0];

    UINib *orderHistoryCellNib = [UINib nibWithNibName:@"OrderHistoryTableViewCell" bundle:nil];
    [self.tableView registerNib:orderHistoryCellNib forCellReuseIdentifier:@"OrderHistoryCell"];
    
}

- (void)loadFirstOrderPage{
    
    self.page = 1;
    self.loading = NO;
    self.isLast = NO;
    
    [self showLoader];
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }

    [UserController getOrdersWithPage:self.page andLimit:LIMIT_PER_PAGE withCompletion:^(NSArray *array, NSError *error) {
        [self hideLoader];
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            } else{
                [self showFail:[error localizedDescription] buttonTitle:@"OK" window:YES];
            }
        }
        
        if (array) {
            
            self.tableView.emptyDataSetSource = self;
            self.tableView.emptyDataSetDelegate = self;
            if (!self.orderArrays) {
                self.orderArrays = [[NSMutableArray alloc] init];
            } else{
                [self.orderArrays removeAllObjects];
            }
            [self.orderArrays addObjectsFromArray:array];
            [self.tableView reloadData];
            
            self.isLast = array.count % LIMIT_PER_PAGE != 0 || array.count == 0;
        }
    }];
}

- (void)loadNextPageOrder{
    self.page ++ ;
    
    [UserController getOrdersWithPage:self.page andLimit:LIMIT_PER_PAGE withCompletion:^(NSArray *array, NSError *error) {
        
        self.loading = NO;
        [(UIActivityIndicatorView *)[self.footerView viewWithTag:10] stopAnimating];
        
        if (error) {
            self.page -- ;
        }
        
        if (array) {
            [self.orderArrays addObjectsFromArray:array];
            [self.tableView reloadData];
            
            self.isLast = array.count % LIMIT_PER_PAGE != 0 || array.count == 0;
        }
    }];

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, tableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:FONT_NAME_BLACK size:14]];
    NSString *string = @"YOUR TRANSACTIONS";
    
    [label setText:string];
    [label setTextColor:[UIColor colorWithRed:95/255.0 green:94/255.0 blue:94/255.0 alpha:1.0]];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.orderArrays.count == 0) {
        return 0.0f;
    }
    return 42.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 40.0)];
    
    UIActivityIndicatorView * actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    actInd.tag = 10;
    
    actInd.frame = CGRectMake(tableView.frame.size.width / 2 - 10, 5.0, 20.0, 20.0);
    
    actInd.hidesWhenStopped = YES;
    
    [self.footerView addSubview:actInd];
    
    actInd = nil;
    
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.orderArrays.count == 0) {
        return 0.0f;
    }
    return 42.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderArrays.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderHistoryTableViewCell *cell = (OrderHistoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"OrderHistoryCell"];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderHistoryTableViewCell *historyCell = (OrderHistoryTableViewCell*)cell;
    [historyCell setCellWithDict:self.orderArrays[indexPath.row]];

}

#pragma -mark DZNEmptyDataSet

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    return self.emptyView;
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return self.tableView.tableHeaderView.frame.size.height/2.0f - 21;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}

- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView {
    [self.emptyView refreshSize];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height - 20)) {

        if(!self.loading && !self.isLast && !scrollView.dragging && !scrollView.decelerating){
            self.loading = YES;
            [(UIActivityIndicatorView *)[self.footerView viewWithTag:10] startAnimating];
            [self loadNextPageOrder];
        }
    }
}

#pragma mark - OrderHistoryTableViewCellDelegate
- (void)cellTapped:(NSDictionary *)dict{
    OrderDetailsViewController *detailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailsView"];
    detailsView.dict = dict;
    [self.navigationController pushViewController:detailsView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
