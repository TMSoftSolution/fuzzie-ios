//
//  HomeJackpotTeasingTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 11/8/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeJackpotTeasingTableViewCellDelegate <NSObject>

- (void)jackpotLearnMoreButtonPressed;

@end

@interface HomeJackpotTeasingTableViewCell : UITableViewCell

@property (weak, nonatomic) id<HomeJackpotTeasingTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnLearnMore;

+ (CGFloat) estimateHeight;

@end
