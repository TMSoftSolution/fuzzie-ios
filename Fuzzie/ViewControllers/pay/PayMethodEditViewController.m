//
//  PayMethodEditViewController.m
//  Fuzzie
//
//  Created by mac on 8/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "PayMethodEditViewController.h"
#import "PayMethodEditTableViewCell.h"
#import "PayMethodAddViewController.h"
#import "PayViewController.h"
#import "FZRedeemPopView.h"
#import "TopUpPayViewController.h"
#import "ClubSubscribePayViewController.h"

@interface PayMethodEditViewController () <UITableViewDelegate, UITableViewDataSource, PayMethodEditTableViewCellDelegate, FZRedeemPopViewDelegate, PayMethodAddViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightAnchor;
@property (weak, nonatomic) IBOutlet UILabel *lbEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIView *creditAddView;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)editButtonPressed:(id)sender;
- (IBAction)addButtonPressed:(id)sender;

@property (strong, nonatomic) FZRedeemPopView *redeemPopView;

@end

@implementation PayMethodEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setStyling];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateEditButton];
}

- (void)initData{
    
    self.selectedItem = 0;
    
    if ([PaymentController sharedInstance].paymentMethods) {
        self.paymentMethods = [[NSMutableArray alloc] initWithArray:[PaymentController sharedInstance].paymentMethods];
        if (!self.dontShowNets) {
            [self.paymentMethods addObject:[[NetsUtils sharedInstance] netsPaymentMethod]];
        }
        
    } else {
        [PaymentController getPaymentMethodsWithCompletion:^(NSArray *array, NSError *error) {
            
            if (error) {
                return ;
            }
            
            if (array) {
                self.paymentMethods = [[NSMutableArray alloc] initWithArray:array];
                if (!self.dontShowNets) {
                    [self.paymentMethods addObject:[[NetsUtils sharedInstance] netsPaymentMethod]];
                }
                [self.tableView reloadData];
                self.tableViewHeightAnchor.constant = self.tableView.contentSize.height;
                [self updateEditButton];
            }
            
        }];
    }
}

- (void)setStyling{
    
    UINib *redeemPopViewNib = [UINib nibWithNibName:@"FZRedeemPopView" bundle:nil];
    self.redeemPopView = [[redeemPopViewNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.redeemPopView.delegate = self;
    [self.redeemPopView setPaymentMethodDeleteStyle];
    [self.view addSubview:self.redeemPopView];
    self.redeemPopView.frame = self.view.frame;
    self.redeemPopView.hidden = YES;
    
    UINib *cellNib = [UINib nibWithNibName:@"PayMethodEditTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    [self.tableView reloadData];
    self.tableViewHeightAnchor.constant = self.tableView.contentSize.height;
}

- (void) updateEditButton{
    if (self.paymentMethods && self.paymentMethods.count > 0) {
        self.lbEdit.hidden = NO;
        self.btnEdit.hidden = NO;
    } else{
        self.lbEdit.hidden = YES;
        self.btnEdit.hidden = YES;
        self.isEditing = false;
        self.creditAddView.hidden = NO;
    }
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editButtonPressed:(id)sender {
    self.isEditing = !self.isEditing;
    if (self.isEditing) {
        self.lbEdit.text = @"Done";
        self.creditAddView.hidden = YES;
    } else{
        self.lbEdit.text = @"Edit";
        self.creditAddView.hidden = NO;
    }
    [self.tableView reloadData];
    self.tableViewHeightAnchor.constant = self.tableView.contentSize.height;
}

- (IBAction)addButtonPressed:(id)sender {
    PayMethodAddViewController *addView = [self.storyboard instantiateViewControllerWithIdentifier:@"PayMethodAddView"];
    addView.fromPaymentPage = self.fromPaymentPage;
    [self.navigationController pushViewController:addView animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isEditing && !self.dontShowNets) {
        
        return self.paymentMethods.count - 1;
        
    } else {
        
        return self.paymentMethods.count;
    }


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.paymentMethods.count == 0) {
        return 0.0f;
    }
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PayMethodEditTableViewCell *cell = (PayMethodEditTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    BOOL isSelected = [[FZData sharedInstance].selectedPaymentMethod[@"token"] isEqualToString:self.paymentMethods[indexPath.row][@"token"]];
    [cell setCell:self.paymentMethods[indexPath.row] isSelected:isSelected isEditing:self.isEditing position:(int)indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.paymentMethods.count == 0) {
        return 0.0f;
    }
    return 44.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, tableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:FONT_NAME_MEDIUM size:13]];
    [label setText:@"PREFERRED PAYMENT METHOD"];
    [label setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1.0]];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 43, tableView.frame.size.width, 1)];
    [view addSubview:separator];
    [separator setBackgroundColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0]];
    return view;
}

