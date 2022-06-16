//
//  BankListViewController.m
//  Fuzzie
//
//  Created by mac on 8/22/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BankListViewController.h"
#import "BankListTableViewCell.h"
#import "BankViewController.h"


@interface BankListViewController () <UITableViewDataSource, UITableViewDelegate, BankListTableViewCellDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation BankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self setStyling];
    
    self.bankArray = [[NSArray alloc] init];
    if ([PaymentController sharedInstance].bankArray) {
        self.bankArray = [PaymentController sharedInstance].bankArray;
        [self.tableView reloadData];
    } else{
        [self loadBank];
    }
}

- (void)setStyling{
       
    UINib *cellNib = [UINib nibWithNibName:@"BankListTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadBank)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.refreshControl.tintColor = [UIColor clearColor];

}

- (void)loadBank{
    
    [self showLoader];
    [PaymentController getBanksWithCompletion:^(NSArray *array, NSError *error) {
        
        [self hideLoader];
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
            }
            
            return ;
        }
        
        if (array && array.count > 0) {
            self.bankArray = array;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bankArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankListTableViewCell *cell = (BankListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *dict = [self.bankArray objectAtIndex:indexPath.row];
    [cell setCellWith:dict];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.bankArray.count == 0) {
        return 0.0f;
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    return screenWidth * 130 / 320;
}

#pragma mark - BankListTableViewCellDelegate
- (void)cellTapped:(NSDictionary *)dict{
    BankViewController *bankView = (BankViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BankView"];
    bankView.bankDict = dict;
    [self.navigationController pushViewController:bankView animated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
