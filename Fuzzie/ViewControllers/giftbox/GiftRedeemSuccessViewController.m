//
//  GiftRedeemSuccessViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 8/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "GiftRedeemSuccessViewController.h"
#import "GiftBoxViewController.h"

@interface GiftRedeemSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIView *transactionView;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (strong, nonatomic) FZRedeemPopView *redeemPopView;

- (IBAction)actionButtonPressed:(id)sender;

@end

@implementation GiftRedeemSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GIFT_REDEEMED object:nil];
    
    [self setStyling];
}

#pragma mark - Button Actions

- (IBAction)actionButtonPressed:(id)sender {
    self.redeemPopView.hidden = NO;
}

#pragma mark - Helper Functions

- (void)setStyling {

    [CommonUtilities setView:self.actionButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.transactionView withCornerRadius:4.0f];
    
    if (self.successDict) {
        self.orderLabel.text = [NSString stringWithFormat:@"%@",[self formattedOrderNumber:self.successDict[@"order_number"]]];
    }
    
    UINib *redeemPopViewNib = [UINib nibWithNibName:@"FZRedeemPopView" bundle:nil];
    self.redeemPopView = [[redeemPopViewNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.redeemPopView.delegate = self;
    [self.redeemPopView setRedeemSuccessStyle];
    [self.view addSubview:self.redeemPopView];
    self.redeemPopView.frame = self.view.frame;
    self.redeemPopView.hidden = YES;
}

-(NSString*)formattedOrderNumber:(NSString*) originalString{
    
    NSMutableString* mStr= [NSMutableString string];
    for(NSUInteger i=0 ; i<originalString.length; i++)
    {
        [mStr appendString: [originalString substringWithRange: NSMakeRange(i,1)]];
        if(i%3 == 2)
        {
            [mStr appendString: @" "];
        }
    }
    
    return [NSString stringWithFormat:@"%@", mStr];
}

#pragma mark - FZRedeemPopViewDelegate

- (void)redeemButtonPressed{
    self.redeemPopView.hidden = YES;
    BOOL checkGiftBoxView = false;
    UIViewController *giftBoxViewController;
    for (UIViewController *viewController in [self.navigationController viewControllers]) {
        if ([viewController isKindOfClass:[GiftBoxViewController class]]) {
            giftBoxViewController = viewController;
            checkGiftBoxView = true;
        }
    }
    if (checkGiftBoxView) {
        [self.navigationController popToViewController:giftBoxViewController animated:YES];
    } else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)cancelButtonPressed{
    self.redeemPopView.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
