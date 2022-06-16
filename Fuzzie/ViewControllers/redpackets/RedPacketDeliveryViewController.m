//
//  RedPacketDeliveryViewController.m
//  Fuzzie
//
//  Created by Joma on 2/21/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketDeliveryViewController.h"
#import "DeliveryInfoTableViewCell.h"
#import "DeliverMethodTableViewCell.h"
#import "DeliveryNoteTableViewCell.h"
#import "DeliveryInstructionTableViewCell.h"
#import "RedPacketHistoryViewController.h"
#import "FZTabBarViewController.h"
#import "JackpotLearnMoreViewController.h"
#import "GiftEmailSendViewController.h"

typedef enum : NSUInteger {
    kDeliverySectionInfo,
    kDeliverySectionInstruction,
    kDeliverySectionNote,
    kDeliverySectionWhatsApp,
    kDeliverySectionMessenger,
    kDeliverySectionSms,
    kDeliverySectionEmai,
    kDeliverySectionCopy,
    kDeliverySectionCount
    
} kDeliverySection;

@interface RedPacketDeliveryViewController () <UITableViewDataSource, UITableViewDelegate,  DeliverMethodTableViewCellDelegate, FBSDKSharingDelegate, MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnDone;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RedPacketDeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setStyling];
}

- (void)initData{
    
    if (self.dictionary) {
        
        self.message = self.dictionary[@"message"];
        if (!self.message) {
            self.message = @"";
        }
        self.redPacketUrl = self.dictionary[@"url"];
        
        if ([self.dictionary[@"number_of_red_packets"] intValue] == 1) {
            
            self.shareMessage = [NSString stringWithFormat:@"I've just sent you a Lucky Packet. Click here to open it: %@", self.redPacketUrl];
            
        } else{
            
            self.shareMessage = [NSString stringWithFormat:@"I've just created %@ Lucky Packets on Fuzzie. Click here to grab yours: %@", self.dictionary[@"number_of_red_packets"], self.redPacketUrl];
            
        }
        
    }
}

- (void)setStyling{
    
    UINib *infoNib = [UINib nibWithNibName:@"DeliveryInfoTableViewCell" bundle:nil];
    [self.tableView registerNib:infoNib forCellReuseIdentifier:@"InfoCell"];
    
    UINib *instructionNib = [UINib nibWithNibName:@"DeliveryInstructionTableViewCell" bundle:nil];
    [self.tableView registerNib:instructionNib forCellReuseIdentifier:@"InstructionCell"];
    
    UINib *noteNib = [UINib nibWithNibName:@"DeliveryNoteTableViewCell" bundle:nil];
    [self.tableView registerNib:noteNib forCellReuseIdentifier:@"NoteCell"];
    
    UINib *methodNib = [UINib nibWithNibName:@"DeliverMethodTableViewCell" bundle:nil];
    [self.tableView registerNib:methodNib forCellReuseIdentifier:@"MethodCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    
    self.btnDone.backgroundColor = [UIColor colorWithHexString:HEX_COLOR_RED];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kDeliverySectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case kDeliverySectionNote:
        case kDeliverySectionWhatsApp:
        case kDeliverySectionMessenger:
        case kDeliverySectionSms:
        case kDeliverySectionEmai:
        case kDeliverySectionCopy:
            return 1;
            break;
        case kDeliverySectionInfo:
        {
            if (self.fromWalletPage) {
                return 0;
            } else{
                return 1;
            }
            
            break;
        }
        case kDeliverySectionInstruction:{
            if (self.fromWalletPage) {
                return 0;
            } else{
                return 1;
            }
            
            break;
        }
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kDeliverySectionInfo) {
        
        DeliveryInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
        [cell setCell:self.dictionary];
        return cell;
        
    } else if (indexPath.section == kDeliverySectionInstruction) {
        
        DeliveryInstructionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstructionCell"];
        return cell;
        
    } else if (indexPath.section == kDeliverySectionNote) {
        
        DeliveryNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell"];
        return cell;
        
    } else if (indexPath.section == kDeliverySectionWhatsApp) {
        
        DeliverMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MethodCell"];
        [cell setCell:DeliveryMethodTypeWhatsapp];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == kDeliverySectionMessenger) {
        
        DeliverMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MethodCell"];
        [cell setCell:DeliveryMethodTypeMessenger];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == kDeliverySectionSms) {
        
        DeliverMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MethodCell"];
        [cell setCell:DeliveryMethodTypeSMS];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == kDeliverySectionEmai) {
        
        DeliverMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MethodCell"];
        [cell setCell:DeliveryMethodTypeEmail];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == kDeliverySectionCopy) {
        
        DeliverMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MethodCell"];
        [cell setCell:DeliveryMethodTypeCopyLink];
        cell.delegate = self;
        return cell;
        
    }
    
    return nil;
}

