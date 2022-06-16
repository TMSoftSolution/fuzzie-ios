//
//  UserController.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 17/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZUser.h"
#import "FZFacebookFriend.h"

typedef void (^UserBlock)(FZUser *user);
typedef void (^UserWithErrorBlock)(FZUser *user, NSError *error);
typedef void (^DictionaryBlock)(NSDictionary *dictionary);
typedef void (^DictionaryWithErrorBlock)(NSDictionary *dictionary, NSError *error);
typedef void (^ArrayWithErrorBlock)(NSArray *array, NSError *error);
typedef void (^ErrorBlock)(NSError *error);


@interface UserController : NSObject

@property (strong, nonatomic) FZUser *currentUser;
@property (strong, nonatomic) NSArray *facebookFriends;


+ (instancetype)sharedInstance;

+ (void)setUser:(FZUser*)user;
+ (void)decreaseActiveGiftCount:(int)offset;
+ (void)increaseActiveGiftCount:(int)offset;
+ (void)setUnopenedActiveGiftCountWithOffset:(int)offset;
+ (void)resetUnopenedGiftCount;
+ (void)resetUnopenedTicketCount;
+ (void)likeBrandWithId:(NSString*)brandId isLike:(BOOL)isLike;
+ (void)wishListBrandWithId:(NSString*)brandId isWish:(BOOL)isWish;
+ (void)bookmarkStoreWithId:(NSString*)storeId bookmark:(BOOL)bookmark;

+ (void)signupUserViaEmail:(NSString *)email password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName birthday:(NSString *)birthday phoneNumber:(NSString *)phoneNumber profileImage:(UIImage *)profileImage gender:(NSString *)gender referralCode:(NSString*)referralCode withSuccess:(DictionaryBlock)successBlock failure:(ErrorBlock)failureBlock;
+ (void)activateAccountWithOTP:(NSString *)OTP withSuccess:(UserBlock)successBlock failure:(ErrorBlock)failureBlock;
+ (void)resentOTPWithSuccess:(DictionaryBlock)successBlock failure:(ErrorBlock)failureBlock;
+ (void)checkReferralCodeValidation:(NSString *)code completion:(DictionaryWithErrorBlock)completion;

+ (void)checkPhoneRegistered:(NSString*)phone withCompletion:(ErrorBlock)completion;
+ (void)loginUserViaPhone:(NSString *)phone otp:(NSString *)otp withSuccess:(UserBlock)successBlock failure:(ErrorBlock)failureBlock;
+ (void)loginUserWithFacebookToken:(NSString *)facebookToken withSuccess:(UserBlock)successBlock failure:(ErrorBlock)failureBlock;
+ (void)signUpNewFacebookUser:(NSDictionary *)userDetails andProfileImage:(UIImage *)image withCompletion:(UserWithErrorBlock)completion;

+ (void)getUserProfileWithCompletion:(UserWithErrorBlock)completion;
+ (void)updateUserProfile:(NSDictionary *)userDetails withCompletion:(UserWithErrorBlock)completion;
+ (void)updateProfileImageWithImage:(UIImage *)image withCompletion:(UserWithErrorBlock)completion;
+ (void)updatePasswordWithCurrentPassword:(NSString*)currentPassword andNewPassword:(NSString *)password withCompletion:(ErrorBlock)completion;
+ (void)requestUpdatePhoneNumber:(NSString *)phoneNumber withCompletion:(ErrorBlock)completion;
+ (void)verifyNewPhoneNumberWithOTP:(NSString *)OTP withCompletion:(UserWithErrorBlock)completion;

+ (void)resetPasswordWithEmail:(NSString *)email withCompletion:(ErrorBlock)completion;
+ (void)updateEmail:(NSString*)email withCompletion:(UserWithErrorBlock)completion;
+ (void)updateFirstName:(NSString*)firstName withCompletion:(UserWithErrorBlock)completion;
+ (void)updateLastName:(NSString*)lastName withCompletion:(UserWithErrorBlock)completion;
+ (void)updateBirthdate:(NSString*)birthdate withCompletion:(UserWithErrorBlock)completion;
+ (void)updateGender:(NSString*)gender withCompletion:(UserWithErrorBlock)completion;
+ (void)deleteProfileImage:(UserWithErrorBlock)completion;

+ (void)getTransactionsWithCompletion:(DictionaryWithErrorBlock)completion;

+ (void)getUserLikeBrandWithUserId:(NSString *)userId And:(ArrayWithErrorBlock)completion;
+ (void)getUserWishlistBrandWithUserId:(NSString *)userId And:(ArrayWithErrorBlock)completion;
+ (void)updatePrivacyShareLikeWishlistState:(BOOL)state withErrorBlock:(ErrorBlock)completionBlock;
+ (void)setDisplayGiftingPage:(BOOL)state withErrorBlock:(ErrorBlock)completionBlock;
+ (void)setCoachMarkerDisplay:(BOOL)state withErrorBlock:(ErrorBlock)completionBlock;

+ (void)getFriendReferral:(DictionaryWithErrorBlock) completion;

+ (void)getFriendReferralUsers:(ArrayWithErrorBlock) completion;
+ (void)getMyFuzzieFriends: (ArrayWithErrorBlock) completion;
+ (void)getFacebookLinkedFuzzieUsers: (ArrayWithErrorBlock) completion;
+ (void)getFacebookFriends: (ArrayWithErrorBlock) completion;
+ (void)getFacebookFriendsConnected: (ArrayWithErrorBlock) completion;

+ (void)getUserInfoWithId:(NSString *)userId withCompletion:(DictionaryWithErrorBlock) completion;
+ (void)saveToken:(NSString*)token withCompletion:(ErrorBlock) completion;

+ (void)getOrdersWithPage:(int)page andLimit:(int)limit withCompletion:(ArrayWithErrorBlock) completion;

// Rate Push Call after press share button on invite page
+ (void)callRatePush:(ErrorBlock) completion;

// Don't show anymore rate pop in the same day
+ (void)sendRateNotificationAfterDay:(ErrorBlock) completion;
+ (void)dontSendRateNotification;

+ (void)setJackpotLiveDrawNotification:(BOOL)state withErrorBlock:(ErrorBlock)completion;

+ (void)getClubReferral:(DictionaryWithErrorBlock) completion;
+ (void)getClubReferralUsers:(ArrayWithErrorBlock) completion;

+ (void)locationVerify:(NSString*)storeId withCompletion:(DictionaryWithErrorBlock) completion;

@end
