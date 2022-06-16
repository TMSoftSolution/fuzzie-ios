//
//  ShoppingBagViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 24/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "ShoppingBagViewController.h"
#import "BagTableViewCell.h"
#import "LoadingTableViewCell.h"
#import "PayViewController.h"

@interface ShoppingBagViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray *bagArray;
@property (strong, nonatomic) NSMutableArray *bagItemArray;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *emptyView;

@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContainerBottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *deleteView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIView *checkoutContainerView;
@property (weak, nonatomic) IBOutlet UILabel *checkoutLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;

@property (assign, nonatomic) BOOL isEditing;

- (IBAction)checkoutButtonPressed:(id)sender;
- (IBAction)closeButtonPressed:(id)sender;
- (IBAction)editButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;

@end

@implementation ShoppingBagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyling];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadShoppingBag) name:SHOPPING_BAG_REFRESHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeButtonPressed:) name:SHOULD_DISMISS_VIEW object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHOPPING_BAG_REFRESHED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHOULD_DISMISS_VIEW object:nil];
}

#pragma mark - Button Actions

- (IBAction)checkoutButtonPressed:(id)sender {
    
    PayViewController *payView = [[GlobalConstants paymentStoryboard] instantiateViewControllerWithIdentifier:@"PayView"];
    
    NSMutableArray *itemArray = [NSMutableArray new];
    NSMutableArray *brandArray = [NSMutableArray new];
    for (NSDictionary *bagDict in self.bagArray) {
        
        FZBrand *brand = [MTLJSONAdapter modelOfClass:FZBrand.class fromJSONDictionary:bagDict[@"brand"] error:nil];
        
        NSMutableDictionary *itemDict;
        if (bagDict[@"item"][@"gift_card"]) {
            itemDict = [bagDict[@"item"][@"gift_card"] mutableCopy];
        } else if (bagDict[@"item"][@"service"]) {
            itemDict = [bagDict[@"item"][@"service"] mutableCopy];
        }
        [itemDict setObject:bagDict[@"cash_back"] forKey:@"cash_back"];
        [itemDict setObject:bagDict[@"selling_price"] forKey:@"discounted_price"];
        
        [itemArray addObject:itemDict];
        [brandArray addObject:brand];
    }
    
    payView.brandArray = brandArray;
    payView.itemArray = itemArray;
    payView.shoppingBag = YES;
    
    [self.navigationController pushViewController:payView animated:YES];
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editButtonPressed:(id)sender {
    self.isEditing = !self.isEditing;
    if (self.isEditing) {
        [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
        self.checkoutContainerView.hidden = YES;
        self.deleteView.hidden = NO;
        self.bottomContainerBottomConstraint.constant = 55;
    } else {
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
        self.checkoutContainerView.hidden = NO;
        self.deleteView.hidden = YES;
        self.bottomContainerBottomConstraint.constant = 80;
    }
    
    self.bagItemArray = [@[] mutableCopy];
    [self setDeleteButtonStyle];
    [self.tableView reloadData];
}

- (IBAction)deleteButtonPressed:(id)sender {
    [self showNormalWith:@"REMOVING" window:YES];
    [GiftController removeItemToShoppingBagWithIDs:self.bagItemArray withCompletion:^(NSError *error) {
        [self hidePopView];
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            [self showFail:[error localizedDescription] window:YES];
        } else {
            [self updateTableViewWithBagDict:[FZData sharedInstance].bagDict];
        }
        
    }];
}

- (IBAction)startShoppingButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.bagArray) {
        return 1;
    } else {
        return self.bagArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.bagArray) {
        LoadingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell" forIndexPath:indexPath];
        [cell.activityView startAnimating];
        return cell;
    } else {
        BagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BagCell" forIndexPath:indexPath];
        
        NSDictionary *giftCardDict = self.bagArray[indexPath.row];
        cell.isEditing = self.isEditing;
        cell.isSelected = NO;
        [cell setCell:giftCardDict];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.bagArray) {
        return 44.0f;
    } else {
        return 128.0f;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BagTableViewCell *cell = (BagTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (self.isEditing) {
        
        NSDictionary *giftCardDict = self.bagArray[indexPath.row];
        
        NSString *itemId;
        if (giftCardDict[@"item"][@"gift_card"]) {
            itemId = giftCardDict[@"item"][@"gift_card"][@"type"];
        } else if (giftCardDict[@"item"][@"service"]) {
            itemId = giftCardDict[@"item"][@"service"][@"type"];
        }
        
        cell.isSelected = !cell.isSelected;
        if (cell.isSelected) {
            [cell.selectImage setImage:[UIImage imageNamed:@"bag_selected"]];
            [self.bagItemArray addObject:itemId];
        } else {
            [cell.selectImage setImage:[UIImage imageNamed:@"bag_deselected"]];
            [self.bagItemArray removeObject:itemId];
        }
        
        [self setDeleteButtonStyle];
        
    }
}

#pragma mark - Helper Functions

- (void)setStyling {
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    
    UINib *loadingCellNib = [UINib nibWithNibName:@"LoadingTableViewCell" bundle:nil];
    [self.tableView registerNib:loadingCellNib forCellReuseIdentifier:@"LoadingCell"];
    self.tableView.hidden = YES;
    self.emptyView.hidden = YES;
      
    [CommonUtilities setView:self.checkoutContainerView withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.btnStart withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    self.deleteView.hidden = YES;
    
    [self loadShoppingBag];
}

- (void)refreshData {
    [self.refreshControl endRefreshing];
    [GiftController getShoppingBagWithCompletion:^(NSDictionary *dictionary, NSError *error) {
        [self.refreshControl endRefreshing];
        [self updateTableViewWithBagDict:dictionary];
        
        if (error) {
        
            [self showErrorAlertTitle:@"Add to like Error" message:[error localizedDescription]  buttonTitle:@"OK"];
        }
    }];
}

- (void)loadShoppingBag {
    if ([FZData sharedInstance].bagDict) {
        NSDictionary *bagDict = [FZData sharedInstance].bagDict;
        [self updateTableViewWithBagDict:bagDict];
    } else {
        [self refreshData];
    }
}

- (void)updateTableViewWithBagDict:(NSDictionary *)bagDict {
    
    if (bagDict[@"items"]) {
        self.bagArray = [bagDict[@"items"] mutableCopy];
    } else {
        self.bagArray = [@[] mutableCopy];
    }
    
    [self.bagItemArray removeAllObjects];
    [self setDeleteButtonStyle];
    
    if (self.bagArray.count == 0) {
        self.emptyView.hidden = NO;
        self.tableView.hidden = YES;
        self.headerLabel.text = @"BAG";
        self.bottomContainerBottomConstraint.constant = 0.0f;
        self.editButton.hidden = YES;
        if (self.isEditing) {
            self.deleteView.hidden = YES;
        }
    } else {
        self.emptyView.hidden = YES;
        self.tableView.hidden = NO;
        self.headerLabel.text = [NSString stringWithFormat:@"BAG (%d)",(int)self.bagArray.count];
        self.bottomContainerBottomConstraint.constant = 80.0f;
        self.checkoutLabel.text = [NSString stringWithFormat:@"S$%.0f",[bagDict[@"total_price"] floatValue]];
        self.editButton.hidden = NO;

    }

    [self.tableView reloadData];
    
}

- (void)setDeleteButtonStyle{
    if (self.bagItemArray.count > 0) {
        [self.deleteButton setEnabled:YES];
        [self.deleteButton setTitleColor:[UIColor colorWithHexString:@"FA3E3F"] forState:UIControlStateNormal];
    } else {
        [self.deleteButton setEnabled:NO];
        [self.deleteButton setTitleColor:[UIColor colorWithHexString:@"A6A6A6"] forState:UIControlStateNormal];
    }
}

@end
