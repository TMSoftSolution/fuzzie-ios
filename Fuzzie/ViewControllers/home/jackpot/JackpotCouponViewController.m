//
//  JackpotCouponViewController.m
//  Fuzzie
//
//  Created by mac on 9/9/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotCouponViewController.h"
#import "JackpotCouponCollectionViewCell.h"
#import "FZRedeemPopView.h"
#import "JackpotLearnMoreViewController.h"
#import "JackpotTicketsLockSuccssViewController.h"

@interface JackpotCouponViewController () <UICollectionViewDataSource, UICollectionViewDelegate, JackpotCouponCollectionViewCellDelegate, FZRedeemPopViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnLock;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)lockButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;
- (IBAction)randomButtonPressed:(id)sender;

@property (nonatomic, strong) FZRedeemPopView *redeemPopView;

@end

@implementation JackpotCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusNext:) name:FOCUS_NEXT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusPrev:) name:FOCUS_PREV object:nil];
    
    [self initData];
    [self setStyyling];
}

- (void)initData{
    
    self.digits = [[NSMutableArray alloc] initWithCapacity:self.ticketCount];
    self.digitsFilled = [[NSMutableArray alloc] initWithCapacity:self.ticketCount];
    
    for (int i = 0 ; i < self.ticketCount ; i ++) {
        [self.digits setObject:@"" atIndexedSubscript:i];
        [self.digitsFilled setObject:@(NO) atIndexedSubscript:i];
    }

}

- (void)setStyyling{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollView addGestureRecognizer:tap];

    UINib *redeemPopViewNib = [UINib nibWithNibName:@"FZRedeemPopView" bundle:nil];
    self.redeemPopView = [[redeemPopViewNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.redeemPopView.delegate = self;
    [self.view addSubview:self.redeemPopView];
    self.redeemPopView.frame = self.view.frame;
    self.redeemPopView.hidden = YES;
    
    [self updateLockButton];
    
    UINib *cellNib = [UINib nibWithNibName:@"JackpotCouponCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
    
    if (self.ticketCount == 0 || self.ticketCount == 1) {
        self.collectionView.scrollEnabled = false;
    }

}

- (void)updateLockButton{
    BOOL completed = TRUE;
    if (self.digitsFilled.count >= self.ticketCount) {
        for (int i = 0; i < self.ticketCount ; i ++) {
            if ([self.digitsFilled objectAtIndex:i]) {
                completed = completed && [[self.digitsFilled objectAtIndex:i] boolValue];
            } else{
                completed = FALSE;
            }
        }
    } else{
        completed = FALSE;
    }
    
    if (completed) {
        [CommonUtilities setView:self.btnLock withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
        [self.btnLock setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnLock setEnabled:YES];
    } else{
        [CommonUtilities setView:self.btnLock withBackground:[UIColor colorWithRed:1.0f green:1.0f blue:1.f alpha:0.2f] withRadius:4.0f];
        [self.btnLock setTitleColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.f alpha:0.4f] forState:UIControlStateNormal];
        [self.btnLock setEnabled:NO];
    }
}

- (BOOL)check4DEntered{
    
    if (!self.digits) {
        return false;
    } else{
        for (int i = 0; i < self.ticketCount; i ++) {
            NSString *fourD = [self.digits objectAtIndex:i];
            if (fourD.length == 4) {
                return true;
            }
        }
    }
    
    return false;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.ticketCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JackpotCouponCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell setCell:(int)indexPath.row withDigit:[self.digits objectAtIndex:indexPath.row] withTicketCount:self.ticketCount];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(self.view.frame.size.width - 70.0f, self.view.frame.size.height * 130 / 568.0f);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 28, 0, 28);
}

#pragma mark - JackpotCouponCollectionViewCellDelegate
- (void)completeDigits:(int)position withDigits:(NSString *)digits{
    self.digits[position] = digits;
    self.digitsFilled[position] = @(YES);
    [self updateLockButton];
}

- (void)uncompleteDigits:(int)position withDigits:(NSString *)digits{
    self.digits[position] = @"";
    self.digitsFilled[position] = @(NO);
    [self updateLockButton];
}

- (void)focusNext:(NSNotification*)notification{
//    NSLog(@"Focus Next");
    NSDictionary* userInfo = notification.userInfo;
    int position = [userInfo[@"position"] intValue];
    if (position != self.ticketCount - 1) {
        [UIView animateWithDuration:0.5 animations:^{
            CGPoint contentOffset = self.collectionView.contentOffset;
            contentOffset.x = contentOffset.x + self.view.frame.size.width - 60.0f;
            [self.collectionView setContentOffset:contentOffset];
        }];
    }
}

- (void)focusPrev:(NSNotification*)notification{
//    NSLog(@"Focus Prev");
    NSDictionary* userInfo = notification.userInfo;
    int position = [userInfo[@"position"] intValue];
    if (position != 0) {
        [UIView animateWithDuration:0.5 animations:^{
            CGPoint contentOffset = self.collectionView.contentOffset;
            contentOffset.x = contentOffset.x - self.view.frame.size.width + 60.0f;
            [self.collectionView setContentOffset:contentOffset];
        }];
    }
}

