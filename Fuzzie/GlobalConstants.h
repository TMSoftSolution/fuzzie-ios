//
//  GlobalConstants.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 17/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#define API_JACKPOT_LIVE_DRAW_HOST_URL @"http://fuzzie-assets.s3.amazonaws.com"

#ifdef DEBUG

#define API_BASE_URL  @"http://beta.fuzzie.com.sg"
#define API_JACKPOT_END_POINT @"jackpot/result/beta"
#define NETSPAY_API_KEY_ID @"fa9b51d6-412f-4f4c-87e3-92b9ce3a4084"
#define NETSPAY_SECRET_KEY @"9905c100-c94f-4327-afd5-4d8f818062f2"
#define NETSPAY_MID @"UMID_877767002"
#define NETSPAY_INCOMING_REQUEST_IP @"118.201.98.241:9605"
#define NETSPAY_S2S @"http://beta.fuzzie.com.sg/api/netspay/s2s"

#else

#define API_BASE_URL @"https://api.fuzzie.com.sg"
#define API_JACKPOT_END_POINT @"jackpot/result"
#define NETSPAY_API_KEY_ID @"3961c3bf-cb8d-48a5-b634-92cf929b78d2"
#define NETSPAY_SECRET_KEY @"9e9bff70-4580-405e-a711-fcdf6dac2f59"
#define NETSPAY_MID @"UMID_868456002"
#define NETSPAY_INCOMING_REQUEST_IP @"52.128.22.41"
#define NETSPAY_S2S @"https://api.fuzzie.com.sg/api/netspay/s2s"

#endif

#define APP_VERSION [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]

#define HEX_COLOR_RED @"#FA3E3F"

#define FONT_NAME_LIGHT @"BrandonGrotesque-Light"
#define FONT_NAME_REGULAR @"BrandonGrotesque-Regular"
#define FONT_NAME_MEDIUM @"BrandonGrotesque-Medium"
#define FONT_NAME_BLACK @"BrandonGrotesque-Black"
#define FONT_NAME_BOLD @"BrandonGrotesque-Bold"
#define FONT_NAME_LATO_REGULAR @"Lato-Regular"
#define FONT_NAME_LATO_BOLD @"Lato-Bold"
#define FONT_NAME_LATO_BLACK @"Lato-Black"
#define FONT_NAME_LATO_LIGHT @"Lato-Light"

#define ACCESS_TOKEN_KEY @"ACCESS_TOKEN_KEY"
#define CURRENT_USER_KEY @"CURRENT_USER_KEY"

#define JACKPOT_DRAW_ID @"JACKPOT_DRAW_ID"

// Refresh UI
#define SHOULD_RELOAD_HOME_DATA @"SHOULD_RELOAD_HOME_DATA"
#define HOME_DATA_REFRESHED @"HOME_DATA_REFRESHED"
#define SHOULD_DISMISS_VIEW @"SHOULD_DISMISS_VIEW"
#define SHOULD_REFRESH_USER @"SHOULD_REFRESH_USER"

#define SHOULD_REFRESH_SHOPPING_BAG @"SHOULD_REFRESH_SHOPPING_BAG"
#define SHOPPING_BAG_REFRESHED @"SHOPPING_BAG_REFRESHED"

#define ACTIVE_GIFTBOX_REFRESHED @"ACTIVE_GIFTBOX_REFRESHED"
#define USED_GIFTBOX_REFRESHED @"USED_GIFTBOX_REFRESHED"
#define SENT_GIFTBOX_REFRESHED @"SENT_GIFTBOX_REFRESHED"
#define SENT_GIFT_UPDATED @"SENT_GIFT_UPDATED"
#define GIFT_REDEEMED @"GIFT_REDEEMED"
#define GIFT_MARK_AS_UNREDEEMED @"GIFT_MARK_AS_UNREDEEMED"
#define RECEIVED_RED_PACKETS_REFRESHED @"RECEIVED_RED_PACKETS_REFRESHED"
#define SENT_RED_PACKETS_REFRESHED @"SENT_RED_PACKETS_REFRESHED"

#define RESET_BRAND_SLIDER @"RESET_BRAND_SLIDER"
#define RESET_MINI_BABBER_SLIDER @"RESET_MINI_BANNER_SLIDER"
#define RESET_CLUB_MINI_BABBER_SLIDER @"RESET_CLUB_MINI_BABBER_SLIDER"

#define BRAND_ADDED_IN_WHISHLIST @"BRAND_ADDED_IN_WHISHLIST"
#define BRAND_REMOVED_IN_WHISHLIST @"BRAND_REMOVED_IN_WHISHLIST"

#define LIKE_ADDED_IN_BRAND @"LIKE_ADDED_IN_BRAND"
#define LIKE_REMOVED_IN_BRAND @"LIKE_REMOVED_IN_BRAND"

#define TOP_UP_PURCHASED @"TOP_UP_PURCHASED"
#define JACKPOT_LIVE_DRAW_START @"JACKPOT_LIVE_DRAW_START"
#define JACKPOT_LIVE_DRAW_END @"JACKPOT_LIVE_DRAW_END"
#define JACKPOT_LIVE_DRAW_WON @"JACKPOT_LIVE_DRAW_WON"
#define JACKPOT_RESULT_REFRESH @"JACKPOT_RESULT_REFRESH"
#define JACKPOT_RESULT_REFRESHED @"JACKPOT_RESULT_REFRESHED"

