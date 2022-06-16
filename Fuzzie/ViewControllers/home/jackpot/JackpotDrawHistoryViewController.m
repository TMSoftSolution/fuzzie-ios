//
//  JackpotDrawHistoryViewController.m
//  Fuzzie
//
//  Created by mac on 9/19/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#define DEFALUT_MENU_HEIGHT 175.0f

#import "JackpotDrawHistoryViewController.h"
#import "DropDownMenuTableViewCell.h"
#import "JackpotDrawHistoryTableViewCell.h"
#import "JackpotTicketCollectionViewCell.h"
#import "JackpotHomePageViewController.h"
#import "JackpotLearnMoreViewController.h"

@interface JackpotDrawHistoryViewController () <UITableViewDataSource, UITableViewDelegate, DropDownMenuTableViewCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (assign, nonatomic) BOOL menuOpened;
@property (weak, nonatomic) IBOutlet UILabel *lbSelectedDate;
@property (weak, nonatomic) IBOutlet UIImageView *ivMenuArrow;
@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIView *tableBackView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightAnchor;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *myCombinationView;
@property (weak, nonatomic) IBOutlet UIView *emptyCombinationView;
@property (weak, nonatomic) IBOutlet UIView *participateView;
@property (weak, nonatomic) IBOutlet UILabel *lbParticepate;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)participateButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;


@end

@implementation JackpotDrawHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.jackpotResults = [NSMutableArray new];
    self.selectedResultPrizes = [[NSArray alloc] init];
    self.ticketsArray = [[NSArray alloc] init];
    
    [self setStyling];
    
    if ([FZData sharedInstance].jackpotResult && ![FZData sharedInstance].isLiveDraw) {
        
        [self showjackpotResults];
        
    } else {
        
        [self loadJackpotResult];
        
    }
    
}

- (void) showjackpotResults{
    
    self.jackpotResults = [[NSMutableArray alloc] initWithArray:[FZData sharedInstance].jackpotResult[@"results"]];
    [self.jackpotResults removeObjectAtIndex:0];
    
    NSDictionary *upcomingResult = [self.jackpotResults objectAtIndex:0];
    if ([upcomingResult[@"id"] isEqual:[FZData sharedInstance].jackpotDrawId]){
        [self.jackpotResults removeObjectAtIndex:0];
    }
    
    [self resizeMenuTableBackView];
    [self.menuTableView reloadData];
    
    if (self.showLastResult && self.jackpotResults.count > 1) {
        
        [self showResult:0];
        
    } else{
        
        [self showResult:self.selectedPosition];
        
    }

}

- (void)setStyling{
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#212121"];
    
    UINib *menuCellNib = [UINib nibWithNibName:@"DropDownMenuTableViewCell" bundle:nil];
    [self.menuTableView registerNib:menuCellNib forCellReuseIdentifier:@"MenuCell"];
    
    UINib *cellNib = [UINib nibWithNibName:@"JackpotDrawHistoryTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    [self hideMenu];

    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableViewHeightAnchor.constant = 70.0f * self.selectedResultPrizes.count;
    });
    
    UINib *ticketCellNib = [UINib nibWithNibName:@"JackpotTicketCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:ticketCellNib forCellWithReuseIdentifier:@"TicketCell"];
}

- (void)resizeMenuTableBackView{
    
    CGFloat height;
    
    if (self.jackpotResults.count < 3) {
        height = self.jackpotResults.count * 50.0f;
    } else {
        height = DEFALUT_MENU_HEIGHT;
    }
    
    CGRect rect = self.tableBackView.bounds;
    rect.size.height = height;
    self.tableBackView.bounds = rect;
    
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:self.tableBackView.bounds
                              byRoundingCorners:(UIRectCornerBottomLeft |UIRectCornerBottomRight)
                              cornerRadii:CGSizeMake(4.0f, 4.0f)
                              ];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = self.tableBackView.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.tableBackView.layer.mask = maskLayer;
}

- (void)loadJackpotResult{
    
    [self showLoader];
    
    [JackpotController getJackpotResult:^(NSDictionary *dictionary, NSError *error) {
        
        [self hideLoader];
        
        if (error && error.code == 417) {
            [AppDelegate logOut];
        }
        
        if (dictionary) {
            
            [FZData sharedInstance].jackpotResult = dictionary;
            [self showjackpotResults];
        }
    }];
}

