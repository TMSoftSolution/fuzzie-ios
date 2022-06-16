//
//  RedPacketAddCreditsViewController.h
//  Fuzzie
//
//  Created by Joma on 3/29/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedPacketAddCreditsViewControllerDelegate <NSObject>

- (void)creditAdded:(NSNumber*)credit isRandomMode:(BOOL)isRandomMode;

@end

@interface RedPacketAddCreditsViewController : FZBaseViewController

@property (weak, nonatomic) id<RedPacketAddCreditsViewControllerDelegate> delegate;

@property (strong, nonatomic) FZUser *user;

@property (assign, nonatomic) BOOL isRandomMode;
@property (assign, nonatomic) NSNumber *creditAmount;
@property (assign, nonatomic) NSNumber *quantity;
@property (assign, nonatomic) NSNumber *tempAmount;
@property (assign, nonatomic) BOOL tempMode;

@end
