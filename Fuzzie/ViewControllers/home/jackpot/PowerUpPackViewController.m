//
//  PowerUpPackViewController.m
//  Fuzzie
//
//  Created by Joma on 2/9/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "PowerUpPackViewController.h"
#import "JackpotHomePageViewController.h"
#import "PowerUpNoteTableViewCell.h"
#import "PowerUpTableViewCell.h"
#import "JackpotCardViewController.h"
#import "PowerUpPackCardViewController.h"

typedef enum : NSUInteger {
    kPowerUpSectionNote,
    kPowerUpSectionCard,
    kPowerUpSectionCount,
} kPowerUpSection;

@interface PowerUpPackViewController () <UITableViewDataSource, UITableViewDelegate, PowerUpTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation PowerUpPackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
    
}

- (void)setStyling{
    
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *noteNib = [UINib nibWithNibName:@"PowerUpNoteTableViewCell" bundle:nil];
    [self.tableView registerNib:noteNib forCellReuseIdentifier:@"NoteCell"];
    
    UINib *cellNib = [UINib nibWithNibName:@"PowerUpTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#282828"];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kPowerUpSectionCount;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == kPowerUpSectionNote) {
        return 1;
        
    } else if (section == kPowerUpSectionCard){
        return self.coupons.count;
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kPowerUpSectionNote) {
        
        PowerUpNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell"];
        return cell;
        
    } else if (indexPath.section == kPowerUpSectionCard){
        
        PowerUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        [cell setCell:[self.coupons objectAtIndex:indexPath.row]];
        cell.delegate = self;
        return cell;
        
    }

    return nil;
}

#pragma mark - PowerUpRewardTableViewCellDelegate
- (void)powerupTableCellTapped:(FZCoupon*)coupon{
    PowerUpPackCardViewController *cardView = (PowerUpPackCardViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"PowerUpPackCardView"];
    cardView.coupon = coupon;
    [self.navigationController pushViewController:cardView animated:YES];
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
