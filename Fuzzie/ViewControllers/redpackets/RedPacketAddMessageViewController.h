//
//  RedPacketAddMessageViewController.h
//  Fuzzie
//
//  Created by Joma on 3/29/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedPacketAddMessageViewControllerDelegate <NSObject>

- (void)messageAdded:(NSString*)message;

@end

@interface RedPacketAddMessageViewController : FZBaseViewController

@property (weak, nonatomic) id<RedPacketAddMessageViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *message;

@end
