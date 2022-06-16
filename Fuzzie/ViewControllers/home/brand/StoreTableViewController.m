//
//  StoreTableViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 24/3/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "StoreTableViewController.h"
#import "StoreHeaderTableViewCell.h"
#import "StorePhoneTableViewCell.h"
#import "StoreOpeningTableViewCell.h"

@interface StoreTableViewController () <UITableViewDataSource, UITableViewDelegate, StorePhoneTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backButtonPressed:(id)sender;

@end

@implementation StoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.brand) {
        self.storeArray = self.brand.stores;
    }
    
    [self setStyling];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.storeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    FZStore *store = self.storeArray[section];
    BOOL hasPhone = (store.phone && store.phone.length > 0);
    BOOL hasOpening = (store.businessHours && store.businessHours.length > 0);
    
    if (hasPhone && hasOpening) {
        return 3;
    } else if (hasPhone || hasOpening) {
        return 2;
    } else {
        return 1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FZStore *store = self.storeArray[indexPath.section];
    BOOL hasPhone = (store.phone && store.phone.length > 0);
    
    if (indexPath.row == 0) {
        
        StoreHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreHeaderCell" forIndexPath:indexPath];
        
        cell.storeNameLabel.text = store.name;
        cell.storeAddressLabel.text = [[store.address stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        return cell;
        
    } else if (indexPath.row == 1) {
        // Possible to have no phone but valid opening hours
        if (hasPhone) {
            StorePhoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StorePhoneCell" forIndexPath:indexPath];
            cell.phoneLabel.text = store.phone;
            cell.index = indexPath.section;
            cell.delegate = self;
            return cell;
            
        } else { // Infer hasOpening
            StoreOpeningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreOpeningCell" forIndexPath:indexPath];
            cell.openingLabel.text = [store.businessHours stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            return cell;
        }
        
    } else {
        
        StoreOpeningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreOpeningCell" forIndexPath:indexPath];
        cell.openingLabel.text = [store.businessHours stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        return cell;
    }
    
    return nil;
}

#pragma mark - StorePhoneTableViewCellDelegate
- (void)phoneButtonPressed:(NSUInteger)index{
    FZStore *store = self.storeArray[index];
    
    UIAlertView *alert = [[UIAlertView alloc] bk_initWithTitle:[NSString stringWithFormat:@"Call %@",store.name] message:[NSString stringWithFormat:@"Dial %@", store.phone]];
    [alert bk_addButtonWithTitle:@"Cancel" handler:nil];
    [alert bk_addButtonWithTitle:@"Call" handler:^{
        NSString *phoneNumber = [@"tel://" stringByAppendingString:[store.phone stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }];
    [alert show];
}

#pragma mark - Helper Functions

- (void)setStyling {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
}


@end
