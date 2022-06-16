//
//  HowToRedeemViewController.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/19/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "HowToRedeemViewController.h"
#import "InstructionTableViewCell.h"

@interface HowToRedeemViewController () <UITableViewDataSource, UITableViewDelegate>{
    NSMutableDictionary * mImageHeightDic;
}

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HowToRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mImageHeightDic = [NSMutableDictionary dictionary];
    
    [self setStyling];
    [self loadInstructions];
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

#pragma mark - Helper Functions

- (void)setStyling {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200.0f;
}

- (void)loadInstructions {
    
    if (self.isPowerUp) {
        
        [BrandController getRedeemInstructionForPowerUp:^(NSArray *array, NSError *error) {
            
            if (error) {
                
                [self showFail:[error localizedDescription] buttonTitle:@"OK" window:YES];
            }
            
            if (array) {
                self.instructionsArray = array;
                self.tableView.tableHeaderView = nil;
                [self.tableView reloadData];
            }
            
        }];
        
    } else {
        
        [BrandController getRedeemInstructionsForBrandId:self.brand.brandId withCompletion:^(NSArray *array, NSError *error) {
            
            if (error) {
                
                [self showFail:[error localizedDescription] buttonTitle:@"OK" window:YES];
            }
            
            if (array) {
                self.instructionsArray = array;
                self.tableView.tableHeaderView = nil;
                [self.tableView reloadData];
            }
            
        }];
    }
}

@end
