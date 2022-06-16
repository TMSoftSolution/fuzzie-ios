//
//  EditBirthdayViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 2/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "EditBirthdayViewController.h"

@interface EditBirthdayViewController ()

@end

@implementation EditBirthdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
