//
//  JackpotHomePowrupPackTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 2/9/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JackpotHomePowrupPackTableViewCellDelegate <NSObject>

- (void)powerupPackBannerClicked;

@end

@interface JackpotHomePowrupPackTableViewCell : UITableViewCell

@property (weak, nonatomic) id<JackpotHomePowrupPackTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet TKRoundedView *packContainerView;

@end
