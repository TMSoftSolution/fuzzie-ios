//
//  RedPacketController.h
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^DictionaryBlock)(NSDictionary *dictionary);
typedef void (^DictionaryWithErrorBlock)(NSDictionary *dictionary, NSError *error);
typedef void (^ArrayWithErrorBlock)(NSArray *array, NSError *error);
typedef void (^ErrorBlock)(NSError *error);

@interface RedPacketController : NSObject

+ (void)makeRedPacketsBundle:(NSString*)message numberOfRedPackets:(int)number splitType:(NSString*)spliteType value:(CGFloat)value ticketCount:(NSNumber*)ticketCount promoCode:(NSString*)promoCode completion:(DictionaryWithErrorBlock)completion;
+ (void)confirmReceivedRedPacket:(NSString*)redPacketId completion:(DictionaryWithErrorBlock)completion;
+ (void)openReceivedRedPacket:(NSString*)redPacketId completion:(DictionaryWithErrorBlock)completion;
+ (void)getSentRedPacketBundles:(ArrayWithErrorBlock)completion;
+ (void)getReceivedRedPackets:(ArrayWithErrorBlock)completion;
+ (void)getLearnMore:(ArrayWithErrorBlock)completion;
+ (void)getAssignedRedPackets:(NSString*)bundleId completion:(ArrayWithErrorBlock)completion;
+ (void)sendRedPacketViaEmail:(NSString*)redPacketBundleId email:(NSString*)email copy:(BOOL)copy completion:(DictionaryWithErrorBlock)completion;
+ (void)getRedPacketBundle:(NSString*)bundleId completion:(DictionaryWithErrorBlock)completion;

@end