#define CLUB_HOME_LOADED @"CLUB_HOME_LOADED"
#define CLUB_HOME_LOAD_FAILED @"CLUB_HOME_LOAD_FAILED"
#define CLUB_SUBSCRIBE_SUCCESS @"CLUB_SUBSCRIBE_SUCCESS"
#define CLUB_STORE_BOOK_MARK_CHANGED @"CLUB_STORE_BOOK_MARK_CHANGED"
#define CLUB_OFFER_REDEEMED @"CLUB_OFFER_REDEEMED"

#define FOCUS_NEXT @"FOCUS_NEXT"
#define FOCUS_PREV @"FOCUS_PREV"

// Jackpot Sort & Refine
#define JACKPOT_SORT @"JACKPOT_SORT"
#define JACKPOT_REFINE @"JACKPOT_REFINE"

#define REDEEM_COUNT_TIME       24 * 60 * 60
//#define REDEEM_COUNT_TIME           120
#define NB_MAX_LIMIT_CELL           10;

static const int GIFT_BOX_PAGINGATION_COUNT = 10;

#define TUTORIAL_VIEWED  @"TUTORIAL_VIEWED"
#define GIFTING_AVAILABLE_VIEWED @"GIFTING_AVAILABLE_VIEWED"

// Local Notification Identifiers
#define NOTIFICATION_ID_JACKPOT_LIVE_DRAW @"jackpotLiveDraw"
#define NOTIFICATION_ID_JACKPOT_REMAINDER  @"jackpotRemainder"
#define NOTIFICATION_ID_MY_BIRTHDAY @"myBirthday"
#define NOTIFICATION_ID_FRIENDS_BIRTHDAY @"friendsBirthday"

// Payment Card Info Input
#define CARD_INFO_INPUTED @"CARD_INFO_INPUTED"

#define MONTHS @[@"JANUARY", @"FEBRURAY", @"MARCH", @"APRIL", @"MAY", @"JUNE", @"JULY", @"AUGUST", @"SEPTEMPER", @"OCTOBER", @"NOVEMBER", @"DECEMBER"]

#define GOOGLE_MAP_KEY @"AIzaSyCOiwf3hOCLLwhJDcCdRdHtE73hxwYb3tM"

#import <Foundation/Foundation.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import "Fuzzie-Swift.h"
#import "iVersion.h"
#import "AFNetworking.h"
#import "HexColor.h"
#import "DateTools.h"
#import "TKRoundedView.h"
#import "FZHeaderView.h"

#import "NSUserDefaults+RMSaveCustomObject.h"
#import "SVProgressHUD.h"
#import "TTTAttributedLabel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import <BlocksKit/UIAlertView+BlocksKit.h>
#import <BlocksKit/UIActionSheet+BlocksKit.h>
#import <BlocksKit/MFMailComposeViewController+BlocksKit.h>
#import <BlocksKit/MFMessageComposeViewController+BlocksKit.h>
#import <BlocksKit/UIImagePickerController+BlocksKit.h>
#import <MDHTMLLabel/MDHTMLLabel.h>
#import <ENETSLib/ENETSLib.h>

#import "FZWebViewController.h"
#import "FZBaseViewController.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@import CocoaLumberjack;

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif

#import "AppDelegate.h"

#import "UITableView+AutoLayoutHeader.h"

#import "APIClient.h"
#import "UserController.h"
#import "BrandController.h"
#import "GiftController.h"
#import "PaymentController.h"
#import "JackpotController.h"
#import "RedPacketController.h"
#import "ClubController.h"

#import "FZUser.h"
#import "FZBrand.h"
#import "FZStore.h"
#import "FZTimer.h"
#import "FZCoupon.h"
#import "FZLocalNotificationManager.h"

@interface GlobalConstants : NSObject

+ (NSDateFormatter *)dateApiFormatter;
+ (NSDateFormatter *)dateBirthdayShortStringFormatter;
+ (NSDateFormatter *)dateBirthdayLongStringFormatter;
+ (NSDateFormatter *)dateBirthdayUpcomingFormatter;
+ (NSDateFormatter *)dateOrderHistoryFormatter;
+ (NSDateFormatter *)standardFormatter;
+ (NSDateFormatter *)jackpotDrawHistoryFormatter;
+ (NSDateFormatter *)jackpotChooseFormatter;
+ (NSDateFormatter *)jackpotPaySuccessFormatter;
+ (NSDateFormatter *)jackpotTicketsValidFormatter;
+ (NSDateFormatter *)redeemStartEndFormatter;
+ (NSDateFormatter *)clubOfferRedeemDateFormatter;

+ (UIStoryboard*)mainStoryboard;
+ (UIStoryboard*)extraStoryboard;
+ (UIStoryboard*)brandStoryboard;
+ (UIStoryboard*)rateStoryboard;
+ (UIStoryboard*)paymentStoryboard;
+ (UIStoryboard*)brandFilterStoryboard;
+ (UIStoryboard*)topUpStoryboard;
+ (UIStoryboard*)jackpotStoryboard;
+ (UIStoryboard*)redPacketsStoryboard;
+ (UIStoryboard*)clubStoryboard;


@end
