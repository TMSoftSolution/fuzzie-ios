//
//  RedPacketSentDetailsViewController.h
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketSentDetailsViewController : FZBaseViewController

@property (strong, nonatomic) NSDictionary *dictionary;
@property (strong, nonatomic) NSMutableArray *openedRedPackcets;
@property (assign, nonatomic) BOOL allPacketsOpened;
@property (strong, nonatomic) NSString *bundleId;

@end
