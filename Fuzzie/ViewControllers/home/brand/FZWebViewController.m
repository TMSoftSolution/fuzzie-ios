//
//  FZWebViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 2/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "FZWebViewController.h"

@interface FZWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation FZWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.URL) {
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:self.URL];
        [self.webView loadRequest:urlRequest];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
