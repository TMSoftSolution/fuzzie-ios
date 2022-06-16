//
//  TopUpFuzzieCreditsViewController.m
//  Fuzzie
//
//  Created by mac on 9/5/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "TopUpFuzzieCreditsViewController.h"
#import "TopUpTableViewCell.h"
#import "FZWebView2Controller.h"
#import "TopUpEnterValueViewController.h"
#import "TopUpPayViewController.h"

#define DEFAULT_PRICE @[@30, @50, @100]

@interface TopUpFuzzieCreditsViewController () <UITableViewDataSource, UITableViewDelegate, TopUpTableViewCellDelegate, MDHTMLLabelDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnEnter;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *lbLearnMore;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)enterButtonPressed:(id)sender;

@end

@implementation TopUpFuzzieCreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    UINib *cellNib = [UINib nibWithNibName:@"TopUpTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    [self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frame = self.tableView.frame;
        frame.size.height = self.tableView.contentSize.height;
        self.tableView.frame = frame;
        [self updateViewConstraints];
    });
    
    [CommonUtilities setView:self.btnEnter withBackground:[UIColor whiteColor] withRadius:4.0f withBorderColor:[UIColor colorWithHexString:HEX_COLOR_RED] withBorderWidth:1.0f];
    
    self.lbLearnMore.htmlText = @"<a href='forgot'>Learn more about Fuzzie Credits</a>";
    self.lbLearnMore.delegate = self;
    self.lbLearnMore.linkAttributes = @{
                                                NSForegroundColorAttributeName: [UIColor colorWithHexString:HEX_COLOR_RED],
                                                NSFontAttributeName: [UIFont fontWithName:@"Lato-Bold" size:self.lbLearnMore.font.pointSize],
                                                NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return DEFAULT_PRICE.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopUpTableViewCell *cell = (TopUpTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell setCell:DEFAULT_PRICE[indexPath.row] position:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0f;
}

#pragma mark - TopUpTableViewCellDelegate
- (void)buyButtonPressed:(NSNumber*)price{

    TopUpPayViewController *payView = [[GlobalConstants paymentStoryboard] instantiateViewControllerWithIdentifier:@"TopUpPayView"];
    payView.price = price;
    [self.navigationController pushViewController:payView animated:YES];
}

#pragma mark - MDHTMLLabelDelegate
- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL {
    
    FZWebView2Controller *webView = [[GlobalConstants extraStoryboard] instantiateViewControllerWithIdentifier:@"Webview2"];
    webView.URL = @"http://fuzzie.com.sg/faq.html#credits";
    webView.titleHeader = @"FAQ";
    webView.showLoading = true;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [FZData sharedInstance].backOriginalPaymentPage = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)enterButtonPressed:(id)sender {
    TopUpEnterValueViewController *enterView = (TopUpEnterValueViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"TopUpEnterValueView"];
    [self.navigationController pushViewController:enterView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
