//
//  ClubFavoriteFilterViewController.m
//  Fuzzie
//
//  Created by joma on 8/31/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubFavoriteFilterViewController.h"
#import "ClubStoreFilterTableViewCell.h"
#import "ClubSortTableViewCell.h"

typedef enum : NSUInteger {
    kSectionSort,
    kSectionCategory,
    kSectionCount
} kSection;

@interface ClubFavoriteFilterViewController () <UITableViewDelegate, UITableViewDataSource, ClubStoreFilterTableViewCellDelegate, ClubSortTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnApply;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)applyButtonPressed:(id)sender;
- (IBAction)allButtonPressed:(id)sender;

@end

@implementation ClubFavoriteFilterViewController

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
    
    UINib *nib1 = [UINib nibWithNibName:@"ClubSortTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"SortCell"];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case kSectionSort:
            return 1;
            break;
        case kSectionCategory:
            return [FZData sharedInstance].clubBrandTypes.count;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kSectionSort) {
        return 60.0f;
    } else if (indexPath.section == kSectionCategory){
        return 80.0f;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, tableView.frame.size.width, 16)];
    [label setFont:[UIFont fontWithName:FONT_NAME_BLACK size:14]];
    if (section == kSectionCategory) {
        [label setText:@"CATEGORIES"];
    } else if (section == kSectionSort){
        [label setText:@"SORT BY"];
    }
    
    [label setTextColor:[UIColor colorWithHexString:@"262626"]];
    [view addSubview:label];
    
    if (section == kSectionCategory){
        
        UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 49, tableView.frame.size.width, 1)];
        [bottomSeparator setBackgroundColor:[UIColor colorWithHexString:@"E5E5E5"]];
        [view addSubview:bottomSeparator];
        
    }

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == kSectionCategory) {
        return 70.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == kSectionCategory) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
        [view setBackgroundColor:[UIColor whiteColor]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, tableView.frame.size.width, 20)];
        [label setFont:[UIFont fontWithName:FONT_NAME_LATO_REGULAR size:16]];
        [label setText:@"More categories coming soon."];
        [label setTextColor:[UIColor colorWithHexString:@"ADADAD"]];
        [view addSubview:label];
        
        return view;
    }

    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kSectionCategory) {
        
        ClubStoreFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        NSDictionary *dict = [[FZData sharedInstance].clubBrandTypes objectAtIndex:indexPath.row];
        [cell setCell:dict checked:[self.selectedBrandTypes containsObject:dict]];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == kSectionSort){
        
        ClubSortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SortCell"];
        [cell setCell:self.sortDistance];
        cell.delegate = self;
        return cell;
    }
    
    return nil;

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

#pragma mark - ClubSortTableViewCellDelegate
- (void)sortSelected:(BOOL)sortDistance{
    
    self.sortDistance = sortDistance;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)applyButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(filterApplied:sortDistance:)]) {
        [self.delegate filterApplied:self.selectedBrandTypes sortDistance:self.sortDistance];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)allButtonPressed:(id)sender {
    
    self.selectedBrandTypes = [[NSMutableArray alloc] initWithArray:[FZData sharedInstance].clubBrandTypes];
    [self.tableView reloadData];
}
@end
