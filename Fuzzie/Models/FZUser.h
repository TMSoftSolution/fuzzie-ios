//
//  FZUser.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 18/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "Mantle.h"

@interface FZUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *fuzzieId;
@property (nonatomic, strong) NSString *facebookId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *formatttedBirthday;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *profileImage;
@property (nonatomic, strong) NSString *bearAvatar;
@property (nonatomic, strong) NSNumber *credits;
@property (nonatomic, strong) NSNumber *cashableCredits;
@property (nonatomic, strong) NSNumber *cashbackEarned;
@property (nonatomic, strong) NSNumber *isFriend;
@property (nonatomic, strong) NSNumber *sharesLikesWishlist;
@property (nonatomic, strong) NSNumber *displayGiftingPage;
@property (nonatomic, strong) NSNumber *displayCoachMarker;
@property (nonatomic, strong) NSNumber *displayJackpotAvailablePage;
@property (nonatomic, strong) NSNumber *showLuckyPacketInstructions;
@property (nonatomic, strong) NSNumber *jackpotDrawNotification;
@property (nonatomic, strong) NSNumber *showClubInstructions;
@property (nonatomic, strong) NSDate *powerUpExpiryDate;
@property (nonatomic, strong) NSString *referralCode;
@property (nonatomic, strong) NSString *referralUrl;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSNumber *currentJackpotTicketsCount;
@property (nonatomic, strong) NSNumber *nextJackpotTicketsCount;
@property (nonatomic, strong) NSNumber *availableJackpotTicketsCount;
@property (nonatomic, strong) NSString *jackpotTicketsExpirationDate;
@property (nonatomic, strong) NSNumber *activeGiftCount;
@property (nonatomic, strong) NSNumber *unOpenedActiveGiftCount;
@property (nonatomic, strong) NSNumber *unOpenedTicketCount;
@property (nonatomic, strong) NSNumber *unOpenedRedPacketCount;
@property (nonatomic, strong) NSNumber *openedRedPAcketCount;
@property (nonatomic, strong) NSNumber *isFirstToSendRedPacket;
@property (nonatomic, strong) NSArray *wishListIds;
@property (nonatomic, strong) NSArray *likedListIds;
@property (nonatomic, strong) NSArray *bookmarkedStoreIds;
@property (nonatomic, strong) NSNumber *clubMember;
@property (nonatomic, strong) NSString *clubSubscribeDate;
@property (nonatomic, strong) NSString *clubReferralCode;
@property (nonatomic, strong) NSNumber *clubMemberPrice;
@property (nonatomic, strong) NSNumber *clubSubscribeCashback;
@property (nonatomic, strong) NSNumber *clubSavings;
@property (nonatomic, strong) NSString *rules;
@property (nonatomic, strong) NSNumber *totalCreditsEarned;
@property (nonatomic, strong) NSNumber *totalJackpotTicketsEarned;

@end
