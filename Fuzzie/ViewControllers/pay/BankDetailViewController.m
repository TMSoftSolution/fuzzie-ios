//
//  BankDetailViewController.m
//  Fuzzie
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BankDetailViewController.h"
#import "BankRewardDetailTableViewCell.h"
#import "BankTermsViewController.h"

@interface BankDetailViewController () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *lbHeaderTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ivBank;
@property (weak, nonatomic) IBOutlet UILabel *lbCardName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightAnchor;
@property (weak, nonatomic) IBOutlet UIView *bonusContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bonusContainerheightAnchor;
@property (weak, nonatomic) IBOutlet UILabel *lbBonusTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbBonusBody;
@property (weak, nonatomic) IBOutlet UIImageView *ivStar;
@property (weak, nonatomic) IBOutlet UIButton *btnSign;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)signupButtonPressed:(id)sender;
- (IBAction)learnButtonPressed:(id)sender;

@end

@implementation BankDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailsArray = [[NSArray alloc] init];
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnSign withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    UINib *cellNib = [UINib nibWithNibName:@"BankRewardDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    self.lbHeaderTitle.text = self.cardDict[@"bank_name"];
    [self.ivBank sd_setImageWithURL:self.cardDict[@"banner_details_page"] placeholderImage:[UIImage imageNamed:@"bg-bank-detail"]];
    self.lbCardName.text = self.cardDict[@"title"];
    self.detailsArray = self.cardDict[@"details"];
    [self.tableView reloadData];
    self.tableViewHeightAnchor.constant = self.tableView.contentSize.height;
    
    self.bonusContainer.layer.borderWidth = 1.0f;
    self.bonusContainer.layer.borderColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:1.0f].CGColor;
    self.bonusContainer.layer.cornerRadius = 2.0f;
    self.bonusContainer.layer.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f].CGColor;
    self.bonusContainer.layer.shadowOpacity = 0.2f;
    self.bonusContainer.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.bonusContainer.layer.shadowRadius = 4.0f;
    self.bonusContainer.layer.masksToBounds = NO;
    
    self.lbBonusTitle.text = [self.cardDict[@"bonus_title"] uppercaseString];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.cardDict[@"bonus_body"]];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_REGULAR size:14] range: NSMakeRange(0, string.length)];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.lineHeightMultiple = 1.3;
    paragrapStyle.alignment = NSTextAlignmentLeft;
    [string addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
    self.lbBonusBody.attributedText = string;
    
    if ([self.cardDict[@"enable_bonus_section"] boolValue]) {
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        
        CGFloat width = screenWidth - 60;
        CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        self.bonusContainerheightAnchor.constant = rect.size.height + 96;
        
        self.bonusContainer.hidden = NO;
        self.ivStar.hidden = NO;
    } else{
        self.bonusContainerheightAnchor.constant = 0;
        self.bonusContainer.hidden = YES;
        self.ivStar.hidden = YES;
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.detailsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankRewardDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.lbDesc.text = self.detailsArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.detailsArray.count == 0) {
        return 0;
    }
    return 30.0f;
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)learnButtonPressed:(id)sender {
    BankTermsViewController *termsView = (BankTermsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BankTermsView"];
    termsView.dict = self.cardDict;
    [self.navigationController pushViewController:termsView animated:YES];
}

- (IBAction)signupButtonPressed:(id)sender {
    NSString *url = self.cardDict[@"signup_url"];
    if (url && ![url isKindOfClass:[NSNull class]] && ![url isEqualToString:@""]) {
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
