//
//  ClubStoreFilterViewController.m
//  Fuzzie
//
//  Created by joma on 6/20/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreFilterViewController.h"
#import "ClubStoreFilterTableViewCell.h"

@interface ClubStoreFilterViewController () <UITableViewDataSource, UITableViewDelegate, ClubStoreFilterTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnApply;

- (IBAction)filterButtonPressed:(id)sender;
- (IBAction)resetButtonPressed:(id)sender;
- (IBAction)allButtonPressed:(id)sender;

@end

@implementation ClubStoreFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setStyling];
}

- (void)initData{
    
    if (!self.selectedBrandTypes) {
        self.selectedBrandTypes = [[NSMutableArray alloc] init];
    }
}

- (void)setStyling{
    
    self.btnApply.backgroundColor = [UIColor colorWithHexString:HEX_COLOR_RED];
    
    UINib *nib = [UINib nibWithNibName:@"ClubStoreFilterTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [FZData sharedInstance].clubBrandTypes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, tableView.frame.size.width, 16)];
    [label setFont:[UIFont fontWithName:FONT_NAME_BLACK size:14]];
    [label setText:@"CATEGORIES"];
    [label setTextColor:[UIColor colorWithHexString:@"262626"]];
    [view addSubview:label];
    
    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 49, tableView.frame.size.width, 1)];
    [bottomSeparator setBackgroundColor:[UIColor colorWithHexString:@"E5E5E5"]];
    [view addSubview:bottomSeparator];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, tableView.frame.size.width, 20)];
    [label setFont:[UIFont fontWithName:FONT_NAME_LATO_REGULAR size:16]];
    [label setText:@"More categories coming soon."];
    [label setTextColor:[UIColor colorWithHexString:@"ADADAD"]];
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClubStoreFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary *dict = [[FZData sharedInstance].clubBrandTypes objectAtIndex:indexPath.row];
    [cell setCell:dict checked:[self.selectedBrandTypes containsObject:dict]];
    cell.delegate = self;
    return cell;
}

#pragma mark - ClubStoreFilterTableViewCellDelegate
- (void)cellTapped:(NSDictionary*)category checked:(BOOL)checked{
    
    if (checked) {
        
        [self.selectedBrandTypes removeObject:category];
        
    } else{
        
        [self.selectedBrandTypes addObject:category];
    }
    
    [self.tableView reloadData];
}

#pragma mark - IBAction Helper
- (IBAction)filterButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(filterApplied:)]) {
        [self.delegate filterApplied:self.selectedBrandTypes];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resetButtonPressed:(id)sender {
    
    self.selectedBrandTypes = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
}

- (IBAction)allButtonPressed:(id)sender {
    
    self.selectedBrandTypes = [[NSMutableArray alloc] initWithArray:[FZData sharedInstance].clubBrandTypes];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
