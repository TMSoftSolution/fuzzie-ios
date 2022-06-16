//
//  BannerTableViewCell.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 21/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerTableViewCellDelegate <NSObject>

- (void)bannerWasClicked:(NSDictionary *)bannerDict;

@end

@interface BannerTableViewCell : UITableViewCell

@property (weak, nonatomic) id<BannerTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSArray *bannerArray;

@end