#pragma  mark - FZRedeemPopViewDelegate
- (void)redeemButtonPressed{
    self.redeemPopView.hidden = YES;
    
    if (self.isRandomize) {
        self.isRandomize = false;
        for (int i = 0; i < self.ticketCount ; i++) {
            [self.digits setObject:[self generateRandom4D] atIndexedSubscript:i];
            [self.digitsFilled setObject:@(YES) atIndexedSubscript:i];
        }
        
        [self.collectionView reloadData];
        [self updateLockButton];
    } else if(self.isBack){
        self.isBack = false;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cancelButtonPressed{
    self.redeemPopView.hidden = YES;
    self.isRandomize = false;
    self.isBack = false;
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.view endEditing:true];
    if ([self check4DEntered]) {
        self.isBack = true;
        [self.redeemPopView setGeneralStyle:@"DISCARD YOUR NUMBERS?" body:@"You will lose your numbers if you proceed. Do you wish to continue?" image:@"bear-baby" buttonTitle1:@"YES, DISCARD" buttonTitle2:@"No, cancel"];
        self.redeemPopView.hidden = NO;
    } else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)lockButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    [self lockTickets];
}

- (IBAction)helpButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"Need help?"];
    
    [actionSheet bk_addButtonWithTitle:@"Read our Jackpot FAQ" handler:^{
        [self goJackpotLearnMorePage];
    }];
    
    if ([MFMailComposeViewController canSendMail]) {
        
        [actionSheet bk_addButtonWithTitle:@"Email us" handler:^{
            
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            [mailer setSubject: @"Fuzzie Support"];
            [mailer setToRecipients:@[@"support@fuzzie.com.sg"]];
            mailer.navigationBar.tintColor = [UIColor whiteColor];
            mailer.bk_completionBlock = ^( MFMailComposeViewController *mailer, MFMailComposeResult result, NSError* error) {
                
                if (result == MFMailComposeResultSent) {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Email sent!", nil)];
                }
                
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

- (IBAction)randomButtonPressed:(id)sender {
    [self.view endEditing:true];
    self.isRandomize = true;
    [self.redeemPopView setGeneralStyle:@"FEELING LUCKY?" body:@"Do you wish to let the Bear choose all the numbers for you?" image:@"bear-baby" buttonTitle1:@"YES, CHOOSE FOR ME!" buttonTitle2:@"No, cancel"];
    self.redeemPopView.hidden = NO;

}

- (void) goJackpotLearnMorePage{
    JackpotLearnMoreViewController *learnView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotLearnMoreView"];
    [self.navigationController pushViewController:learnView animated:YES];
}

- (NSString*)generateRandom4D{
    NSString *digit = @"";
    int random = arc4random() % 9000;
    NSString *prefix = @"";
    if (random > 999) {
        prefix = @"";
    } else if (random > 99){
        prefix = @"0";
    } else if (random > 9){
        prefix = @"00";
    } else{
        prefix = @"000";
    }
    digit = [NSString stringWithFormat:@"%@%d", prefix, random];
    return digit;
}

- (void) hideKeyboard{
    [self.view endEditing:true];
}

- (void) lockTickets{
    
    [self showProcessing:YES];
    
    [JackpotController setJackpotTickets:self.digits withCompletion:^(NSDictionary *dictionary, NSError *error) {
        
        [self hidePopView];
        
        if (error) {
            
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            
            if (error.code == 412) {
                
                NSString *string = [NSString stringWithFormat:@"Your 4D number %@ has been chosen by too many users. Pick another one!", [error localizedDescription]];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#434343"]}];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BLACK size:13] range: NSMakeRange(15, 4)];
                [self showErrorWith:attributedString headerTitle:@"OOPS!" buttonTitle:@"OK, GOT IT" image:@"bear-dead" window:NO];
                
            } else if(error.code == 413 || error.code == 416 || error.code == 419 || error.code == 421){
                
                [self showError:[error localizedDescription] headerTitle:@"OOPS!" buttonTitle:@"GOT IT" image:@"bear-dead" window:NO];
                
            } else{
                
                [self showError:[error localizedDescription] headerTitle:@"OOPS!" buttonTitle:@"OK" image:@"bear-dead" window:NO];
                
            }
        }
        
        if (dictionary) {
            
            if (dictionary[@"tickets_count"]) {
                
                int count = [dictionary[@"tickets_count"] intValue];
                int currentTicketsCount = [[UserController sharedInstance].currentUser.currentJackpotTicketsCount intValue];
                int availabeTicketsCount = [[UserController sharedInstance].currentUser.availableJackpotTicketsCount intValue];
                
                [[UserController sharedInstance].currentUser setCurrentJackpotTicketsCount:[NSNumber numberWithInt:(currentTicketsCount + count)]];
                [[UserController sharedInstance].currentUser setAvailableJackpotTicketsCount:[NSNumber numberWithInt:(availabeTicketsCount - count)]];
                
                JackpotTicketsLockSuccssViewController *successView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotTicketsLockSuccssView"];
                successView.ticketArray = self.digits;
                [self.navigationController pushViewController:successView animated:YES];
            }
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