- (void)goRedPacketHistoryPage{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_DISMISS_VIEW object:nil];
        
        FZTabBarViewController *tabBarController = (FZTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        [tabBarController setSelectedIndex:kTabBarItemWallet];
        UINavigationController *navController = [[tabBarController viewControllers] objectAtIndex:kTabBarItemWallet];
        RedPacketHistoryViewController *historyView = [[GlobalConstants redPacketsStoryboard] instantiateViewControllerWithIdentifier:@"RedPacketHistoryView"];
        historyView.fromDelivery = true;
        historyView.hidesBottomBarWhenPushed = YES;
        [navController pushViewController:historyView animated:YES];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    });
    
}

#pragma mark - DeliverMethodTableViewCellDelegate
- (void)deliveryRedPacket:(DeliveryMethodType)type{
    
    switch (type) {
        case DeliveryMethodTypeWhatsapp:
            [self deliveryViaWhatsApp];
            break;
        case DeliveryMethodTypeMessenger:
            [self deliveryViaMessenger];
            break;
        case DeliveryMethodTypeSMS:
            [self deliveryViaSMS];
            break;
        case DeliveryMethodTypeEmail:
            [self deliveryViaEmail];
            break;
        case DeliveryMethodTypeCopyLink:
            [self deliveryViaCopyLink];
            break;
        default:
            break;
    }
    
}

- (void)deliveryViaWhatsApp{

    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@",[self.shareMessage stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
    {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    } else{
        
    }
    
}

- (void)deliveryViaMessenger{
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb-messenger://"]])
    {
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:self.redPacketUrl];
        [FBSDKMessageDialog showWithContent:content delegate:self];
        
    }
}

- (void)deliveryViaSMS{
    
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.body = self.shareMessage;
        messageController.messageComposeDelegate = self;
        [self presentViewController:messageController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
}

- (void)deliveryViaEmail{
    
    if (self.dictionary) {

        GiftEmailSendViewController *emailSendView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"GiftEmailSendView"];
        emailSendView.redPacketBundleId = self.dictionary[@"id"];
        [self.navigationController pushViewController:emailSendView animated:YES];
    }

}

- (void)deliveryViaCopyLink{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.redPacketUrl;
    [self showClipboardCopy:@"Link copied to clipboard" window:NO];
    [self performSelector:@selector(hidePopView) withObject:self afterDelay:2.0];
}

#pragma mark - SMS delegate

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        switch (result) {
            case MessageComposeResultSent:
                break;
            case MessageComposeResultFailed:
                break;
            case MessageComposeResultCancelled:
                break;
            default:
                break;
        }
    }];
}

#pragma mark - Messenger delegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)helpButtonPressed:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"Need help?"];
    
    [actionSheet bk_addButtonWithTitle:@"Read our FAQ" handler:^{
        
        JackpotLearnMoreViewController *learnView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotLearnMoreView"];
        learnView.isRedPacket = YES;
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

- (IBAction)doneButtonPressed:(id)sender {
    
    if (self.fromWalletPage) {
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        [self goRedPacketHistoryPage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
