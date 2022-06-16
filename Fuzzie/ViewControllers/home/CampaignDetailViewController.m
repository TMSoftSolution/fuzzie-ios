//
//  CampaignDetailViewController.m
//  Fuzzie
//
//  Created by mac on 7/12/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "CampaignDetailViewController.h"
#import "FZWebView2Controller.h"
#import "BrandListViewController.h"
#import "PackageListViewController.h"
#import "CardViewController.h"
#import "PackageViewController.h"

@interface CampaignDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lbHeader;
@property (weak, nonatomic) IBOutlet UIImageView *campaignImage;
@property (weak, nonatomic) IBOutlet UITextView *body;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linkButtonHeightAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bodyHeightAnchor;

@property (weak, nonatomic) IBOutlet UIButton *linkButton;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)linkButtonPressed:(id)sender;

@end

@implementation CampaignDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageDict = self.bannerDict[@"general_page"];
    self.pageType = self.pageDict[@"page_type"];
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.linkButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    self.lbHeader.text = [self.pageDict[@"title"] uppercaseString];
    
    if (self.pageDict[@"image"]) {
        NSURL *imageURL = [NSURL URLWithString:self.pageDict[@"image"]];
        [self.campaignImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
    }
    
    if (self.pageDict[@"title"]) {
        [self.titleLabel setText:self.pageDict[@"title"]];
    } else{
        [self.titleLabel setText:@""];
    }
    
    if (self.pageDict[@"content"]) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.pageDict[@"content"]];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_REGULAR size:13.0f] range:NSMakeRange(0, string.length)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"424242"] range:NSMakeRange(0, string.length)];
        NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
        paragrapStyle.lineHeightMultiple = 1.3;
        paragrapStyle.alignment = NSTextAlignmentLeft;
        [string addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
        
        [self.body setAttributedText:string];
    } else{
        [self.body setText:@""];
    }
    
    self.bodyHeightAnchor.constant = self.body.contentSize.height;
    [self updateViewConstraints];

    if (self.pageDict[@"button_name"] && [self.pageDict[@"button_name"] isKindOfClass:[NSString class]] && ![self.pageDict[@"button_name"] isEqualToString:@""]) {
        self.linkButtonHeightAnchor.constant = 50.0f;
        [self.linkButton setTitle:[self.pageDict[@"button_name"] uppercaseString] forState:UIControlStateNormal];
    } else{
        self.linkButtonHeightAnchor.constant = 0.0f;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)linkButtonPressed:(id)sender {
    
    if ([self.pageType isEqualToString:@"Web-linked"]) {
        
        [self goWebPage];

    } else if ([self.pageType isEqualToString:@"Campaign"]){
        
        [self goBrandListPage];
        
    } else if ([self.pageType isEqualToString:@"Brand"]){
        
        [self goBrandPage];
    }


}

- (void) goWebPage{
    
    FZWebView2Controller *webView = [[GlobalConstants extraStoryboard] instantiateViewControllerWithIdentifier:@"Webview2"];
    webView.URL = self.pageDict[@"link"];
    webView.titleHeader = self.pageDict[@"title"];
    webView.hidesBottomBarWhenPushed = YES;
    webView.showLoading = true;
    [self.navigationController pushViewController:webView animated:YES];
    
}

- (void) goBrandListPage{
    NSArray *idArray = self.pageDict[@"brand_ids"];
    if (![idArray isKindOfClass:[NSNull class]]) {
        NSMutableArray *brandArray = [NSMutableArray new];
        for (NSString *brandId in idArray) {
            for (NSInteger i=0; i<[FZData sharedInstance].brandArray.count; i++) {
                FZBrand *brand = [FZData sharedInstance].brandArray[i];
                if ([brand.brandId isEqualToString:brandId]) {
                    [brandArray addObject:brand];
                    break;
                }
            }
        }

        if (brandArray.count > 0) {

            BrandListViewController *brandListView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"BrandListView"];
            brandListView.headerTitle = self.pageDict[@"title"];
            brandListView.brandArray = brandArray;
            brandListView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:brandListView animated:YES];
        }

    }
}

- (void) goBrandPage{
    
    NSString *brandId = self.pageDict[@"brand_id"];
    FZBrand *brand = [FZData getBrandById:brandId];
    
    if (brand) {
        
        if (brand.giftCards && brand.giftCards.count > 0 && brand.services && brand.services.count > 0) {
            
            
            PackageListViewController *packageListView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"PackageListView"];
            packageListView.brand = brand;
            [self.navigationController pushViewController:packageListView animated:YES];
            
        } else if (brand.giftCards && brand.giftCards.count > 0) {
            
            CardViewController *cardView = [[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"CardViewController"];
            cardView.brand = brand;
            [self.navigationController pushViewController:cardView animated:YES];
            
        } else if (brand.services && brand.services.count == 1) {
            
            PackageViewController *packageView = [[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"PackageViewController"];
            NSDictionary *packageDict = [brand.services firstObject];
            packageView.brand = brand;
            packageView.packageDict = packageDict;
            [self.navigationController pushViewController:packageView animated:YES];
            
        } else if (brand.services && brand.services.count > 1) {

            PackageListViewController *packageListView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"PackageListView"];
            packageListView.brand = brand;
            [self.navigationController pushViewController:packageListView animated:YES];
            
        }
        
    }
}


@end
