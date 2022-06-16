//
//  JackpotLearnMoreViewController.m
//  Fuzzie
//
//  Created by mac on 9/10/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotLearnMoreViewController.h"
#import "InstructionTableViewCell.h"

@interface JackpotLearnMoreViewController () <UITableViewDataSource, UITableViewDelegate>{
    NSMutableDictionary * mImageHeightDic;
}

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *instructionsArray;

- (IBAction)backButtonPressed:(id)sender;
@end

@implementation JackpotLearnMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mImageHeightDic = [NSMutableDictionary dictionary];
    
    [self setStyling];
    
    if (self.isClubTerms) {
        
        self.instructionsArray = [FZData sharedInstance].clubTerms;
        
    } else if (self.isClubFaq){
        
        self.instructionsArray = [FZData sharedInstance].clubFaqs;
        
    } else {
        
        [self loadInstructions];
    }

}

- (void)setStyling{
    
    if (self.isRedPacket) {
        self.headerLabel.text = @"LUCKY PACKETS FAQ";
    } else if (self.isClubFaq){
        self.headerLabel.text = @"FUZZIE CLUB FAQ";
        self.tableView.tableHeaderView = nil;
    } else if (self.isClubTerms){
        self.headerLabel.text = @"TERMS & CONDITIONS";
        self.tableView.tableHeaderView = nil;
    }
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200.0f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.instructionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *instructionDict = self.instructionsArray[indexPath.row];
    
    InstructionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstructionCell"];
    if (cell == nil) {
        cell = [[InstructionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InstructionCell"];
    }
    
    
    if (instructionDict[@"title"] && [instructionDict[@"title"] isKindOfClass:[NSString class]]) {
        cell.headerLabel.text = instructionDict[@"title"];
    } else {
        cell.headerLabel.text = @"";
    }
    
    if (instructionDict[@"body"] && [instructionDict[@"body"] isKindOfClass:[NSString class]]) {
        cell.bodyLabel.text = instructionDict[@"body"];
        
    } else {
        cell.bodyLabel.text = @"";
    }
    
    if (instructionDict[@"image"] && [instructionDict[@"image"] isKindOfClass:[NSString class]]) {
        
        __weak NSString * indexKey = [NSString stringWithFormat:@"%lu", (long)indexPath.row];
        NSNumber *imageHeight = [mImageHeightDic objectForKey:indexKey];
        
        cell.instructionImageViewTopConstraint.constant = 12.0f;
        [cell.instructionImageView sd_setImageWithURL:[NSURL URLWithString:instructionDict[@"image"]] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            if (!imageHeight) {
                if (image) {
                    
                    CGFloat tempHeight = image.size.height / image.size.width * cell.instructionImageView.frame.size.width;
                    [mImageHeightDic setObject:[NSNumber numberWithFloat:tempHeight] forKey:indexKey];
                    
                    [tableView beginUpdates];
                    cell.instructionImageViewHeightContstraint.constant = tempHeight;
                    [tableView endUpdates];
                } else{
                    [mImageHeightDic setObject:[NSNumber numberWithFloat:0] forKey:indexKey];
                }
            } else{
                cell.instructionImageViewHeightContstraint.constant = [imageHeight floatValue];
                
            }
        }];
        
        
    } else {
        cell.instructionImageView.image = nil;
        cell.instructionImageViewTopConstraint.constant = 0.0f;
        cell.instructionImageViewHeightContstraint.constant = 0.0f;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 20.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20.0f);
    view.frame = rect;
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

- (void)loadInstructions {
    
    if (self.isRedPacket) {
        [RedPacketController getLearnMore:^(NSArray *array, NSError *error) {
            
            if (error) {
                if (error.code == 417) {
                    [AppDelegate logOut];
                    return ;
                }
                [self showFail:[error localizedDescription] buttonTitle:@"OK" window:YES];
            } else {
                
                self.instructionsArray = array;
            }
            
            self.tableView.tableHeaderView = nil;
            [self.tableView reloadData];
            
        }];
    } else {
        
        [JackpotController getCouponLearnMore:^(NSArray *array, NSError *error) {
            
            if (error) {
                if (error.code == 417) {
                    [AppDelegate logOut];
                    return ;
                }
                [self showFail:[error localizedDescription] buttonTitle:@"OK" window:YES];
            } else {
                
                self.instructionsArray = array;
            }
            
            self.tableView.tableHeaderView = nil;
            [self.tableView reloadData];
        }];
    }
 
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