- (void)showResult:(int)position{
   
    NSDate *now = [NSDate date];
    
    self.selectedResult = [self.jackpotResults objectAtIndex:position];
    self.selectedResultPrizes = [self.selectedResult objectForKey:@"prizes"];
    
    self.selectedDrawTime = [self.selectedResult objectForKey:@"date"];
    NSDate *selectedDrawDate = [[GlobalConstants dateApiFormatter] dateFromString:self.selectedDrawTime];
    NSDateFormatter *dateFormatter1 = [NSDateFormatter new];
    [dateFormatter1 setDateFormat:@"dd.MM.YYYY"];
    NSString *drawDateString = [dateFormatter1 stringFromDate:selectedDrawDate];
    self.lbSelectedDate.text = drawDateString;
    
    [self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableViewHeightAnchor.constant = 70.0f * self.selectedResultPrizes.count;
    });
    
    self.ticketsArray = self.selectedResult[@"my_combinations"];

    if (self.ticketsArray.count > 0) {
        self.myCombinationView.hidden = NO;
        [self.collectionView reloadData];
        self.emptyCombinationView.hidden = YES;
    } else{
        self.myCombinationView.hidden = YES;
        self.emptyCombinationView.hidden = NO;
   
        if ([selectedDrawDate secondsFrom:now] > 0) {
            self.lbParticepate.text = @"You have not chosen your 4D number.";
            self.participateView.hidden = NO;
        } else{
            self.lbParticepate.text = @"You didn't participate in this draw.";
            self.participateView.hidden = YES;
        }
    }

    NSArray *prizes = self.selectedResult[@"prizes"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSDictionary *prize in prizes) {
        [temp addObject:prize[@"four_d"]];
    }
    self.prizeTicketsArray = temp;
    
}

- (void)showMenu{
    [self.ivMenuArrow setImage:[UIImage imageNamed:@"icon-arrow-up-red"]];
    [CommonUtilities setView:self.menuView withCornerRadius:0.0f];
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:self.menuView.bounds
                              byRoundingCorners:(UIRectCornerTopLeft |UIRectCornerTopRight)
                              cornerRadii:CGSizeMake(4.0f, 4.0f)
                              ];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = self.menuView.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.menuView.layer.mask = maskLayer;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.tableBackView.hidden = NO;
    }];
}

- (void)hideMenu{
    [self.ivMenuArrow setImage:[UIImage imageNamed:@"icon-arrow-down-red"]];
    [CommonUtilities setView:self.menuView withCornerRadius:4.0f];

    [UIView animateWithDuration:0.25f animations:^{
        self.tableBackView.hidden = YES;
        self.menuTableView.contentOffset = CGPointZero;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.menuTableView) {
        return self.jackpotResults.count;
    } else if (tableView == self.tableView){
        return self.selectedResultPrizes.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.menuTableView) {
        DropDownMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
        [cell setCell:[self.jackpotResults objectAtIndex:indexPath.row][@"date"] andPosition:(int)indexPath.row];
        cell.delegate = self;
        return cell;
    } else if (tableView == self.tableView){
        JackpotDrawHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        BOOL matched = false;
        for (NSArray *ticket in self.ticketsArray) {
            if ([[ticket firstObject] isEqualToString:[self.selectedResultPrizes objectAtIndex:indexPath.row][@"four_d"]]) {
                matched = true;
                break;
            }
        }
        [cell setCell:[self.selectedResultPrizes objectAtIndex:indexPath.row] position:(int)indexPath.row matched:matched];
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.menuTableView) {
        return 50.0f;
    } else if (tableView == self.tableView){
        return 70.0f;
    }
    
    return 0.0f;
}

#pragma mark - DropDownMenuTableViewCellDelegate
- (void)menuItemSelected:(int)position{
    
    [self showResult:position];
    self.menuOpened = false;
    [self hideMenu];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.ticketsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JackpotTicketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TicketCell" forIndexPath:indexPath];
    NSArray *tickets = [self.ticketsArray objectAtIndex:indexPath.row];
    NSString *ticket = [tickets firstObject];
    [cell setCell:ticket count:tickets.count matched:[self.prizeTicketsArray containsObject:ticket]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(77.0f, 60.0f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, 5, 0, 15);
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}


#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)menuButtonPressed:(id)sender {
    self.menuOpened = !self.menuOpened;
    if (self.menuOpened) {
        [self showMenu];
    } else {
        [self hideMenu];
    }
}

- (IBAction)participateButtonPressed:(id)sender {
    JackpotHomePageViewController *jackpotHomePage = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotHomePageView"];
    [self.navigationController pushViewController:jackpotHomePage animated:YES];
}

- (IBAction)helpButtonPressed:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"Need help?"];
    
    [actionSheet bk_addButtonWithTitle:@"Read our FAQ" handler:^{
        
        JackpotLearnMoreViewController *learnView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotLearnMoreView"];
        [self.navigationController pushViewController:learnView animated:YES];
    }];
    
    if ([MFMailComposeViewController canSendMail]) {
        
        [actionSheet bk_addButtonWithTitle:@"Email us" handler:^{
            
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            [mailer setSubject: @"Fuzzie Support"];
            [mailer setToRecipients:@[@"support@fuzzie.com.sg"]];
            mailer.navigationBar.tintColor = [UIColor whiteColor];
            mailer.bk_completionBlock = ^( MFMailComposeViewController *mailer, MFMailComposeResult result, NSError* error) {
                
                [mailer dismissViewControllerAnimated:YES completion:nil];
            };
            
            [self presentViewController:mailer animated:YES completion:nil];
            
        }];
    }
    
    [actionSheet bk_addButtonWithTitle:@"Facebook us" handler:^{
        NSURL *facebookURL = [NSURL URLWithString:@"http://m.me/fuzzieapp"];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        }
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"Cancel" handler:nil];
    [actionSheet showInView:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
