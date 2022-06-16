//
//  ClubTempViewController.m
//  Fuzzie
//
//  Created by Joma on 11/13/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "ClubTempViewController.h"

@interface ClubTempViewController ()

@property (weak, nonatomic) IBOutlet UILabel *comingSoonLabel;

@end

@implementation ClubTempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Functions

- (void)setStyling {
    [self.navigationController.navigationBar setTranslucent:NO];
    self.comingSoonLabel.backgroundColor = [UIColor colorWithHexString:HEX_COLOR_RED];
    self.comingSoonLabel.layer.cornerRadius = 4.0f;
    self.comingSoonLabel.layer.masksToBounds = YES;
}

@end
