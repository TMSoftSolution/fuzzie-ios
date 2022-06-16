//
//  FZData.h
//  Fuzzie
//
//  Created by mac on 6/26/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FZData : NSObject

+ (instancetype)sharedInstance;
+ (void)resetSharedInstance;

// Selected Tab
@property (assign, nonatomic) NSUInteger selectedTab;

// Home Data
@property (strong, nonatomic) NSArray *brandArray;
@property (strong, nonatomic) NSSet *brandSet;

@property (strong, nonatomic) NSArray *bannerArray;
@property (strong, nonatomic) NSArray *miniBannerArray;

@property (strong, nonatomic) NSArray *topArray;
@property (strong, nonatomic) NSArray *recommendedBrandArray;
@property (strong, nonatomic) NSArray *clubBrandArray;
@property (strong, nonatomic) NSArray *popularBrandArray;
@property (strong, nonatomic) NSArray *latestBrandArray;

@property (strong, nonatomic) NSArray *categoryArray;
@property (strong, nonatomic) NSArray *subCategoryArray;
@property (strong, nonatomic) NSMutableSet *filterSubCategoryIds;

@property (strong, nonatomic) NSArray *fuzzieFriends;
@property (assign, nonatomic) BOOL bankUploaded;
@property (strong, nonatomic) NSNumber *assignedTicketsCountWithRedPacketBundle;

// Jackpot State
@property (strong, nonatomic) NSNumber *jackpotDrawId;
@property (strong, nonatomic) NSString *jackpotDrawTime;
@property (strong, nonatomic) NSString *jackpotNextDrawTime;
@property (assign, nonatomic) BOOL enableJackpot;
@property (assign, nonatomic) BOOL isLiveDraw;
@property (assign, nonatomic) int ticketsLimitPerWeek;
@property (assign, nonatomic) BOOL isInBackground;

@property (assign, nonatomic) BOOL activeOnlineRedeemGiftPage;
@property (assign, nonatomic) BOOL isHomeLoading;

// User Data
@property (strong, nonatomic) NSDictionary *bagDict;
@property (strong, nonatomic) NSMutableArray *activeGiftBox;
@property (strong, nonatomic) NSMutableArray *usedGiftBox;
@property (strong, nonatomic) NSMutableArray *sentGiftBox;
@property (strong, nonatomic) NSMutableArray *receivedRedPackets;
@property (strong, nonatomic) NSMutableArray *sentRedPacketBundles;

@property (strong, nonatomic) CLLocation *currentLocation;
@property (assign, nonatomic) BOOL isSelectedStore;
@property (assign, nonatomic) BOOL isSelectedList;
@property (assign, nonatomic) BOOL goFriendsListFromHome;

@property (assign, nonatomic) BOOL isShowingRatePage;

@property (strong, nonatomic) NSDictionary *selectedPaymentMethod;
@property (assign, nonatomic) BOOL tempCardInfoInputed;
@property (strong, nonatomic) NSDictionary *tempCardInfo;
// Brand List Filter
@property (strong, nonatomic) NSArray *brandListSortItemArray;
@property (assign, nonatomic) int selectedSortIndex;
@property (strong, nonatomic) NSMutableSet *selectedCategoryIds;
@property (strong, nonatomic) NSMutableSet *selectedRefineSubCategoryIds;

// Jackpot Brand List Filter
@property (strong, nonatomic) NSArray *jackpotListSortItemArray;
@property (assign, nonatomic) int selectedJackpotSortIndex;
@property (strong, nonatomic) NSMutableSet *selectedJackpotRefineSubCategoryIds;

// Jackpot Coupon
@property (strong, nonatomic) NSArray *coupons;
@property (strong, nonatomic) NSNumber *ticketsCount;
@property (assign, nonatomic) BOOL backOriginalPaymentPage;
@property (strong, nonatomic) NSDictionary *jackpotResult;
@property (strong, nonatomic) NSString *liveDrawStreamingUrl;

// Club Home Data
@property (strong, nonatomic) NSArray *trendingStores;
@property (strong, nonatomic) NSArray *nearByStores;
@property (strong, nonatomic) NSArray *freshStores;
@property (strong, nonatomic) NSArray *flashSales;
@property (strong, nonatomic) NSArray *topBrands;
@property (strong, nonatomic) NSArray *clubCategories;
@property (strong, nonatomic) NSArray *clubBrandTypes;
@property (strong, nonatomic) NSArray *clubStores;
@property (strong, nonatomic) NSArray *clubPlaces;
@property (strong, nonatomic) NSArray *clubBanners;
@property (strong, nonatomic) NSArray *clubMiniBanners;
@property (strong, nonatomic) NSArray *clubFaqs;
@property (strong, nonatomic) NSArray *clubTerms;

@property (strong, nonatomic) NSArray *redeemedClubOffers;

+ (void)removeActiveGift:(NSDictionary*)gift;
+ (void)removeUsedGift:(NSDictionary*)gift;

+ (FZBrand*) getBrandById:(NSString*)brandId;
+ (NSArray*)getUpcomingBirthdays;
+ (FZUser*) getDummyUser;
+ (NSArray*) getStoreArray;
+ (NSDictionary*) getSortedStores:(NSArray*)storeArray;
+ (FZStore*) getStoreById:(NSString*)storeId;
+ (NSArray*) getUsedSubCategories;
+ (NSArray*) getUsedSubCategoryIds;
+ (void) setFullFilterSubCategoris;

+ (NSArray*) getSubCategoriesWith:(NSArray*)brandArray;
+ (NSArray*) getCategoriesWith:(NSArray*)brandArray;
+ (NSArray*) getSubCategoriesWithCouponArray:(NSArray*)couponArray;

// State Jackpot winning page show case.
+ (NSArray*)getPowerUpPacks;
+ (void)saveWinningResult:(NSDictionary*)dictonary;
+ (NSDictionary*)getWinningResult;
+ (BOOL)alreadyShownWinningPage:(NSDictionary*)winningDictionary;
+ (BOOL)isCuttingOffLiveDraw;
+ (FZCoupon*)getCouponById:(NSString*)couponId;

+ (void)replaceActiveGift:(NSDictionary*)giftDict;
+ (void)replaceSentGift:(NSDictionary*)giftDict;
+ (BOOL)alreadyExistUsedGift:(NSDictionary*)giftDict;

+ (NSArray*)getMiniBanners:(NSString*)bannerType;

+ (void)replaceReceivedRedPacket:(NSDictionary*)redPacket;

// Fuzzie Club
+ (NSDictionary*)getBrandType:(NSNumber*)brandTypeId;
+ (NSDictionary*)getOfferType:(NSNumber*)offerId brandType:(NSDictionary*)brandType;
+ (NSDictionary*)getClubStore:(NSString*)storeId stores:(NSArray*)stores;

@end
