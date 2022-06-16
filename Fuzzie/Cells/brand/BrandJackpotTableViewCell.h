//
//  BrandJackpotTableViewCell.h
//  Fuzzie
//
//  Created by mac on 9/19/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrandJackpotTableViewCellDelegate <NSObject>

- (void)jackpotCellTapped;

@end

@interface BrandJackpotTableViewCell : UITableViewCell

@property (weak, nonatomic) id<BrandJackpotTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *ivBanner;


@end
