//
//  FZWebView2Controller.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/19/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FZWebView2Controller.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"
#import "FuzzieLoaderView.h"

@interface FZWebView2Controller () <WKNavigationDelegate>
@property(strong,nonatomic) WKWebView *webView;
@property(strong,nonatomic) UIView *webViewContainer;

@property (strong, nonatomic) FuzzieLoaderView *loader;

@end

@implementation FZWebView2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerLabel.text = [self.titleHeader uppercaseString];
    
    NSURL *url = [NSURL URLWithString:self.URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _webView = [[WKWebView alloc] initWithFrame:self.webViewContainer.frame];
    [_webView loadRequest:request];
    _webView.navigationDelegate = self;
    _webView.frame = CGRectMake(self.webViewContainer.frame.origin.x,self.webViewContainer.frame.origin.y, self.webViewContainer.frame.size.width, _webViewContainer.frame.size.height);
    [self.webViewContainer addSubview:_webView];
    
    // tell constraints they need updating
    [_webView setNeedsUpdateConstraints];
    
    __weak __typeof__(self) weakSelf = self;
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.webViewContainer.mas_top);
        make.bottom.equalTo(weakSelf.webViewContainer.mas_bottom);
        make.left.equalTo(weakSelf.webViewContainer.mas_left);
        make.right.equalTo(weakSelf.webViewContainer.mas_right);

    }];
    
    // update constraints now so we can animate the change
    [_webView updateConstraintsIfNeeded];
    
    UINib *customNib = [UINib nibWithNibName:@"FuzzieLoaderView" bundle:nil];
    self.loader = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    if ([[self.titleHeader uppercaseString] isEqualToString:@"FAQ"] || self.showLoading) {
        [self showLoader];
    }
    
}

- (void)showLoader{
    
    if (![self.loader isDescendantOfView:self.webViewContainer]) {
        
        self.loader.frame = CGRectMake(self.webViewContainer.frame.origin.x,self.webViewContainer.frame.origin.y, self.webViewContainer.frame.size.width, _webViewContainer.frame.size.height);
        [self.webViewContainer addSubview:self.loader];
        
        // tell constraints they need updating
        [self.loader setNeedsUpdateConstraints];
        
        __weak __typeof__(self) weakSelf = self;
        [self.loader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.webViewContainer.mas_top);
            make.bottom.equalTo(weakSelf.webViewContainer.mas_bottom);
            make.left.equalTo(weakSelf.webViewContainer.mas_left);
            make.right.equalTo(weakSelf.webViewContainer.mas_right);
            
        }];
        
        // update constraints now so we can animate the change
        [self.loader updateConstraintsIfNeeded];

        [self.loader setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
        [self.loader startLoader];
    }
}

- (void)hideLoader{
    if (self.loader != nil && [self.loader isDescendantOfView:self.webViewContainer]) {
        [self.loader stopLoader];
        [self.loader removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"Navigation Finished");
    [self hideLoader];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"Navigation Failed");
    [self hideLoader];
    self.showLoading = false;
}
@end
