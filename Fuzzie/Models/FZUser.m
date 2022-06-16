//
//  FZUser.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 18/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "FZUser.h"

@implementation FZUser

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    return dateFormatter;
}



+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    
    return @{ @"name": @"name",
              @"firstName": @"first_name",
              @"lastName": @"last_name",
              @"email": @"email",
              @"phone": @"phone",
              @"facebookId": @"facebook_id",
              @"fuzzieId": @"id",
              @"gender": @"gender",
              @"birthday": @"birthdate",
              @"formatttedBirthday": @"birthdate_formatted",
              @"isFriend": @"friend",
              @"profileImage": @"avatar",
              @"credits": @"wallet.balance",
              @"cashableCredits":@"wallet.encashable_balance",
              @"sharesLikesWishlist": @"settings.shares_likes_and_wish_list",
              @"displayGiftingPage": @"settings.display_gifting_page",
              @"displayCoachMarker": @"settings.display_tutorial",
              @"displayJackpotAvailablePage": @"settings.show_jackpot_available_page",
              @"showLuckyPacketInstructions" : @"settings.show_lucky_packet_instructions",
              @"showClubInstructions" : @"settings.show_fuzzie_club_instructions",
              @"jackpotDrawNotification": @"settings.jackpot_draw_notification",
              @"cashbackEarned": @"cash_back_earned",
              @"powerUpExpiryDate": @"power_up_expiration_time",
              @"referralCode":@"referral_code",
              @"referralUrl":@"referral_url",
              @"status":@"status",
              @"currentJackpotTicketsCount":@"current_jackpot_tickets_count",
              @"nextJackpotTicketsCount":@"next_jackpot_tickets_count",
              @"availableJackpotTicketsCount": @"available_jackpot_tickets_count",
              @"jackpotTicketsExpirationDate": @"jackpot_tickets_expiration_date",
              @"activeGiftCount":@"active_gift_count",
              @"unOpenedActiveGiftCount":@"unopened_gifts_count",
              @"unOpenedTicketCount":@"unopened_tickets_count",
              @"unOpenedRedPacketCount":@"unopened_red_packets_count",
              @"openedRedPAcketCount":@"opened_red_packets_count",
              @"isFirstToSendRedPacket":@"settings.first_red_packet_bundle_bought",
              @"wishListIds":@"wish_list_ids",
              @"likedListIds":@"liked_list_ids",
              @"bookmarkedStoreIds":@"bookmarked_store_ids",
              @"clubMember":@"fuzzie_club.membership",
              @"clubSubscribeDate":@"fuzzie_club.subscription_date",
              @"clubReferralCode":@"fuzzie_club.referral_code",
              @"clubMemberPrice":@"fuzzie_club.membership_price",
              @"clubSubscribeCashback":@"fuzzie_club.referral_bonus_for_subscriber",
              @"clubSavings":@"fuzzie_club.savings",
              @"rules" : @"fuzzie_club.rules_of_use",
              @"totalCreditsEarned" : @"referral_rewards.total_credits_earned",
              @"totalJackpotTicketsEarned" : @"referral_rewards.total_jackpot_tickets_earned"
              };
    
}

+ (NSValueTransformer *)powerUpExpiryDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

@end
