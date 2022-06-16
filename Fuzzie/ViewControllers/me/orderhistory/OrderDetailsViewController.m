//
//  OrderDetailsViewController.m
//  Fuzzie
//
//  Created by mac on 8/4/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "OrderDetailsDateTableViewCell.h"
#import "OrderDetailsBillTableViewCell.h"
#import "OrderDetailsPaymentMethodTableViewCell.h"

@interface OrderDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

typedef enum : NSUInteger {
    kOrderDetailSectionBill,
    kOrderDetailSectionPaymentMethod,
    kOrderDetailSectionCount
} kOrderDetailSection;

@implementation OrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.giftArrays = self.dict[@"gift_details"];
    [self setStyling];
}

- (void)setStyling{
    
    UINib *dateNib = [UINib nibWithNibName:@"OrderDetailsDateTableViewCell" bundle:nil];
    [self.tableView registerNib:dateNib forCellReuseIdentifier:@"DateCell"];
    
    UINib *billNib = [UINib nibWithNibName:@"OrderDetailsBillTableViewCell" bundle:nil];
    [self.tableView registerNib:billNib forCellReuseIdentifier:@"BillCell"];
    
    UINib *paymentCell = [UINib nibWithNibName:@"OrderDetailsPaymentMethodTableViewCell" bundle:nil];
    [self.tableView registerNib:paymentCell forCellReuseIdentifier:@"PaymentCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kOrderDetailSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == kOrderDetailSectionBill) {
        
        if (self.giftArrays.count == 0) {
            
            return 2;
            
        } else{
            
            return self.giftArrays.count + 1;
        }

    } else if (section == kOrderDetailSectionPaymentMethod){
        
        return 1;
        
    } else{
        
        return 0;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kOrderDetailSectionBill) {
        
        if (indexPath.row == 0) {
            
            OrderDetailsDateTableViewCell *cell = (OrderDetailsDateTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"DateCell"];
            [cell setCellWithDict:self.dict];
            return cell;
            
        } else{
            
            OrderDetailsBillTableViewCell *cell = (OrderDetailsBillTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"BillCell"];
            
            if (self.giftArrays.count == 0) {
                
                [cell setCell:self.dict];
                
            } else {
                
                BOOL isLast = indexPath.row == self.giftArrays.count;
                [cell setCellWithDict:self.giftArrays[indexPath.row - 1] withLast:isLast];
        
            }
            
            return cell;
        }
        
    } else if(indexPath.section == kOrderDetailSectionPaymentMethod){
        
        OrderDetailsPaymentMethodTableViewCell *cell = (OrderDetailsPaymentMethodTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"PaymentCell"];
        [cell setCellWithDict:self.dict cellType:CellTypeCredits];
        return cell;
        
    } else{
        
        return nil;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, tableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:FONT_NAME_BLACK size:14]];
    NSString *string = @"";
    if (section == kOrderDetailSectionBill) {
        string = @"YOUR BILL";
    } else if (section == kOrderDetailSectionPaymentMethod){
        string = @"PAYMENT METHODS USED";
    }
    
    [label setText:string];
    [label setTextColor:[UIColor colorWithRed:95/255.0 green:94/255.0 blue:94/255.0 alpha:1.0]];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == kOrderDetailSectionBill) {
        return 10.0f;
    } else{
        return 0.0f;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
