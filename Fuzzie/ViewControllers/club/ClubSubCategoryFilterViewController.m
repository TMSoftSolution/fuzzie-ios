//
//  ClubSubCategoryFilterViewController.m
//  
//
//  Created by joma on 6/26/18.
//

#import "ClubSubCategoryFilterViewController.h"
#import "ClubSubCategoryFilterTableViewCell.h"
#import "ClubSubCategoryFilterTypeTableViewCell.h"

@interface ClubSubCategoryFilterViewController () <UITableViewDelegate, UITableViewDataSource, ClubSubCategoryFilterTableViewCellDelegate, ClubSubCategoryFilterTypeTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnApply;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)resetButtonPressed:(id)sender;
- (IBAction)applyButtonPressed:(id)sender;

@end

@implementation ClubSubCategoryFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setStyling];
}

- (void)initData{
    
    self.categories = self.brandType[@"categories"];
    self.filters = self.brandType[@"filters"];
    
    if (!self.selectedCategories) {
        self.selectedCategories = [NSMutableArray new];
    }
    
    if (!self.selectedComponents) {
        self.selectedComponents = [NSMutableArray new];
    }
}

- (void)setStyling{
    
    [self.btnApply setBackgroundColor:[UIColor colorWithHexString:HEX_COLOR_RED]];
    
    UINib *categoryNib = [UINib nibWithNibName:@"ClubSubCategoryFilterTableViewCell" bundle:nil];
    [self.tableView registerNib:categoryNib forCellReuseIdentifier:@"CategoryCell"];
    
    UINib *typeNib = [UINib nibWithNibName:@"ClubSubCategoryFilterTypeTableViewCell" bundle:nil];
    [self.tableView registerNib:typeNib forCellReuseIdentifier:@"TypeCell"];
}

#pragma mark - UITalbeViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.filters.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
        
    } else if (section > 0 && section <= self.filters.count){
        
        NSDictionary *filter = self.filters[section - 1];
        NSArray *components = filter[@"components"];
        return components.count;
        
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        float width = ([UIScreen mainScreen].bounds.size.width - 40.0f) / 2;
        float height = width * 70 / 140;
        NSUInteger count = (self.categories.count + 1) / 2;
        return height * count + 10 *(count - 1) + 10;
        
    } else if (indexPath.section > 0 && indexPath.section <= self.filters.count){
        
        return 55.0f;
    }
    
    return 0.0f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        ClubSubCategoryFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
        [cell setCell:self.categories selectedCategories:self.selectedCategories];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section > 0 && indexPath.section <= self.filters.count){
        
        ClubSubCategoryFilterTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeCell"];
        NSDictionary *filter = self.filters[indexPath.section - 1];
        NSArray *components = filter[@"components"];
        NSDictionary *component = components[indexPath.row];
        [cell setCell:component checked:[self.selectedComponents containsObject:component]];
        cell.delegate = self;
        return cell;
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 55.0f;
        
    } else if (section > 0 && section <= self.filters.count){
        
        return 55.0f;
        
    }
    
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 55)];
        [view setBackgroundColor:[UIColor whiteColor]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, tableView.frame.size.width, 20)];
        [label setFont:[UIFont fontWithName:FONT_NAME_BLACK size:14]];
        [label setText:@"CATEGORIES"];
        [label setTextColor:[UIColor colorWithHexString:@"262626"]];
        [view addSubview:label];
        
        return view;
        
    } else if (section > 0 && section <= self.filters.count){
        
        NSDictionary *filter = self.filters[section - 1];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 55)];
        [view setBackgroundColor:[UIColor whiteColor]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, tableView.frame.size.width, 20)];
        [label setFont:[UIFont fontWithName:FONT_NAME_BLACK size:14]];
        [label setText:[filter[@"name"] uppercaseString]];
        [label setTextColor:[UIColor colorWithHexString:@"262626"]];
        [view addSubview:label];
        
        UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectMake(15, 54, tableView.frame.size.width, 1)];
        [topSeparator setBackgroundColor:[UIColor colorWithHexString:@"E5E5E5"]];
        [view addSubview:topSeparator];
        
        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01f;
}

#pragma mark - ClubSubCategoryFilterTableViewCellDelegate
- (void)categoryCellTapped:(NSDictionary *)category{
    
    if ([self.selectedCategories containsObject:category]) {
        
        [self.selectedCategories removeObject:category];
        
    } else {
        
        [self.selectedCategories addObject:category];
    }
    
    [self.tableView reloadData];
}

#pragma mark - ClubSubCategoryFilterTypeTableViewCellDelegate
- (void)componentSelected:(NSDictionary *)component{
    
    if ([self.selectedComponents containsObject:component]) {
        
        [self.selectedComponents removeObject:component];
        
    } else {
        
        [self.selectedComponents addObject:component];
    }
    
    [self.tableView reloadData];
}

#pragma mark - IBAction Helper
- (IBAction)resetButtonPressed:(id)sender {
    
    self.selectedCategories = [NSMutableArray new];
    self.selectedComponents = [NSMutableArray new];
    
    [self.tableView reloadData];
}

- (IBAction)applyButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(filterApplied:components:)]) {
        [self.delegate filterApplied:self.selectedCategories components:self.selectedComponents];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
