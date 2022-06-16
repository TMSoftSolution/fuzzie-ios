//
//  CashbackViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 3/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "CashbackViewController.h"

@interface CashbackViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)closeButtonPressed:(id)sender;

@end

@implementation CashbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