#pragma mark - PayMethodEditTableViewCellDelegate
- (void)cellTapped:(NSDictionary *)itemDict position:(int)position{

    if ([itemDict[@"card_type"] isEqualToString:@"ENETS"]) {
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"netspay://"]]) {
            
            [self backPaymentPage:itemDict position:position];
            
        } else {
            
            [self showNetsInstallPop];
            
        }
        
    } else {
        
        [self backPaymentPage:itemDict position:position];
    }
}

- (void)backPaymentPage:(NSDictionary *)itemDict position:(int)position{
    
    [FZData sharedInstance].tempCardInfoInputed = false;
    [FZData sharedInstance].tempCardInfo = nil;
    
    self.selectedItem = position;
    [self.tableView reloadData];
    [FZData sharedInstance].selectedPaymentMethod = itemDict;
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *viewController in viewControllers){
        if ([viewController isKindOfClass:[PayViewController class]] ||
            [viewController isKindOfClass:[TopUpPayViewController class]] ||
            [viewController isKindOfClass:[ClubSubscribePayViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
    
}

- (void)showNetsInstallPop{
    
    [self showError:@"Would you like to set up NETSPay account now?" headerTitle:@"SET UP NETSPay" buttonTitle:@"YES, SET UP NOW" image:@"bear-baby" window:NO];
    self.popView.btnCancel.hidden = NO;
    [self.popView.btnCancel setTitle:@"No, cancel" forState:UIControlStateNormal];
    self.showNetsInstall = YES;
    
}

- (void)openAppStoreForNets{
    
    NSString *appstoreUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1259180781"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appstoreUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrl]];
    }
}

- (void)deleteButtonPressed:(NSDictionary *)itemDict{
    self.selectedDict = itemDict;
    self.redeemPopView.hidden = NO;
}


#pragma mark - PayMethodAddViewControllerDelegate
- (void)paymentMethodAdded:(NSDictionary *)methodDict{
    
    NSMutableArray *tempArray;
    tempArray = [[NSMutableArray alloc] initWithArray:[PaymentController sharedInstance].paymentMethods];
    [tempArray addObject:[NetsUtils sharedInstance].netsPaymentMethod];
    self.paymentMethods = tempArray;
    
    [self.tableView reloadData];
    self.tableViewHeightAnchor.constant = self.tableView.contentSize.height;

}

#pragma mark - FZRedeemPopViewDelegate
- (void)redeemButtonPressed{
    self.redeemPopView.hidden = YES;
    [self deletePaymentItem];
}

- (void)cancelButtonPressed{
    self.redeemPopView.hidden = YES;
}

#pragma mark - FZPopViewDelegate
- (void)okButtonClicked{
    [super okButtonClicked];
    
    if (self.showNetsInstall) {
        
        self.showNetsInstall = NO;
        [self openAppStoreForNets];
    }
}

- (void)cancelButtonClicked{
    [super cancelButtonClicked];
    
    self.showNetsInstall = NO;
}

#pragma mark - Helper
- (void)deletePaymentItem{
    
    [self showProcessing:@"REMOVING" atWindow:NO];
    [PaymentController removePaymentMethodWithPaymentToken:self.selectedDict[@"token"] andCompletion:^(NSError *error) {
        
        [self hidePopView];
        
        if (error) {
            if ( error.code == 417) {
                [AppDelegate logOut];
                return ;
            } else{
                [self showEmptyError:[error localizedDescription] buttonTitle:@"OK" window:NO];
            }
            
        } else {
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[PaymentController sharedInstance].paymentMethods];
            [tempArray removeObject:self.selectedDict];
            [PaymentController sharedInstance].paymentMethods = [[NSArray alloc] initWithArray:tempArray];
            if (!self.dontShowNets) {
                [tempArray addObject:[NetsUtils sharedInstance].netsPaymentMethod];
            }
            self.paymentMethods = tempArray;
            [self.tableView reloadData];
            self.tableViewHeightAnchor.constant = self.tableView.contentSize.height;
            
            [FZData sharedInstance].selectedPaymentMethod = nil;
            
            [self updateEditButton];

        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
